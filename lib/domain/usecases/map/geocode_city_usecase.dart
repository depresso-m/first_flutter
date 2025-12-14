import '../../../core/models/geo_point.dart';
import '../../interfaces/repositories/map_repository.dart';

/// Use case for geocoding a city name to coordinates
class GeocodeCityUseCase {
  final MapRepository _repository;

  GeocodeCityUseCase(this._repository);

  /// Execute the use case
  /// [cityName] - Name of the city to geocode
  Future<GeoPoint?> execute(String cityName) async {
    if (cityName.trim().isEmpty) return null;
    return await _repository.geocodeCity(cityName);
  }
}
