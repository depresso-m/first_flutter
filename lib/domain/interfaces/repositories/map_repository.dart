import '../../../core/models/geo_point.dart';
import '../../../core/models/pharmacy.dart';

/// Repository interface for map-related operations
abstract class MapRepository {
  /// Geocode a city name to coordinates
  Future<GeoPoint?> geocodeCity(String cityName);

  /// Get pharmacies within a radius of a point
  Future<List<Pharmacy>> getPharmaciesInRadius(GeoPoint center, int radiusMeters);

  /// Get pharmacies within map bounds
  Future<List<Pharmacy>> getPharmaciesInBounds(MapBounds bounds);

  /// Filter pharmacies by name within bounds
  Future<List<Pharmacy>> filterPharmacies(MapBounds bounds, String? nameFilter);

  /// Get tile URL for OSM map
  String getTileUrl(int x, int y, int z);
}
