import '../../../core/models/auth_account.dart';
import '../../interfaces/repositories/auth_repository.dart';

class UpdateProfileUseCase {
  final AuthRepository _repository;

  UpdateProfileUseCase(this._repository);

  Future<AuthAccount> execute({
    String? firstName,
    String? lastName,
    String? phone,
    String? city,
  }) async {
    return await _repository.updateProfile(
      firstName: firstName,
      lastName: lastName,
      phone: phone,
      city: city,
    );
  }
}
