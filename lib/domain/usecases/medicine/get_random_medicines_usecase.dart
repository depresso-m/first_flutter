import '../../../core/models/medicine.dart';
import '../../interfaces/repositories/medicine_repository.dart';

/// Use case for fetching random medicines from OpenFDA API
class GetRandomMedicinesUseCase {
  final MedicineRepository _repository;

  GetRandomMedicinesUseCase(this._repository);

  /// Execute the use case
  /// [skip] - Number of results to skip (for pagination)
  /// [limit] - Maximum number of results to return
  Future<List<Medicine>> execute({int skip = 0, int limit = 10}) async {
    return await _repository.getRandomMedicinesFromApi(skip: skip, limit: limit);
  }
}
