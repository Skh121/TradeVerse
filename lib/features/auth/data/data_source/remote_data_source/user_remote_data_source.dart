import 'package:dio/dio.dart';
import 'package:tradeverse/app/constant/api/api_endpoint.dart';
import 'package:tradeverse/core/network/api_service.dart';
import 'package:tradeverse/features/auth/data/data_source/auth_data_source.dart';
import 'package:tradeverse/features/auth/data/model/user_api_model.dart';
import 'package:tradeverse/features/auth/domain/entity/user_entity.dart';
 
class UserRemoteDataSource implements IAuthDataSource {
  final ApiService _apiService;
 
  UserRemoteDataSource({required ApiService apiService})
      : _apiService = apiService;
 
  @override
  Future<String> loginToAccount(String email, String password) async {
    try {
      final response = await _apiService.dio.post(
        ApiEndpoints.login,
        data: {'email': email, 'password': password},
      );
 
      if (response.statusCode == 200) {
        final str = response.data['token'];
        return str;
      } else {
        throw Exception(response.statusMessage);
      }
    } on DioException catch (e) {
      throw Exception('Failed to login: ${e.response?.data?['message'] ?? e.message}');
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
        throw Exception('Failed to register: ${response.statusMessage ?? 'Unknown error'}');
      }
    } on DioException catch (e) {
 
      throw Exception('Failed to register: ${e.response?.data?['message'] ?? e.message}');
    } catch (e) {
      throw Exception('Failed to register: $e');
    }
  }
}
 