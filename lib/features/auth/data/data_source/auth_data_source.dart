import 'package:tradeverse/features/auth/domain/entity/user_entity.dart';

abstract interface class IAuthDataSource {
  Future<void> createAccount(UserEntity user);
  Future<UserEntity> loginToAccount(String email, String password);

  Future<void> requestOtp(String email);
  Future<String> verifyOtp(String email, String otp);
  Future<void> resetPasswordWithOtp(String resetToken, String newPassword);
}
