import '../../../core/models/auth_account.dart';

abstract class AuthLocalDataSource {
  Future<AuthAccount?> getCurrentUser();
  Future<AuthAccount> saveUser(AuthAccount account);
  Future<void> clearUser();
  Future<AuthAccount> updateUser(AuthAccount account);
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  AuthAccount? _currentUser;

  @override
  Future<AuthAccount?> getCurrentUser() async {
    return _currentUser;
  }

  @override
  Future<AuthAccount> saveUser(AuthAccount account) async {
    _currentUser = account;
    return account;
  }

  @override
  Future<void> clearUser() async {
    _currentUser = null;
  }

  @override
  Future<AuthAccount> updateUser(AuthAccount account) async {
    _currentUser = account;
    return account;
  }
}
