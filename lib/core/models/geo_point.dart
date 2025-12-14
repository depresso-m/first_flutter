import 'dart:math' as math;

/// Represents a geographic point with latitude and longitude
class GeoPoint {
  final double latitude;
  final double longitude;

  const GeoPoint({
    required this.latitude,
    required this.longitude,
  });

  /// Calculate distance to another point using Haversine formula
  /// Returns distance in meters
  double distanceTo(GeoPoint other) {
    const earthRadius = 6371000.0; // Earth's radius in meters

    final lat1Rad = latitude * math.pi / 180;
    final lat2Rad = other.latitude * math.pi / 180;
    final deltaLat = (other.latitude - latitude) * math.pi / 180;
    final deltaLon = (other.longitude - longitude) * math.pi / 180;

    final a = math.sin(deltaLat / 2) * math.sin(deltaLat / 2) +
        math.cos(lat1Rad) *
            math.cos(lat2Rad) *
            math.sin(deltaLon / 2) *
            math.sin(deltaLon / 2);
    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));

    return earthRadius * c;
  }

  /// Distance in kilometers
  double distanceToKm(GeoPoint other) => distanceTo(other) / 1000;

  /// Format distance as readable string
  String formatDistanceTo(GeoPoint other) {
    final meters = distanceTo(other);
    if (meters < 1000) {
      return '${meters.round()} м';
    } else {
      return '${(meters / 1000).toStringAsFixed(1)} км';
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GeoPoint &&
          runtimeType == other.runtimeType &&
          latitude == other.latitude &&
          longitude == other.longitude;

  @override
  int get hashCode => latitude.hashCode ^ longitude.hashCode;

  @override
  String toString() => 'GeoPoint(lat: $latitude, lon: $longitude)';
}

/// Represents a bounding box for map regions
class MapBounds {
  final GeoPoint northEast;
  final GeoPoint southWest;

  const MapBounds({
    required this.northEast,
    required this.southWest,
  });

  /// Get the center point of the bounds
  GeoPoint get center => GeoPoint(
        latitude: (northEast.latitude + southWest.latitude) / 2,
        longitude: (northEast.longitude + southWest.longitude) / 2,
      );

  /// Get the north (top) latitude
  double get north => northEast.latitude;

  /// Get the south (bottom) latitude
  double get south => southWest.latitude;

  /// Get the east (right) longitude
  double get east => northEast.longitude;

  /// Get the west (left) longitude
  double get west => southWest.longitude;

  /// Check if a point is within these bounds
  bool contains(GeoPoint point) {
    return point.latitude >= south &&
        point.latitude <= north &&
        point.longitude >= west &&
        point.longitude <= east;
  }

  /// Create a key for caching based on bounds (rounded)
  String get cacheKey =>
      '${south.toStringAsFixed(3)}_${west.toStringAsFixed(3)}_'
      '${north.toStringAsFixed(3)}_${east.toStringAsFixed(3)}';

  @override
  String toString() => 'MapBounds(sw: $southWest, ne: $northEast)';
}
