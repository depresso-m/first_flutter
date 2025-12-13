import '../../../core/models/pharmacy.dart';
import '../../interfaces/repositories/pharmacy_repository.dart';

class GetPharmacyByIdUseCase {
  final PharmacyRepository _repository;

  GetPharmacyByIdUseCase(this._repository);

  Future<Pharmacy?> execute(String id) async {
    return await _repository.getPharmacyById(id);
  }
}
