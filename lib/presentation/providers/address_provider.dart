import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/address_suggestion.dart';
import '../../di/injection_container.dart';
import '../../domain/usecases/address/refine_address_usecase.dart';
import '../../domain/usecases/address/suggest_by_city_usecase.dart';
import '../../domain/usecases/address/suggest_cities_usecase.dart';
import '../../domain/usecases/address/suggest_full_address_usecase.dart';
import '../../domain/usecases/address/suggest_streets_usecase.dart';

// State providers
final cityQueryProvider = StateProvider<String>((ref) => '');
final selectedCityProvider = StateProvider<AddressSuggestion?>((ref) => null);
final addressQueryProvider = StateProvider<String>((ref) => '');

// Use case providers
final suggestCitiesUseCaseProvider = Provider<SuggestCitiesUseCase>(
  (ref) => getIt<SuggestCitiesUseCase>(),
);

final suggestStreetsUseCaseProvider = Provider<SuggestStreetsUseCase>(
  (ref) => getIt<SuggestStreetsUseCase>(),
);

final suggestFullAddressUseCaseProvider = Provider<SuggestFullAddressUseCase>(
  (ref) => getIt<SuggestFullAddressUseCase>(),
);

final suggestByCityUseCaseProvider = Provider<SuggestByCityUseCase>(
  (ref) => getIt<SuggestByCityUseCase>(),
);

final refineAddressUseCaseProvider = Provider<RefineAddressUseCase>(
  (ref) => getIt<RefineAddressUseCase>(),
);

// City suggestions provider with debounce
final citySuggestionsProvider = FutureProvider.autoDispose<List<AddressSuggestion>>((ref) async {
  final query = ref.watch(cityQueryProvider);
  
  if (query.trim().length < 2) return [];
  
  // Debounce: wait 300ms after last change
  await Future.delayed(const Duration(milliseconds: 300));
  
  // Cancel if query changed during debounce
  if (ref.read(cityQueryProvider) != query) {
    throw Exception('Cancelled');
  }
  
  final useCase = ref.watch(suggestCitiesUseCaseProvider);
  return await useCase.execute(query);
});

// Address suggestions provider - respects selected city
final addressSuggestionsProvider = FutureProvider.autoDispose<List<AddressSuggestion>>((ref) async {
  final query = ref.watch(addressQueryProvider);
  final selectedCity = ref.watch(selectedCityProvider);
  
  if (query.trim().length < 2) return [];
  
  // Debounce
  await Future.delayed(const Duration(milliseconds: 300));
  
  // Cancel if query changed
  if (ref.read(addressQueryProvider) != query) {
    throw Exception('Cancelled');
  }
  
  // If city is selected, restrict search to that city
  if (selectedCity != null && selectedCity.data.cityFiasId != null) {
    final useCase = ref.watch(suggestByCityUseCaseProvider);
    return await useCase.execute(query, selectedCity.data.cityFiasId!);
  }
  
  // Otherwise, search full address
  final useCase = ref.watch(suggestFullAddressUseCaseProvider);
  return await useCase.execute(query);
});

/// Notifier for managing address autocomplete state
class AddressAutocompleteNotifier extends StateNotifier<AddressAutocompleteState> {
  final SuggestCitiesUseCase _suggestCitiesUseCase;
  final SuggestFullAddressUseCase _suggestFullAddressUseCase;
  final SuggestByCityUseCase _suggestByCityUseCase;

  AddressAutocompleteNotifier({
    required SuggestCitiesUseCase suggestCitiesUseCase,
    required SuggestFullAddressUseCase suggestFullAddressUseCase,
    required SuggestByCityUseCase suggestByCityUseCase,
  })  : _suggestCitiesUseCase = suggestCitiesUseCase,
        _suggestFullAddressUseCase = suggestFullAddressUseCase,
        _suggestByCityUseCase = suggestByCityUseCase,
        super(const AddressAutocompleteState());

  Future<void> searchCities(String query) async {
    if (query.trim().length < 2) {
      state = state.copyWith(suggestions: [], isLoading: false);
      return;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      final suggestions = await _suggestCitiesUseCase.execute(query);
      state = state.copyWith(suggestions: suggestions, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Ошибка загрузки городов',
      );
    }
  }

  Future<void> searchAddresses(String query, {String? cityFiasId}) async {
    if (query.trim().length < 2) {
      state = state.copyWith(suggestions: [], isLoading: false);
      return;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      List<AddressSuggestion> suggestions;
      if (cityFiasId != null) {
        suggestions = await _suggestByCityUseCase.execute(query, cityFiasId);
      } else {
        suggestions = await _suggestFullAddressUseCase.execute(query);
      }
      state = state.copyWith(suggestions: suggestions, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Ошибка загрузки адресов',
      );
    }
  }

  void selectSuggestion(AddressSuggestion suggestion) {
    state = state.copyWith(
      selectedSuggestion: suggestion,
      suggestions: [],
    );
  }

  void clear() {
    state = const AddressAutocompleteState();
  }
}

/// State for address autocomplete
class AddressAutocompleteState {
  final List<AddressSuggestion> suggestions;
  final AddressSuggestion? selectedSuggestion;
  final bool isLoading;
  final String? error;

  const AddressAutocompleteState({
    this.suggestions = const [],
    this.selectedSuggestion,
    this.isLoading = false,
    this.error,
  });

  AddressAutocompleteState copyWith({
    List<AddressSuggestion>? suggestions,
    AddressSuggestion? selectedSuggestion,
    bool? isLoading,
    String? error,
  }) {
    return AddressAutocompleteState(
      suggestions: suggestions ?? this.suggestions,
      selectedSuggestion: selectedSuggestion ?? this.selectedSuggestion,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

// Provider for address autocomplete notifier
final addressAutocompleteProvider = StateNotifierProvider.autoDispose<
    AddressAutocompleteNotifier, AddressAutocompleteState>((ref) {
  return AddressAutocompleteNotifier(
    suggestCitiesUseCase: ref.watch(suggestCitiesUseCaseProvider),
    suggestFullAddressUseCase: ref.watch(suggestFullAddressUseCaseProvider),
    suggestByCityUseCase: ref.watch(suggestByCityUseCaseProvider),
  );
});
