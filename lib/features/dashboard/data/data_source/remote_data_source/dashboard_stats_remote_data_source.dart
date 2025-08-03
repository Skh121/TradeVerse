import 'package:dio/dio.dart'; // For DioException
import 'package:tradeverse/app/constant/api/api_endpoint.dart'; // For API endpoint constants
import 'package:tradeverse/core/error/exceptions.dart'; // For custom Exception types
import 'package:tradeverse/core/network/api_service.dart'; // Your centralized ApiService
import 'package:tradeverse/features/dashboard/data/data_source/dashboard_stats_data_source.dart'; // The data source interface it implements
import 'package:tradeverse/features/dashboard/data/models/dashboard_stats_model.dart'; // The data model it works with
import 'package:tradeverse/features/dashboard/domain/entity/dashboard_stats_entity.dart'; // Import the entity

class DashboardStatsRemoteDataSource implements IDashboardStatsDataSource {
  final ApiService _apiService; // Dependency on your ApiService

  // Constructor receives the ApiService dependency
  DashboardStatsRemoteDataSource(this._apiService);

  @override
  // 1. THE FIX: Change the return type to match the interface.
  //    Since your DashboardStatsModel can be treated as a DashboardStatsEntity,
  //    this is the only change needed for this method.
  Future<DashboardStatsEntity> getDashboardStats() async {
    try {
      // Make the GET request using ApiService to the dashboard stats endpoint
      final response = await _apiService.get(ApiEndpoints.recentTrades);

      // Check if the HTTP status code indicates success
      if (response.statusCode == 200) {
        // Validate the response data format
        if (response.data is! Map<String, dynamic>) {
          throw const ServerException(
            message:
                'Invalid response format from server: Expected a JSON object.',
          );
        }
        // Parse the JSON response into DashboardStatsModel using json_serializable's fromJson
        return DashboardStatsModel.fromJson(
          response.data as Map<String, dynamic>,
        );
      } else {
        // If status code is not 200, throw a ServerException
        throw ServerException(
          message: 'Server responded with status: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      // Catch specific Dio errors and map them to your custom exceptions
      if (e.response?.statusCode == 401) {
        throw UnauthorizedException(
          message: e.response?.statusMessage ?? 'Unauthorized access.',
        );
      } else if (e.type == DioExceptionType.connectionError) {
        throw const ServerException(
          message: 'Network connection error. Please check your internet.',
        );
      } else if (e.response != null) {
        // For other HTTP errors with a response body
        throw ServerException(
          message:
              'API error: ${e.response!.statusCode} - ${e.response!.statusMessage ?? 'Unknown Status'}',
        );
      } else {
        // For other Dio errors like request cancellation, timeouts, etc.
        throw ServerException(
          message:
              'An unknown Dio error occurred: ${e.message ?? e.toString()}',
        );
      }
    } catch (e) {
      // Catch any other unexpected exceptions (e.g., during JSON parsing)
      throw ServerException(
        message: 'An unexpected error occurred in data source: ${e.toString()}',
      );
    }
  }

  // 2. THE FIX: Add the required cacheDashboardStats method.
  //    Since this is the remote data source, it doesn't need to do anything,
  //    so we provide an empty implementation.
  @override
  Future<void> cacheDashboardStats(DashboardStatsEntity stats) async {
    // This method is intended for the local data source.
    // The remote data source does not need to implement any caching logic here.
    return;
  }
}
