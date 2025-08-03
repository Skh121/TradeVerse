import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:tradeverse/core/error/failure.dart';
import 'package:tradeverse/features/profile/domain/entity/profile_entity.dart';
import 'package:tradeverse/features/profile/domain/repository/profile_repository.dart';

class UpdateProfileParams extends Equatable {
  final String firstName;
  final String lastName;
  final String bio;
  final File? avatarFile;

  const UpdateProfileParams({
    required this.firstName,
    required this.lastName,
    required this.bio,
    this.avatarFile,
  });

  @override
  List<Object?> get props => [firstName, lastName, bio, avatarFile];
}

class UpdateProfileUseCase {
  final IProfileRepository _repository;

  UpdateProfileUseCase(this._repository);

  Future<Either<Failure, ProfileEntity>> call(
    UpdateProfileParams params,
  ) async {
    return await _repository.updateMyProfile(
      firstName: params.firstName,
      lastName: params.lastName,
      bio: params.bio,
      avatarFile: params.avatarFile,
    );
  }
}
