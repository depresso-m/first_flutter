import '../../interfaces/repositories/medicine_repository.dart';

/// Use case for fetching side effects (adverse events) for a medicine
class GetSideEffectsUseCase {
  final MedicineRepository _repository;

  GetSideEffectsUseCase(this._repository);

  /// Execute the use case
  /// [brandName] - Brand name of the medicine
  Future<List<String>> execute(String brandName) async {
    if (brandName.trim().isEmpty) return [];
    return await _repository.getSideEffects(brandName);
  }
}
