import 'package:dartz/dartz.dart';
import 'package:tradeverse/core/error/failure.dart';
import 'package:tradeverse/features/auth/domain/entity/user_entity.dart';

abstract interface class IAuthRepository {
  Future<Either<Failure, void>> createAccount(UserEntity user);
  Future<Either<Failure, UserEntity>> loginToAccount(
    String email,
    String password,
  );

  Future<Either<Failure, void>> requestOtp(String email);
  Future<Either<Failure, String>> verifyOtp(
    String email,
    String otp,
  ); // Returns resetToken
  Future<Either<Failure, void>> resetPasswordWithOtp(
    String resetToken,
    String newPassword,
  );
  Future<void> logout();
}
