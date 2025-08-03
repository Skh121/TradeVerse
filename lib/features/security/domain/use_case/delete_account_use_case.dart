import 'package:dartz/dartz.dart';
import 'package:tradeverse/core/error/failure.dart';
import 'package:tradeverse/features/security/domain/entity/security_entity.dart';
import 'package:tradeverse/features/security/domain/repository/security_repository.dart';

/// Use case for deleting the user's account.
class DeleteAccount {
  final ISecurityRepository repository;

  DeleteAccount(this.repository);

  Future<Either<Failure, SuccessMessageEntity>> call() async {
    return await repository.deleteMyAccount();
  }
}
