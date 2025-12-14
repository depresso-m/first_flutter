import '../../../core/models/geo_point.dart';
import '../../../core/models/pharmacy.dart';
import '../../interfaces/repositories/map_repository.dart';

/// Use case for getting pharmacies within a radius
class GetPharmaciesByRadiusUseCase {
  final MapRepository _repository;

  GetPharmaciesByRadiusUseCase(this._repository);

  /// Execute the use case
  /// [center] - Center point
  /// [radiusMeters] - Radius in meters
  Future<List<Pharmacy>> execute(GeoPoint center, int radiusMeters) async {
    return await _repository.getPharmaciesInRadius(center, radiusMeters);
  }
}
