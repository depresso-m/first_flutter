import '../../../core/models/medicine.dart';
import '../../interfaces/repositories/medicine_repository.dart';

class GetAllMedicinesUseCase {
  final MedicineRepository _repository;

  GetAllMedicinesUseCase(this._repository);

  Future<List<Medicine>> execute() async {
    return await _repository.getAllMedicines();
  }
}
