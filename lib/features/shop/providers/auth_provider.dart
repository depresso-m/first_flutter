import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/auth_account.dart';

part 'auth_provider.g.dart';

@Riverpod(keepAlive: true)
class AuthController extends _$AuthController {
  @override
  AuthAccount? build() => null;

  void login({required String email, required String password}) {
    final trimmedEmail = email.trim();
    final trimmedPassword = password.trim();

    if (trimmedEmail.isEmpty || trimmedPassword.isEmpty) {
      throw const AuthException('Введите email и пароль');
    }

    state = AuthAccount(email: trimmedEmail);
  }

  void register({
    required String email,
    required String password,
    String? displayName,
  }) {
    final trimmedEmail = email.trim();
    final trimmedPassword = password.trim();
    final trimmedName = displayName?.trim() ?? '';

    if (trimmedEmail.isEmpty ||
        trimmedPassword.isEmpty ||
        trimmedName.isEmpty) {
      throw const AuthException('Все поля должны быть заполнены');
    }

    state = AuthAccount(email: trimmedEmail, firstName: trimmedName);
  }

  void logout() {
    state = null;
  }

  void updateProfile({
    String? firstName,
    String? lastName,
    String? phone,
    String? city,
  }) {
    final current = state;
    if (current == null) return;

    state = current.copyWith(
      firstName: firstName ?? current.firstName,
      lastName: lastName ?? current.lastName,
      phone: phone ?? current.phone,
      city: city ?? current.city,
    );
  }
}

class AuthException implements Exception {
  const AuthException(this.message);

  final String message;

  @override
  String toString() => message;
}
