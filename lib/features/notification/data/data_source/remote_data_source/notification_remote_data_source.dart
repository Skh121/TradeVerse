import 'package:tradeverse/app/constant/api/api_endpoint.dart';
import 'package:tradeverse/core/network/api_service.dart';
import 'package:tradeverse/core/network/socket_service.dart';
import 'package:tradeverse/features/notification/data/data_source/notification_data_source.dart';
import 'package:tradeverse/features/notification/data/model/notification_api_model.dart';

class NotificationRemoteDataSource implements INotificationDataSource {
  final ApiService _apiService;
  final SocketService _socketService;

  NotificationRemoteDataSource({
    required ApiService apiService,
    required SocketService socketService,
  }) : _apiService = apiService,
       _socketService = socketService;

  @override
  Stream<NotificationApiModel> get newNotificationStream =>
      _socketService.onNewNotification;

  @override
  Future<List<NotificationApiModel>> getNotifications() async {
    try {
      final response = await _apiService.get(ApiEndpoints.getMyNotification);
      final data = response.data as List;
      return data.map((item) => NotificationApiModel.fromJson(item)).toList();
    } catch (e) {
      // Your DioErrorInterceptor in ApiService will handle Dio-specific errors.
      // This catch block is for any other potential exceptions.
      print('Error in getNotifications data source: $e');
      rethrow;
    }
  }

  @override
  Future<void> markNotificationsAsRead() async {
    try {
      await _apiService.post(ApiEndpoints.markNotificationAsRead);
    } catch (e) {
      print('Error in markNotificationsAsRead data source: $e');
      rethrow;
    }
  }

  @override
  Future<void> cacheNotifications(List<NotificationApiModel> notifications) {
    throw UnimplementedError(
      "cacheNotifications not supported in remote data source.",
    );
  }
}
