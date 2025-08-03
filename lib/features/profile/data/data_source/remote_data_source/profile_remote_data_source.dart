import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart'; // For MediaType
import 'package:tradeverse/app/constant/api/api_endpoint.dart';
import 'package:tradeverse/core/network/api_service.dart';
import 'package:tradeverse/features/profile/data/data_source/profile_data_source.dart';
import 'package:tradeverse/features/profile/data/model/profile_api_model.dart';
import 'package:tradeverse/features/profile/domain/entity/profile_entity.dart';

class ProfileRemoteDataSource implements IProfileDataSource {
  final ApiService _apiService;

  ProfileRemoteDataSource({required ApiService apiService})
    : _apiService = apiService;

  @override
  Future<ProfileEntity> getMyProfile() async {
    try {
      final response = await _apiService.get(ApiEndpoints.getProfile);
      if (response.statusCode == 200) {
        // Use ProfileModel.fromJson and then convert to ProfileEntity
        return ProfileModel.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to load profile: ${response.statusMessage}',
        );
      }
    } on DioException {
      rethrow;
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  @override
  Future<ProfileEntity> updateMyProfile({
    required String firstName,
    required String lastName,
    required String bio,
    File? avatarFile,
  }) async {
    try {
      FormData formData = FormData.fromMap({
        'firstName': firstName,
        'lastName': lastName,
        'bio': bio,
      });

      if (avatarFile != null) {
        String? mimeType;
        if (avatarFile.path.endsWith('.png')) {
          mimeType = 'image/png';
        } else if (avatarFile.path.endsWith('.jpg') ||
            avatarFile.path.endsWith('.jpeg')) {
          mimeType = 'image/jpeg';
        }

        formData.files.add(
          MapEntry(
            "avatar",
            await MultipartFile.fromFile(
              avatarFile.path,
              filename: avatarFile.path.split('/').last,
              contentType: mimeType != null ? MediaType.parse(mimeType) : null,
            ),
          ),
        );
      }

      final response = await _apiService.patch(
        ApiEndpoints.getProfile, // The backend uses /me for patch as well
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data', // Important for file uploads
          },
        ),
      );

      if (response.statusCode == 200) {
        // Backend returns { message: "Profile updated successfully", profile: { ... } }
        // Use ProfileModel.fromJson and then convert to ProfileEntity
        return ProfileModel.fromJson(
          response.data['profile'] as Map<String, dynamic>,
        );
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to update profile: ${response.statusMessage}',
        );
      }
    } on DioException {
      rethrow; // Rethrow DioException to be caught by the repository
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  // This method is required to conform to the IProfileDataSource interface.
  // Since this is the remote source, it has an empty implementation.
  @override
  Future<void> cacheMyProfile(ProfileEntity profile) async {
    // Remote data source does not cache data.
    return;
  }
}
