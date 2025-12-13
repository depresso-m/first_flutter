import '../../../core/models/medicine.dart';
import '../../interfaces/repositories/medicine_repository.dart';

class SearchMedicinesUseCase {
  final MedicineRepository _repository;

  SearchMedicinesUseCase(this._repository);

  Future<List<Medicine>> execute(String query) async {
    if (query.trim().isEmpty) {
      return await _repository.getAllMedicines();
    }
    return await _repository.searchMedicines(query);
  }
}
