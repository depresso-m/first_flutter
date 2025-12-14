import '../../../core/models/medicine.dart';
import '../../interfaces/repositories/medicine_repository.dart';

/// Use case for fetching drugs from a specific manufacturer
class GetManufacturerDrugsUseCase {
  final MedicineRepository _repository;

  GetManufacturerDrugsUseCase(this._repository);

  /// Execute the use case
  /// [manufacturerName] - Name of the manufacturer
  Future<List<Medicine>> execute(String manufacturerName) async {
    if (manufacturerName.trim().isEmpty) return [];
    return await _repository.getDrugsByManufacturer(manufacturerName);
  }
}
