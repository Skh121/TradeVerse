import 'dart:io';
import 'package:tradeverse/features/profile/domain/entity/profile_entity.dart';

abstract class IProfileDataSource {
  Future<ProfileEntity> getMyProfile();
  Future<ProfileEntity> updateMyProfile({
    required String firstName,
    required String lastName,
    required String bio,
    File? avatarFile,
  });
  Future<void> cacheMyProfile(ProfileEntity profile);
}
