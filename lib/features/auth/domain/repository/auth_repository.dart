import 'package:dartz/dartz.dart';
import 'package:tradeverse/core/error/failure.dart';
import 'package:tradeverse/features/auth/domain/entity/user_entity.dart';
 
abstract interface class IAuthRepository {
  Future<Either<Failure, void>> createAccount(UserEntity user);
  Future<Either<Failure, String>> loginToAccount(String email,String password);
}