import '../../../core/models/auth_account.dart';

abstract class AuthRepository {
  Future<AuthAccount?> getCurrentUser();

  Future<AuthAccount> login({
    required String email,
    required String password,
  });

  Future<AuthAccount> register({
    required String email,
    required String password,
    String? firstName,
  });

  Future<void> logout();

  Future<AuthAccount> updateProfile({
    String? firstName,
    String? lastName,
    String? phone,
    String? city,
  });

  Future<bool> isAuthenticated();
}
