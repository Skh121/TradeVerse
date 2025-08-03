import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart'; // Import for debugPrint
import 'package:tradeverse/app/secure_storage/secure_storage_service.dart';
import 'package:tradeverse/core/error/failure.dart';
import 'package:tradeverse/core/network/network_info.dart';
import 'package:tradeverse/core/network/socket_service.dart';
import 'package:tradeverse/features/auth/data/data_source/auth_data_source.dart';
import 'package:tradeverse/features/auth/domain/entity/user_entity.dart';
import 'package:tradeverse/features/auth/domain/repository/auth_repository.dart';

class AuthRepositoryImpl implements IAuthRepository {
  final IAuthDataSource _remoteDataSource;
  final IAuthDataSource _localDataSource;
  final INetworkInfo _networkInfo;
  final SecureStorageService _secureStorage;
  final SocketService _socketService;
  // final HiveService _hiveService;

  AuthRepositoryImpl({
    required IAuthDataSource remoteDataSource,
    required IAuthDataSource localDataSource,
    required INetworkInfo networkInfo,
    required SecureStorageService secureStorage,
    required SocketService socketService,
    // required HiveService hiveService,
  }) : _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource,
       _networkInfo = networkInfo,
       _secureStorage = secureStorage,
       _socketService = socketService;
      //  _hiveService = hiveService;

  @override
  Future<Either<Failure, UserEntity>> loginToAccount(
    String email,
    String password,
  ) async {
    // Check for an internet connection using the service
    if (await _networkInfo.isConnected) {
      debugPrint("--- [AuthRepo] ONLINE Mode Detected ---");
      // --- ONLINE LOGIN ---
      try {
        debugPrint("[AuthRepo] Attempting to log in via API...");
        // 1. Log in via the API
        final userFromApi = await _remoteDataSource.loginToAccount(
          email,
          password,
        );
        debugPrint(
          "[AuthRepo] API login successful for user: ${userFromApi.email}",
        );
        final userToSave = UserEntity(
          id: userFromApi.id,
          fullName: userFromApi.fullName,
          email: userFromApi.email,
          password: password, // Use the provided password
          role: userFromApi.role,
          token: userFromApi.token,
        );
        debugPrint(
          "[AuthRepo] Preparing to save user to Hive with password: ${userToSave.password}",
        );

        // 3. On success, save the complete user data to the local Hive database
        await _localDataSource.createAccount(userToSave);
        debugPrint("[AuthRepo] Successfully saved user to Hive.");

        return Right(userFromApi); // Return the original entity from the API
      } catch (e) {
        debugPrint("[AuthRepo] ERROR during ONLINE login: $e");
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      debugPrint("--- [AuthRepo] OFFLINE Mode Detected ---");
      // --- OFFLINE LOGIN ---
      try {
        debugPrint("[AuthRepo] Attempting to log in from Hive...");
        // Attempt to log in using only the local Hive database
        final userEntity = await _localDataSource.loginToAccount(
          email,
          password,
        );
        debugPrint(
          "[AuthRepo] Hive login successful for user: ${userEntity.email}",
        );
        return Right(userEntity);
      } catch (e) {
        debugPrint("[AuthRepo] ERROR during OFFLINE login: $e");
        return Left(
          CacheFailure(
            message: "Offline: Invalid credentials or no user data found.",
          ),
        );
      }
    }
  }

  @override
  Future<Either<Failure, void>> createAccount(UserEntity user) async {
    if (await _networkInfo.isConnected) {
      // --- ONLINE REGISTRATION ---
      try {
        await _remoteDataSource.createAccount(user);
        await _localDataSource.createAccount(user);
        return const Right(null);
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      // --- OFFLINE REGISTRATION ---
      return Left(
        NetworkFailure(message: "Cannot create an account while offline."),
      );
    }
  }

  // --- Forgot Password methods remain online-only ---

  @override
  Future<Either<Failure, void>> requestOtp(String email) async {
    if (await _networkInfo.isConnected) {
      try {
        await _remoteDataSource.requestOtp(email);
        return const Right(null);
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return Left(
        NetworkFailure(
          message: "You are offline. Please check your internet connection.",
        ),
      );
    }
  }

  @override
  Future<Either<Failure, String>> verifyOtp(String email, String otp) async {
    if (await _networkInfo.isConnected) {
      try {
        final token = await _remoteDataSource.verifyOtp(email, otp);
        return Right(token);
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return Left(
        NetworkFailure(
          message: "You are offline. Please check your internet connection.",
        ),
      );
    }
  }

  @override
  Future<Either<Failure, void>> resetPasswordWithOtp(
    String resetToken,
    String newPassword,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        await _remoteDataSource.resetPasswordWithOtp(resetToken, newPassword);
        return const Right(null);
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return Left(
        NetworkFailure(
          message: "You are offline. Please check your internet connection.",
        ),
      );
    }
  }

  @override
  Future<void> logout() async {
    await _secureStorage.clearUserData();
    // await _hiveService.clearAllUserData();
    _socketService.disconnect();
  }
}
