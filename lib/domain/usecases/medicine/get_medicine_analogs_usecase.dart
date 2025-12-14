import '../../../core/models/medicine.dart';
import '../../interfaces/repositories/medicine_repository.dart';

/// Use case for fetching medicine analogs by active ingredient
class GetMedicineAnalogsUseCase {
  final MedicineRepository _repository;

  GetMedicineAnalogsUseCase(this._repository);

  /// Execute the use case
  /// [activeIngredient] - Active ingredient to search for
  Future<List<Medicine>> execute(String activeIngredient) async {
    if (activeIngredient.trim().isEmpty) return [];
    return await _repository.getAnalogs(activeIngredient);
  }
}
