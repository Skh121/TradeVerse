import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tradeverse/app/constant/hive/secure_storage_keys.dart';

class SecureStorageService {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  // Save values
  Future<void> saveUserData({
    required String token,
    required String role,
    required String id,
    required String fullName,
    required String email,
  }) async {
    await _secureStorage.write(key: SecureStorageKeys.token, value: token);
    await _secureStorage.write(key: SecureStorageKeys.role, value: role);
    await _secureStorage.write(key: SecureStorageKeys.id, value: id);
    await _secureStorage.write(
      key: SecureStorageKeys.fullName,
      value: fullName,
    );
    await _secureStorage.write(key: SecureStorageKeys.email, value: email);
  }

  // Read individual values
  Future<String?> getToken() =>
      _secureStorage.read(key: SecureStorageKeys.token);
  Future<String?> getRole() => _secureStorage.read(key: SecureStorageKeys.role);
  Future<String?> getId() => _secureStorage.read(key: SecureStorageKeys.id);
  Future<String?> getEmail() =>
      _secureStorage.read(key: SecureStorageKeys.email);
  Future<String?> getFullName() =>
      _secureStorage.read(key: SecureStorageKeys.fullName);

  // Delete all
  Future<void> clearUserData() async {
    await _secureStorage.deleteAll();
  }
}
