import '../../core/constants/api_constants.dart';
import '../../core/models/geo_point.dart';
import '../../core/models/pharmacy.dart';
import '../../domain/interfaces/repositories/map_repository.dart';
import '../datasources/api/nominatim/nominatim_api_datasource.dart';
import '../datasources/api/overpass/overpass_api_datasource.dart';
import '../mappers/pharmacy_mapper.dart';

/// Implementation of MapRepository using Nominatim and Overpass APIs
class MapRepositoryImpl implements MapRepository {
  final NominatimApiDataSource _nominatimApi;
  final OverpassApiDataSource _overpassApi;

  // Cache for geocoding results
  final Map<String, _CacheEntry<GeoPoint>> _geocodeCache = {};
  // Cache for pharmacy results
  final Map<String, _CacheEntry<List<Pharmacy>>> _pharmacyCache = {};

  MapRepositoryImpl({
    required NominatimApiDataSource nominatimApi,
    required OverpassApiDataSource overpassApi,
  })  : _nominatimApi = nominatimApi,
        _overpassApi = overpassApi;

  @override
  Future<GeoPoint?> geocodeCity(String cityName) async {
    if (cityName.trim().isEmpty) return null;

    final cacheKey = cityName.toLowerCase().trim();
    final cached = _geocodeCache[cacheKey];
    if (cached != null && !cached.isExpired) {
      return cached.data;
    }

    final place = await _nominatimApi.geocodeCity(cityName);
    if (place == null) return null;

    final geoPoint = GeoPoint(
      latitude: place.latitude,
      longitude: place.longitude,
    );

    _geocodeCache[cacheKey] = _CacheEntry(geoPoint);
    return geoPoint;
  }

  @override
  Future<List<Pharmacy>> getPharmaciesInRadius(
    GeoPoint center,
    int radiusMeters,
  ) async {
    final cacheKey = '${center.latitude.toStringAsFixed(4)}_'
        '${center.longitude.toStringAsFixed(4)}_$radiusMeters';
    final cached = _pharmacyCache[cacheKey];
    if (cached != null && !cached.isExpired) {
      return cached.data;
    }

    final elements = await _overpassApi.getPharmaciesInRadius(
      center.latitude,
      center.longitude,
      radiusMeters,
    );
    
    final pharmacies = PharmacyMapper.fromOverpassDtoList(elements);
    _pharmacyCache[cacheKey] = _CacheEntry(pharmacies);
    return pharmacies;
  }

  @override
  Future<List<Pharmacy>> getPharmaciesInBounds(MapBounds bounds) async {
    final cacheKey = bounds.cacheKey;
    final cached = _pharmacyCache[cacheKey];
    if (cached != null && !cached.isExpired) {
      return cached.data;
    }

    final elements = await _overpassApi.getPharmaciesInBounds(bounds);
    final pharmacies = PharmacyMapper.fromOverpassDtoList(elements);
    
    _pharmacyCache[cacheKey] = _CacheEntry(pharmacies);
    return pharmacies;
  }

  @override
  Future<List<Pharmacy>> filterPharmacies(
    MapBounds bounds,
    String? nameFilter,
  ) async {
    if (nameFilter == null || nameFilter.trim().isEmpty) {
      return getPharmaciesInBounds(bounds);
    }

    final cacheKey = '${bounds.cacheKey}_${nameFilter.toLowerCase().trim()}';
    final cached = _pharmacyCache[cacheKey];
    if (cached != null && !cached.isExpired) {
      return cached.data;
    }

    final elements = await _overpassApi.getPharmaciesByName(bounds, nameFilter);
    final pharmacies = PharmacyMapper.fromOverpassDtoList(elements);
    
    _pharmacyCache[cacheKey] = _CacheEntry(pharmacies);
    return pharmacies;
  }

  @override
  String getTileUrl(int x, int y, int z) {
    return ApiConstants.osmTileUrl
        .replaceAll('{x}', x.toString())
        .replaceAll('{y}', y.toString())
        .replaceAll('{z}', z.toString());
  }
}

/// Simple cache entry with expiration
class _CacheEntry<T> {
  final T data;
  final DateTime createdAt;
  final Duration ttl;

  _CacheEntry(this.data, {this.ttl = const Duration(minutes: 5)})
      : createdAt = DateTime.now();

  bool get isExpired => DateTime.now().difference(createdAt) > ttl;
}
