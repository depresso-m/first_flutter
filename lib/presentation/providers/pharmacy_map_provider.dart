import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/geo_point.dart';
import '../../core/models/pharmacy.dart';
import '../../di/injection_container.dart';
import '../../domain/usecases/map/filter_pharmacies_usecase.dart';
import '../../domain/usecases/map/geocode_city_usecase.dart';
import '../../domain/usecases/map/get_pharmacies_by_radius_usecase.dart';
import '../../domain/usecases/map/update_pharmacies_region_usecase.dart';

// Use case providers
final geocodeCityUseCaseProvider = Provider<GeocodeCityUseCase>(
  (ref) => getIt<GeocodeCityUseCase>(),
);

final getPharmaciesByRadiusUseCaseProvider = Provider<GetPharmaciesByRadiusUseCase>(
  (ref) => getIt<GetPharmaciesByRadiusUseCase>(),
);

final updatePharmaciesRegionUseCaseProvider = Provider<UpdatePharmaciesRegionUseCase>(
  (ref) => getIt<UpdatePharmaciesRegionUseCase>(),
);

final filterPharmaciesUseCaseProvider = Provider<FilterPharmaciesUseCase>(
  (ref) => getIt<FilterPharmaciesUseCase>(),
);

/// State for the pharmacy map
class PharmacyMapState {
  final GeoPoint? center;
  final int radius;
  final List<Pharmacy> pharmacies;
  final bool isLoading;
  final String? error;
  final MapBounds? bounds;
  final Pharmacy? selectedPharmacy;
  final String? searchQuery;

  const PharmacyMapState({
    this.center,
    this.radius = 2000,
    this.pharmacies = const [],
    this.isLoading = false,
    this.error,
    this.bounds,
    this.selectedPharmacy,
    this.searchQuery,
  });

  PharmacyMapState copyWith({
    GeoPoint? center,
    int? radius,
    List<Pharmacy>? pharmacies,
    bool? isLoading,
    String? error,
    MapBounds? bounds,
    Pharmacy? selectedPharmacy,
    String? searchQuery,
    bool clearError = false,
    bool clearSelectedPharmacy = false,
  }) {
    return PharmacyMapState(
      center: center ?? this.center,
      radius: radius ?? this.radius,
      pharmacies: pharmacies ?? this.pharmacies,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      bounds: bounds ?? this.bounds,
      selectedPharmacy: clearSelectedPharmacy ? null : (selectedPharmacy ?? this.selectedPharmacy),
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

/// Notifier for managing pharmacy map state
class PharmacyMapNotifier extends StateNotifier<PharmacyMapState> {
  final GeocodeCityUseCase _geocodeCityUseCase;
  final GetPharmaciesByRadiusUseCase _getPharmaciesUseCase;
  final UpdatePharmaciesRegionUseCase _updateRegionUseCase;
  final FilterPharmaciesUseCase _filterPharmaciesUseCase;

  Timer? _debounceTimer;

  PharmacyMapNotifier({
    required GeocodeCityUseCase geocodeCityUseCase,
    required GetPharmaciesByRadiusUseCase getPharmaciesUseCase,
    required UpdatePharmaciesRegionUseCase updateRegionUseCase,
    required FilterPharmaciesUseCase filterPharmaciesUseCase,
  })  : _geocodeCityUseCase = geocodeCityUseCase,
        _getPharmaciesUseCase = getPharmaciesUseCase,
        _updateRegionUseCase = updateRegionUseCase,
        _filterPharmaciesUseCase = filterPharmaciesUseCase,
        super(const PharmacyMapState());

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }

  /// Set city and load pharmacies
  Future<void> setCity(String cityName) async {
    if (cityName.trim().isEmpty) return;

    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final center = await _geocodeCityUseCase.execute(cityName);
      if (center == null) {
        state = state.copyWith(
          isLoading: false,
          error: 'Город "$cityName" не найден',
        );
        return;
      }

      state = state.copyWith(center: center);
      await loadPharmacies();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Ошибка при поиске города: $e',
      );
    }
  }

  /// Load pharmacies for current center and radius
  Future<void> loadPharmacies() async {
    if (state.center == null) return;

    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final pharmacies = await _getPharmaciesUseCase.execute(
        state.center!,
        state.radius,
      );

      state = state.copyWith(pharmacies: pharmacies, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Ошибка загрузки аптек: $e',
      );
    }
  }

  /// Set search radius
  void setRadius(int radius) {
    state = state.copyWith(radius: radius);
    _debounce(loadPharmacies);
  }

  /// Handle map movement
  void onMapMoved(MapBounds newBounds) {
    state = state.copyWith(bounds: newBounds);
    _debounce(() => _updatePharmaciesForBounds(newBounds));
  }

  /// Update pharmacies for new bounds
  Future<void> _updatePharmaciesForBounds(MapBounds bounds) async {
    state = state.copyWith(isLoading: true);

    try {
      List<Pharmacy> pharmacies;
      if (state.searchQuery != null && state.searchQuery!.isNotEmpty) {
        pharmacies = await _filterPharmaciesUseCase.execute(
          bounds,
          state.searchQuery,
        );
      } else {
        pharmacies = await _updateRegionUseCase.execute(bounds);
      }

      state = state.copyWith(pharmacies: pharmacies, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Ошибка обновления аптек: $e',
      );
    }
  }

  /// Search pharmacies by name
  Future<void> searchPharmacies(String query) async {
    state = state.copyWith(searchQuery: query);

    if (state.bounds == null) return;

    _debounce(() async {
      state = state.copyWith(isLoading: true);

      try {
        final pharmacies = await _filterPharmaciesUseCase.execute(
          state.bounds!,
          query.isEmpty ? null : query,
        );

        state = state.copyWith(pharmacies: pharmacies, isLoading: false);
      } catch (e) {
        state = state.copyWith(
          isLoading: false,
          error: 'Ошибка поиска: $e',
        );
      }
    });
  }

  /// Select a pharmacy
  void selectPharmacy(Pharmacy? pharmacy) {
    if (pharmacy == null) {
      state = state.copyWith(clearSelectedPharmacy: true);
    } else {
      state = state.copyWith(selectedPharmacy: pharmacy);
    }
  }

  /// Clear error
  void clearError() {
    state = state.copyWith(clearError: true);
  }

  /// Debounce helper
  void _debounce(FutureOr<void> Function() action) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      await action();
    });
  }
}

// Provider for pharmacy map
final pharmacyMapProvider =
    StateNotifierProvider.autoDispose<PharmacyMapNotifier, PharmacyMapState>(
  (ref) => PharmacyMapNotifier(
    geocodeCityUseCase: ref.watch(geocodeCityUseCaseProvider),
    getPharmaciesUseCase: ref.watch(getPharmaciesByRadiusUseCaseProvider),
    updateRegionUseCase: ref.watch(updatePharmaciesRegionUseCaseProvider),
    filterPharmaciesUseCase: ref.watch(filterPharmaciesUseCaseProvider),
  ),
);

// Default city for initial map view
const defaultCity = 'Москва';
const defaultCenter = GeoPoint(latitude: 55.7558, longitude: 37.6173);
