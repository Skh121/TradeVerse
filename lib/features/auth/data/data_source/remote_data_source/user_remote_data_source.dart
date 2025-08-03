import 'package:dio/dio.dart';
import 'package:tradeverse/app/constant/api/api_endpoint.dart';
import 'package:tradeverse/core/error/failure.dart';
import 'package:tradeverse/core/network/api_service.dart';
import 'package:tradeverse/features/auth/data/data_source/auth_data_source.dart';
import 'package:tradeverse/features/auth/data/model/user_api_model.dart';
import 'package:tradeverse/features/auth/domain/entity/user_entity.dart';

class UserRemoteDataSource implements IAuthDataSource {
  final ApiService _apiService;

  UserRemoteDataSource({required ApiService apiService})
    : _apiService = apiService;

  @override
  Future<UserEntity> loginToAccount(String email, String password) async {
    try {
      final response = await _apiService.dio.post(
        ApiEndpoints.login,
        data: {'email': email, 'password': password},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> resData = Map<String, dynamic>.from(
          response.data,
        );

        final userMap =
            resData['data'] != null
                ? Map<String, dynamic>.from(resData['data'])
                : <String, dynamic>{};

        // print('Token from response: ${resData['token']}');

        final token = resData['token']?.toString() ?? '';

        final userModel = UserApiModel.fromJson(userMap);

        final userWithToken = UserApiModel(
          id: userModel.id,
          fullName: userModel.fullName,
          email: userModel.email,
          password: '',
          token: token,
          role: userModel.role,
        );

        return userWithToken.toEntity();
      } else {
        throw Exception(response.statusMessage ?? 'Login failed');
      }
    } on DioException catch (e) {
      throw Exception(
        'Failed to login: ${e.response?.data?['message'] ?? e.message}',
      );
    } catch (e) {
      throw Exception('Failed to login: $e');
    }
  }

  @override
  Future<void> createAccount(UserEntity userData) async {
    try {
      final userApiModel = UserApiModel.fromEntity(userData);

      final response = await _apiService.dio.post(
        ApiEndpoints.register,
        data: userApiModel.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return;
      } else {
        throw Exception(
          'Failed to register: ${response.statusMessage ?? 'Unknown error'}',
        );
      }
    } on DioException catch (e) {
      throw Exception(
        'Failed to register: ${e.response?.data?['message'] ?? e.message}',
      );
    } catch (e) {
      throw Exception('Failed to register: $e');
    }
  }

  @override
  Future<void> requestOtp(String email) async {
    try {
      await _apiService.post(
        ApiEndpoints.requestOtp, // NEW endpoint
        data: {'email': email},
      );
      return;
    } on DioException catch (e) {
      throw ServerFailure(
        message: e.response?.data['message'] ?? 'Failed to send OTP',
      );
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }

  @override
  Future<String> verifyOtp(String email, String otp) async {
    // Returns resetToken
    try {
      final response = await _apiService.post(
        ApiEndpoints.verifyOtp, // NEW endpoint
        data: {'email': email, 'otp': otp},
      );
      return response.data['resetToken']; // Backend should return resetToken
    } on DioException catch (e) {
      throw ServerFailure(
        message: e.response?.data['message'] ?? 'OTP verification failed',
      );
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }

  @override
  Future<void> resetPasswordWithOtp(
    String resetToken,
    String newPassword,
  ) async {
    try {
      await _apiService.post(
        ApiEndpoints.resetPasswordWithOtp, // NEW endpoint
        data: {'resetToken': resetToken, 'newPassword': newPassword},
      );
      return;
    } on DioException catch (e) {
      throw ServerFailure(
        message: e.response?.data['message'] ?? 'Password reset failed',
      );
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }
}
