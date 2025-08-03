import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:tradeverse/core/error/failure.dart';
import 'package:tradeverse/features/profile/domain/entity/profile_entity.dart';
abstract class IProfileRepository {
  Future<Either<Failure, ProfileEntity>> getMyProfile();
  Future<Either<Failure, ProfileEntity>> updateMyProfile({
    required String firstName,
    required String lastName,
    required String bio,
    File? avatarFile,
  });
}
