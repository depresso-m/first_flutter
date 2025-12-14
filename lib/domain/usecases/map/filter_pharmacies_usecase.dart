import '../../../core/models/geo_point.dart';
import '../../../core/models/pharmacy.dart';
import '../../interfaces/repositories/map_repository.dart';

/// Use case for filtering pharmacies by name
class FilterPharmaciesUseCase {
  final MapRepository _repository;

  FilterPharmaciesUseCase(this._repository);

  /// Execute the use case
  /// [bounds] - Map bounds
  /// [nameFilter] - Name filter (optional)
  Future<List<Pharmacy>> execute(MapBounds bounds, String? nameFilter) async {
    return await _repository.filterPharmacies(bounds, nameFilter);
  }
}
