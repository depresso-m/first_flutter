import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../../core/models/geo_point.dart';
import '../../core/models/pharmacy.dart';
import '../providers/pharmacy_map_provider.dart';
import '../widgets/back_button.dart';

class PharmacyMapScreen extends ConsumerStatefulWidget {
  const PharmacyMapScreen({super.key});

  @override
  ConsumerState<PharmacyMapScreen> createState() => _PharmacyMapScreenState();
}

class _PharmacyMapScreenState extends ConsumerState<PharmacyMapScreen> {
  final _mapController = MapController();
  final _searchController = TextEditingController();
  final _cityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize with default city
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(pharmacyMapProvider.notifier).setCity(defaultCity);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _cityController.dispose();
    _mapController.dispose();
    super.dispose();
  }

  void _onMapEvent(MapCamera camera, bool hasGesture) {
    if (!hasGesture) return;

    final bounds = MapBounds(
      northEast: GeoPoint(
        latitude: camera.visibleBounds.north,
        longitude: camera.visibleBounds.east,
      ),
      southWest: GeoPoint(
        latitude: camera.visibleBounds.south,
        longitude: camera.visibleBounds.west,
      ),
    );

    ref.read(pharmacyMapProvider.notifier).onMapMoved(bounds);
  }

  void _centerOnLocation(GeoPoint location) {
    _mapController.move(
      LatLng(location.latitude, location.longitude),
      14,
    );
  }

  @override
  Widget build(BuildContext context) {
    final mapState = ref.watch(pharmacyMapProvider);
    final theme = Theme.of(context);

    // Update map center when state changes
    ref.listen<PharmacyMapState>(pharmacyMapProvider, (previous, next) {
      if (previous?.center != next.center && next.center != null) {
        _centerOnLocation(next.center!);
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Карта аптек'),
        leading: const CustomBackButton(),
        actions: [
          if (mapState.isLoading)
            const Padding(
              padding: EdgeInsets.all(16),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          // Search controls
          _SearchControls(
            cityController: _cityController,
            searchController: _searchController,
            onCitySubmit: (city) {
              ref.read(pharmacyMapProvider.notifier).setCity(city);
            },
            onSearchChanged: (query) {
              ref.read(pharmacyMapProvider.notifier).searchPharmacies(query);
            },
          ),

          // Error message
          if (mapState.error != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              color: theme.colorScheme.errorContainer,
              child: Row(
                children: [
                  Icon(
                    Icons.error_outline,
                    color: theme.colorScheme.error,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      mapState.error!,
                      style: TextStyle(color: theme.colorScheme.error),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      ref.read(pharmacyMapProvider.notifier).clearError();
                    },
                  ),
                ],
              ),
            ),

          // Map
          Expanded(
            child: Stack(
              children: [
                FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: LatLng(
                      mapState.center?.latitude ?? defaultCenter.latitude,
                      mapState.center?.longitude ?? defaultCenter.longitude,
                    ),
                    initialZoom: 13,
                    minZoom: 4,
                    maxZoom: 18,
                    onPositionChanged: (camera, hasGesture) {
                      _onMapEvent(camera, hasGesture);
                    },
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.pharmacy',
                    ),
                    MarkerLayer(
                      markers: mapState.pharmacies
                          .where((p) => p.hasCoordinates)
                          .map((pharmacy) => _buildMarker(pharmacy))
                          .toList(),
                    ),
                  ],
                ),

                // Pharmacy count badge
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      'Аптек: ${mapState.pharmacies.length}',
                      style: TextStyle(
                        color: theme.colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),

                // Radius selector
                Positioned(
                  bottom: 16,
                  right: 16,
                  child: _RadiusSelector(
                    currentRadius: mapState.radius,
                    onRadiusChanged: (radius) {
                      ref.read(pharmacyMapProvider.notifier).setRadius(radius);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      // Bottom sheet for selected pharmacy
      bottomSheet: mapState.selectedPharmacy != null
          ? _PharmacyBottomSheet(
              pharmacy: mapState.selectedPharmacy!,
              onClose: () {
                ref.read(pharmacyMapProvider.notifier).selectPharmacy(null);
              },
            )
          : null,
    );
  }

  Marker _buildMarker(Pharmacy pharmacy) {
    final isSelected = ref.read(pharmacyMapProvider).selectedPharmacy?.id == pharmacy.id;
    
    return Marker(
      point: LatLng(pharmacy.latitude!, pharmacy.longitude!),
      width: isSelected ? 50 : 40,
      height: isSelected ? 50 : 40,
      child: GestureDetector(
        onTap: () {
          ref.read(pharmacyMapProvider.notifier).selectPharmacy(pharmacy);
        },
        child: Container(
          decoration: BoxDecoration(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Colors.red,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const Icon(
            Icons.local_pharmacy,
            color: Colors.white,
            size: 20,
          ),
        ),
      ),
    );
  }
}

class _SearchControls extends StatelessWidget {
  final TextEditingController cityController;
  final TextEditingController searchController;
  final ValueChanged<String> onCitySubmit;
  final ValueChanged<String> onSearchChanged;

  const _SearchControls({
    required this.cityController,
    required this.searchController,
    required this.onCitySubmit,
    required this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // City search
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: cityController,
                  decoration: const InputDecoration(
                    hintText: 'Город',
                    prefixIcon: Icon(Icons.location_city),
                    border: OutlineInputBorder(),
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                  ),
                  textInputAction: TextInputAction.search,
                  onSubmitted: onCitySubmit,
                ),
              ),
              const SizedBox(width: 8),
              FilledButton(
                onPressed: () => onCitySubmit(cityController.text),
                child: const Text('Найти'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Pharmacy name search
          TextField(
            controller: searchController,
            decoration: const InputDecoration(
              hintText: 'Поиск аптеки по названию',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
              isDense: true,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
            ),
            onChanged: onSearchChanged,
          ),
        ],
      ),
    );
  }
}

class _RadiusSelector extends StatelessWidget {
  final int currentRadius;
  final ValueChanged<int> onRadiusChanged;

  const _RadiusSelector({
    required this.currentRadius,
    required this.onRadiusChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final radiusOptions = [1000, 2000, 5000, 10000];

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Радиус',
            style: theme.textTheme.labelSmall,
          ),
          const SizedBox(height: 4),
          ...radiusOptions.map((radius) {
            final isSelected = radius == currentRadius;
            final label = radius >= 1000 ? '${radius ~/ 1000} км' : '$radius м';
            
            return GestureDetector(
              onTap: () => onRadiusChanged(radius),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                margin: const EdgeInsets.only(top: 4),
                decoration: BoxDecoration(
                  color: isSelected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  label,
                  style: TextStyle(
                    color: isSelected
                        ? theme.colorScheme.onPrimary
                        : theme.colorScheme.onSurface,
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _PharmacyBottomSheet extends StatelessWidget {
  final Pharmacy pharmacy;
  final VoidCallback onClose;

  const _PharmacyBottomSheet({
    required this.pharmacy,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.local_pharmacy, color: Colors.red),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pharmacy.displayName,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (pharmacy.brand != null)
                      Text(
                        pharmacy.brand!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.outline,
                        ),
                      ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: onClose,
              ),
            ],
          ),
          const SizedBox(height: 12),
          _InfoRow(
            icon: Icons.location_on,
            text: pharmacy.address,
          ),
          const SizedBox(height: 8),
          _InfoRow(
            icon: Icons.access_time,
            text: pharmacy.workingHours,
            highlight: pharmacy.isOpen24Hours,
          ),
          if (pharmacy.phone != 'Телефон не указан') ...[
            const SizedBox(height: 8),
            _InfoRow(
              icon: Icons.phone,
              text: pharmacy.phone,
            ),
          ],
          if (pharmacy.isWheelchairAccessible) ...[
            const SizedBox(height: 8),
            _InfoRow(
              icon: Icons.accessible,
              text: 'Доступно для инвалидов',
            ),
          ],
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool highlight;

  const _InfoRow({
    required this.icon,
    required this.text,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 18,
          color: highlight
              ? theme.colorScheme.primary
              : theme.colorScheme.outline,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: highlight
                  ? theme.colorScheme.primary
                  : null,
              fontWeight: highlight ? FontWeight.w600 : null,
            ),
          ),
        ),
      ],
    );
  }
}
