import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class SecureStorageDataSource {
  Future<Map<String, dynamic>?> getUserData();

  Future<void> saveUserData(Map<String, dynamic> userData);

  Future<void> clearAll();
}

class SecureStorageDataSourceImpl implements SecureStorageDataSource {
  final FlutterSecureStorage _storage;

  static const String _userDataKey = 'user_data';

  SecureStorageDataSourceImpl({FlutterSecureStorage? storage})
    : _storage =
          storage ??
          const FlutterSecureStorage(
            aOptions: AndroidOptions(encryptedSharedPreferences: true),
            iOptions: IOSOptions(
              accessibility: KeychainAccessibility.first_unlock_this_device,
            ),
          );

  @override
  Future<Map<String, dynamic>?> getUserData() async {
    final jsonString = await _storage.read(key: _userDataKey);
    if (jsonString == null) return null;
    return jsonDecode(jsonString) as Map<String, dynamic>;
  }

  @override
  Future<void> saveUserData(Map<String, dynamic> userData) async {
    await _storage.write(key: _userDataKey, value: jsonEncode(userData));
  }

  @override
  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
