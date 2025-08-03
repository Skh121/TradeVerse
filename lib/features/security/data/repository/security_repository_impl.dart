// lib/features/security/data/repositories/security_repository_impl.dart

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:tradeverse/core/error/failure.dart';
import 'package:tradeverse/features/security/data/data_source/security_data_source.dart';
import 'package:tradeverse/features/security/domain/entity/security_entity.dart';
import 'package:tradeverse/features/security/domain/repository/security_repository.dart';


class SecurityRepositoryImpl implements ISecurityRepository {
  final ISecurityDataSource remoteDataSource;

  SecurityRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, SuccessMessageEntity>> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      final resultModel = await remoteDataSource.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      );
      return Right(
        resultModel,
      ); // SuccessMessageModel extends SuccessMessageEntity
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError) {
        return const Left(NetworkFailure(message: 'No internet connection.'));
      } else if (e.response?.statusCode == 401) {
        return Left(
          UnauthorizedFailure(message: 
            e.response?.data['message'] ?? 'Authentication failed.',
          ),
        );
      } else if (e.response?.data != null && e.response?.data is Map) {
        return Left(
          ServerFailure(message:e.response?.data['message'] ?? 'Server error.'),
        );
      } else {
        return Left(ServerFailure(message:e.message ?? 'Unknown server error.'));
      }
    } on FormatException {
      return const Left(
        DataParsingFailure(message: 'Failed to parse password change response.'),
      );
    } catch (e) {
      return Left(UnknownFailure(message:e.toString()));
    }
  }

  @override
  Future<Either<Failure, SuccessMessageEntity>> deleteMyAccount() async {
    try {
      final resultModel = await remoteDataSource.deleteMyAccount();
      return Right(
        resultModel,
      ); // SuccessMessageModel extends SuccessMessageEntity
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError) {
        return const Left(NetworkFailure(message: 'No internet connection.'));
      } else if (e.response?.statusCode == 401) {
        return Left(
          UnauthorizedFailure(message: 
            e.response?.data['message'] ?? 'Authentication failed.',
          ),
        );
      } else if (e.response?.data != null && e.response?.data is Map) {
        return Left(
          ServerFailure(message:e.response?.data['message'] ?? 'Server error.'),
        );
      } else {
        return Left(ServerFailure(message:e.message ?? 'Unknown server error.'));
      }
    } on FormatException {
      return const Left(
        DataParsingFailure(message: 'Failed to parse account deletion response.'),
      );
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserDataExportEntity>> exportMyData() async {
    try {
      final resultModel = await remoteDataSource.exportMyData();
      return Right(
        resultModel,
      ); // UserDataExportModel extends UserDataExportEntity
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError) {
        return const Left(NetworkFailure(message: 'No internet connection.'));
      } else if (e.response?.statusCode == 401) {
        return Left(
          UnauthorizedFailure(message: 
            e.response?.data['message'] ?? 'Authentication failed.',
          ),
        );
      } else if (e.response?.data != null && e.response?.data is Map) {
        return Left(
          ServerFailure(message:e.response?.data['message'] ?? 'Server error.'),
        );
      } else {
        return Left(ServerFailure(message:e.message ?? 'Unknown server error.'));
      }
    } on FormatException {
      return const Left(DataParsingFailure(message:'Failed to parse exported data.'));
    } catch (e) {
      return Left(UnknownFailure(message:e.toString()));
    }
  }
}
