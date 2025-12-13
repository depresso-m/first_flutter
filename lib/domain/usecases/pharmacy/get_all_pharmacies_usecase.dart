import '../../../core/models/pharmacy.dart';
import '../../interfaces/repositories/pharmacy_repository.dart';

class GetAllPharmaciesUseCase {
  final PharmacyRepository _repository;

  GetAllPharmaciesUseCase(this._repository);

  Future<List<Pharmacy>> execute() async {
    return await _repository.getAllPharmacies();
  }
}
