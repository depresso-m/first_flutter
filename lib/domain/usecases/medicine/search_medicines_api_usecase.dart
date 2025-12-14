import '../../../core/models/medicine.dart';
import '../../interfaces/repositories/medicine_repository.dart';

/// Use case for searching medicines via OpenFDA API
class SearchMedicinesApiUseCase {
  final MedicineRepository _repository;

  SearchMedicinesApiUseCase(this._repository);

  /// Execute the use case
  /// [query] - Search query (brand name)
  Future<List<Medicine>> execute(String query) async {
    if (query.trim().length < 2) return [];
    return await _repository.searchMedicinesFromApi(query);
  }
}
