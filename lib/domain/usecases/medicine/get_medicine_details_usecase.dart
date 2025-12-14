import '../../../data/mappers/medicine_mapper.dart';
import '../../interfaces/repositories/medicine_repository.dart';

/// Use case for fetching detailed medicine information (label)
class GetMedicineDetailsUseCase {
  final MedicineRepository _repository;

  GetMedicineDetailsUseCase(this._repository);

  /// Execute the use case
  /// [ndc] - National Drug Code
  Future<MedicineDetails?> execute(String ndc) async {
    if (ndc.trim().isEmpty) return null;
    return await _repository.getMedicineDetails(ndc);
  }
}
