import 'package:dio/dio.dart';
import 'package:tradeverse/app/constant/api/api_endpoint.dart';
import 'package:tradeverse/core/network/api_service.dart';
import 'package:tradeverse/features/goal/data/data_source/goal_data_source.dart';
import 'package:tradeverse/features/goal/data/model/goal_api_model.dart';
import 'package:tradeverse/features/goal/domain/entity/goal_entity.dart';

class GoalRemoteDataSource implements IGoalDataSource {
  final ApiService _apiService;

  GoalRemoteDataSource({required ApiService apiService})
    : _apiService = apiService;

  @override
  // 1. FIX: Return type changed to Future<GoalEntity> to match the interface.
  Future<GoalEntity> createGoal({
    required String type,
    required String period,
    required double targetValue,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final response = await _apiService.post(
        ApiEndpoints.getGoals,
        data: {
          'type': type,
          'period': period,
          'targetValue': targetValue,
          'startDate': startDate.toIso8601String(),
          'endDate': endDate.toIso8601String(),
        },
      );
      if (response.statusCode == 201) {
        // GoalApiModel can be returned as it extends GoalEntity.
        return GoalApiModel.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to create goal: ${response.statusMessage}',
        );
      }
    } on DioException {
      rethrow;
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  @override
  // 2. FIX: Return type changed to Future<List<GoalEntity>> to match the interface.
  Future<List<GoalEntity>> getGoals() async {
    try {
      final response = await _apiService.get(ApiEndpoints.getGoals);
      if (response.statusCode == 200) {
        final List<dynamic> goalJsonList = response.data as List<dynamic>;
        // The list of GoalApiModels can be returned as it is a List<GoalEntity>.
        return goalJsonList
            .map((json) => GoalApiModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to fetch goals: ${response.statusMessage}',
        );
      }
    } on DioException {
      rethrow;
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  @override
  Future<String> deleteGoal(String id) async {
    try {
      final response = await _apiService.delete(ApiEndpoints.deleteGoal(id));
      if (response.statusCode == 200) {
        return (response.data as Map<String, dynamic>)['message'] as String;
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to delete goal: ${response.statusMessage}',
        );
      }
    } on DioException {
      rethrow;
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  // 3. FIX: Added the required cacheGoals method with an empty implementation.
  @override
  Future<void> cacheGoals(List<GoalEntity> goals) async {
    // This is the remote data source, so it does not perform any caching.
    // This method is intended for the local data source.
    return;
  }
}
