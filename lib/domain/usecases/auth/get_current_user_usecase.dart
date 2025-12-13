import '../../../core/models/auth_account.dart';
import '../../interfaces/repositories/auth_repository.dart';

class GetCurrentUserUseCase {
  final AuthRepository _repository;

  GetCurrentUserUseCase(this._repository);

  Future<AuthAccount?> execute() async {
    return await _repository.getCurrentUser();
  }
}
