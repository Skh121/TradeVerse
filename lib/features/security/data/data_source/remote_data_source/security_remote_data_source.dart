// lib/features/security/data/datasources/security_remote_data_source_impl.dart

import 'package:dio/dio.dart';
import 'package:tradeverse/app/constant/api/api_endpoint.dart';
import 'package:tradeverse/core/network/api_service.dart';
import 'package:tradeverse/features/security/data/data_source/security_data_source.dart';
import 'package:tradeverse/features/security/data/model/security_api_model.dart';

class SecurityRemoteDataSource implements ISecurityDataSource {
  final ApiService _apiService;

  SecurityRemoteDataSource({required ApiService apiService})
    : _apiService = apiService;

  @override
  Future<SuccessMessageModel> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      final response = await _apiService.patch(
        ApiEndpoints.changePassword,
        data: {
          'currentPassword': currentPassword,
          'newPassword': newPassword,
          'confirmPassword': confirmPassword,
        },
      );
      if (response.statusCode == 200) {
        return SuccessMessageModel.fromJson(
          response.data as Map<String, dynamic>,
        );
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to change password: ${response.statusMessage}',
        );
      }
    } on DioException {
      rethrow;
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  @override
  Future<SuccessMessageModel> deleteMyAccount() async {
    try {
      final response = await _apiService.delete(ApiEndpoints.deleteMyAccount);
      if (response.statusCode == 200) {
        return SuccessMessageModel.fromJson(
          response.data as Map<String, dynamic>,
        );
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to delete account: ${response.statusMessage}',
        );
      }
    } on DioException {
      rethrow;
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  @override
  Future<UserDataExportModel> exportMyData() async {
    try {
      final response = await _apiService.get(ApiEndpoints.exportMyData);
      if (response.statusCode == 200) {
        return UserDataExportModel.fromJson(
          response.data as Map<String, dynamic>,
        );
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to export data: ${response.statusMessage}',
        );
      }
    } on DioException {
      rethrow;
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }
}
