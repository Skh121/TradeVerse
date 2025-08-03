import 'package:tradeverse/core/network/hive_service.dart';
import 'package:tradeverse/features/auth/data/data_source/auth_data_source.dart';
import 'package:tradeverse/features/auth/data/model/auth_hive_model.dart';
import 'package:tradeverse/features/auth/domain/entity/user_entity.dart';

class AuthLocalDataSource implements IAuthDataSource {
  final HiveService _hiveService;

  AuthLocalDataSource({required HiveService hiveService})
    : _hiveService = hiveService;

  @override
  Future<void> createAccount(UserEntity user) async {
    try {
      final authHiveModel = AuthHiveModel.fromEntity(user);
      // This method now correctly saves the user with their email as the key.
      await _hiveService.createAccount(authHiveModel);
    } catch (error) {
      throw Exception('Failed to save user to local database: $error');
    }
  }

  @override
  Future<UserEntity> loginToAccount(String email, String password) async {
    try {
      // 1. Find the user by email first.
      final userData = await _hiveService.login(email);

      // 2. Check if the user exists and if the password matches.
      if (userData != null && userData.password == password) {
        // The user is valid, return their entity.
        return userData.toEntity();
      } else if (userData != null && userData.password != password) {
        // User was found, but the password was incorrect.
        throw Exception("Incorrect password.");
      } else {
        // No user was found with that email.
        throw Exception("User not found in local database.");
      }
    } catch (e) {
      // Re-throw the specific exception from the try block.
      throw Exception("Offline login failed: $e");
    }
  }

  @override
  Future<void> requestOtp(String email) async {
    throw UnimplementedError('Request Otp is not supported locally.');
  }

  @override
  Future<String> verifyOtp(String email, String otp) async {
    throw UnimplementedError('Verify Otp is not supported locally.');
  }

  @override
  Future<void> resetPasswordWithOtp(
    String resetToken,
    String newPassword,
  ) async {
    throw UnimplementedError(
      'resetPassword With Otp is not supported locally.',
    );
  }
}
