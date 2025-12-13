import '../../../core/exceptions/app_exception.dart';
import '../../../core/models/auth_account.dart';
import '../../interfaces/repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository _repository;

  LoginUseCase(this._repository);

  Future<AuthAccount> execute({
    required String email,
    required String password,
  }) async {
    final trimmedEmail = email.trim();
    final trimmedPassword = password.trim();

    if (trimmedEmail.isEmpty || trimmedPassword.isEmpty) {
      throw AuthException.emptyFields();
    }

    if (!_isValidEmail(trimmedEmail)) {
      throw AuthException.invalidEmail();
    }

    return await _repository.login(
      email: trimmedEmail,
      password: trimmedPassword,
    );
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}
