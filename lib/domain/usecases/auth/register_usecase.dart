import '../../../core/exceptions/app_exception.dart';
import '../../../core/models/auth_account.dart';
import '../../interfaces/repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository _repository;

  RegisterUseCase(this._repository);

  Future<AuthAccount> execute({
    required String email,
    required String password,
    String? firstName,
  }) async {
    final trimmedEmail = email.trim();
    final trimmedPassword = password.trim();
    final trimmedName = firstName?.trim();

    if (trimmedEmail.isEmpty || trimmedPassword.isEmpty) {
      throw AuthException.emptyFields();
    }

    if (!_isValidEmail(trimmedEmail)) {
      throw AuthException.invalidEmail();
    }

    if (trimmedPassword.length < 6) {
      throw AuthException.weakPassword();
    }

    return await _repository.register(
      email: trimmedEmail,
      password: trimmedPassword,
      firstName: trimmedName,
    );
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}
