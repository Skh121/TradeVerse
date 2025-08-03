
import 'package:dartz/dartz.dart';
import 'package:tradeverse/core/error/failure.dart';
import 'package:tradeverse/features/security/domain/entity/security_entity.dart';

abstract class ISecurityRepository {
  /// Changes the user's password.
  Future<Either<Failure, SuccessMessageEntity>> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  });

  /// Deletes the user's account.
  Future<Either<Failure, SuccessMessageEntity>> deleteMyAccount();

  /// Exports all user data.
  Future<Either<Failure, UserDataExportEntity>> exportMyData();
}
