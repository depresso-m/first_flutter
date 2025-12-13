import '../../core/exceptions/app_exception.dart';
import '../../core/models/auth_account.dart';
import '../../domain/interfaces/repositories/auth_repository.dart';
import '../datasources/local/auth_local_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDataSource _localDataSource;

  AuthRepositoryImpl({required AuthLocalDataSource localDataSource})
      : _localDataSource = localDataSource;

  @override
  Future<AuthAccount?> getCurrentUser() async {
    return await _localDataSource.getCurrentUser();
  }

  @override
  Future<AuthAccount> login({
    required String email,
    required String password,
  }) async {
    if (email.isEmpty || password.isEmpty) {
      throw AuthException.emptyFields();
    }

    final account = AuthAccount(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      email: email,
      createdAt: DateTime.now(),
    );

    return await _localDataSource.saveUser(account);
  }

  @override
  Future<AuthAccount> register({
    required String email,
    required String password,
    String? firstName,
  }) async {
    if (email.isEmpty || password.isEmpty) {
      throw AuthException.emptyFields();
    }

    final account = AuthAccount(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      email: email,
      firstName: firstName,
      createdAt: DateTime.now(),
    );

    return await _localDataSource.saveUser(account);
  }

  @override
  Future<void> logout() async {
    await _localDataSource.clearUser();
  }

  @override
  Future<AuthAccount> updateProfile({
    String? firstName,
    String? lastName,
    String? phone,
    String? city,
  }) async {
    final currentUser = await _localDataSource.getCurrentUser();
    if (currentUser == null) {
      throw AuthException.notAuthenticated();
    }

    final updatedUser = currentUser.copyWith(
      firstName: firstName ?? currentUser.firstName,
      lastName: lastName ?? currentUser.lastName,
      phone: phone ?? currentUser.phone,
      city: city ?? currentUser.city,
    );

    return await _localDataSource.updateUser(updatedUser);
  }

  @override
  Future<bool> isAuthenticated() async {
    final user = await _localDataSource.getCurrentUser();
    return user != null;
  }
}
