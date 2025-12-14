import '../../../core/models/geo_point.dart';
import '../../../core/models/pharmacy.dart';
import '../../interfaces/repositories/map_repository.dart';

/// Use case for updating pharmacies when map region changes
class UpdatePharmaciesRegionUseCase {
  final MapRepository _repository;

  UpdatePharmaciesRegionUseCase(this._repository);

  /// Execute the use case
  /// [bounds] - Map bounds to fetch pharmacies for
  Future<List<Pharmacy>> execute(MapBounds bounds) async {
    return await _repository.getPharmaciesInBounds(bounds);
  }
}
