import '../../../core/models/auth_account.dart';
import 'secure_storage/secure_storage_datasource.dart';

abstract class AuthLocalDataSource {
  Future<AuthAccount?> getCurrentUser();
  Future<AuthAccount> saveUser(AuthAccount account);
  Future<void> clearUser();
  Future<AuthAccount> updateUser(AuthAccount account);
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SecureStorageDataSource _secureStorage;
  AuthAccount? _currentUser;

  AuthLocalDataSourceImpl({
    required SecureStorageDataSource secureStorage,
  }) : _secureStorage = secureStorage;

  @override
  Future<AuthAccount?> getCurrentUser() async {
    if (_currentUser != null) return _currentUser;
    
    final userData = await _secureStorage.getUserData();
    if (userData != null) {
      _currentUser = AuthAccount(
        id: userData['id'] as String,
        email: userData['email'] as String,
        firstName: userData['firstName'] as String?,
        lastName: userData['lastName'] as String?,
        phone: userData['phone'] as String?,
        city: userData['city'] as String?,
      );
    }
    return _currentUser;
  }

  @override
  Future<AuthAccount> saveUser(AuthAccount account) async {
    _currentUser = account;
    await _secureStorage.saveUserData(_accountToMap(account));
    return account;
  }

  @override
  Future<void> clearUser() async {
    _currentUser = null;
    await _secureStorage.clearAll();
  }

  @override
  Future<AuthAccount> updateUser(AuthAccount account) async {
    _currentUser = account;
    await _secureStorage.saveUserData(_accountToMap(account));
    return account;
  }

  Map<String, dynamic> _accountToMap(AuthAccount account) {
    return {
      'id': account.id,
      'email': account.email,
      'firstName': account.firstName,
      'lastName': account.lastName,
      'phone': account.phone,
      'city': account.city,
    };
  }
}
