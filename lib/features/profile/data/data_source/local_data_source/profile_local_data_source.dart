import 'dart:io';
import 'package:tradeverse/core/network/hive_service.dart';
import 'package:tradeverse/features/profile/data/data_source/profile_data_source.dart';
import 'package:tradeverse/features/profile/data/model/profile_hive_model.dart';
import 'package:tradeverse/features/profile/domain/entity/profile_entity.dart';

class ProfileLocalDataSource implements IProfileDataSource {
  final HiveService _hiveService;
  static const String _profileCacheKey = 'PROFILE_CACHE';

  ProfileLocalDataSource(this._hiveService);

  @override
  Future<ProfileEntity> getMyProfile() async {
    final hiveModel = _hiveService.profileBox.get(_profileCacheKey);
    if (hiveModel != null) {
      return hiveModel.toEntity();
    } else {
      throw Exception("No profile data found in local cache.");
    }
  }

  @override
  Future<void> cacheMyProfile(ProfileEntity profile) async {
    final hiveModel = ProfileHiveModel.fromEntity(profile);
    await _hiveService.profileBox.put(_profileCacheKey, hiveModel);
  }

  @override
  Future<ProfileEntity> updateMyProfile({
    required String firstName,
    required String lastName,
    required String bio,
    File? avatarFile,
  }) async {
    // This operation is online-only.
    throw UnimplementedError(
        'Update profile is not supported in local data source.');
  }
}
