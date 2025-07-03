import 'package:dartz/dartz.dart';
import 'package:tradeverse/core/error/failure.dart';
import 'package:tradeverse/features/auth/data/data_source/remote_data_source/user_remote_data_source.dart';
import 'package:tradeverse/features/auth/domain/entity/user_entity.dart';
import 'package:tradeverse/features/auth/domain/repository/auth_repository.dart';

class UserRemoteRepository implements IAuthRepository {
  final UserRemoteDataSource _userRemoteDataSource;

  UserRemoteRepository({required UserRemoteDataSource userRemoteDataSource})
    : _userRemoteDataSource = userRemoteDataSource;
  @override
  Future<Either<Failure, String>> loginToAccount(
    String email,
    String password,
  ) async {
    try {
      final token = await _userRemoteDataSource.loginToAccount(email, password);
      return Right(token);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> createAccount(UserEntity user) async {
    try {
      await _userRemoteDataSource.createAccount(user);
      return const Right(null);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}
