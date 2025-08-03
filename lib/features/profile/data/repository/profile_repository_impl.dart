import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart'; // For downloading the image
import 'package:path_provider/path_provider.dart'; // To find the local storage path
import 'package:tradeverse/core/error/failure.dart';
import 'package:tradeverse/core/network/network_info.dart';
import 'package:tradeverse/features/profile/data/data_source/profile_data_source.dart';
import 'package:tradeverse/features/profile/domain/entity/profile_entity.dart';
import 'package:tradeverse/features/profile/domain/repository/profile_repository.dart';

class ProfileRepositoryImpl implements IProfileRepository {
  final IProfileDataSource remoteDataSource;
  final IProfileDataSource localDataSource;
  final INetworkInfo networkInfo;
  final Dio _dio = Dio();

  ProfileRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  /// Downloads an image from a URL and saves it locally.
  /// Returns the local file path.
  Future<String?> _cacheImage(String? imageUrl) async {
    if (imageUrl == null || !imageUrl.startsWith('http')) {
      return null;
    }
    try {
      final directory = await getApplicationDocumentsDirectory();
      final fileName = imageUrl.split('/').last;
      final localPath = '${directory.path}/$fileName';

      await _dio.download(imageUrl, localPath);

      return localPath;
    } catch (e) {
      // If download fails, return null. The app can try again later.
      print('Image download failed: $e');
      return null;
    }
  }

  @override
  Future<Either<Failure, ProfileEntity>> getMyProfile() async {
    if (await networkInfo.isConnected) {
      try {
        // 1. Fetch fresh profile data from the API
        final remoteProfile = await remoteDataSource.getMyProfile();

        // 2. Download the avatar image and get its local path
        final localAvatarPath = await _cacheImage(remoteProfile.avatar);

        // 3. Create a new entity for caching that uses the local path
        final profileToCache = remoteProfile.copyWith(
          avatar: localAvatarPath, // Use local path for the cache
        );

        // 4. Save the profile with the local image path to Hive
        await localDataSource.cacheMyProfile(profileToCache);

        // 5. Return the original profile with the network URL for immediate display
        return Right(remoteProfile);
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      // --- OFFLINE ---
      try {
        // Fetch the profile from Hive, which now contains the local image path
        final localProfile = await localDataSource.getMyProfile();
        return Right(localProfile);
      } catch (e) {
        return Left(
          CacheFailure(message: "No offline profile data available."),
        );
      }
    }
  }

  @override
  Future<Either<Failure, ProfileEntity>> updateMyProfile({
    required String firstName,
    required String lastName,
    required String bio,
    File? avatarFile,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final updatedProfile = await remoteDataSource.updateMyProfile(
          firstName: firstName,
          lastName: lastName,
          bio: bio,
          avatarFile: avatarFile,
        );

        // After updating, download and cache the new avatar image
        final localAvatarPath = await _cacheImage(updatedProfile.avatar);
        final profileToCache = updatedProfile.copyWith(avatar: localAvatarPath);
        await localDataSource.cacheMyProfile(profileToCache);

        return Right(updatedProfile);
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return Left(
        NetworkFailure(message: "Cannot update profile while offline."),
      );
    }
  }
}
