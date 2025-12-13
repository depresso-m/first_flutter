import '../../../core/models/medicine.dart';
import '../../interfaces/repositories/medicine_repository.dart';

class GetMedicinesSortedUseCase {
  final MedicineRepository _repository;

  GetMedicinesSortedUseCase(this._repository);

  Future<List<Medicine>> execute({bool ascending = true}) async {
    return await _repository.getMedicinesSortedByPrice(ascending: ascending);
  }
}
