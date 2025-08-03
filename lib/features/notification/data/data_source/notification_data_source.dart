import 'package:tradeverse/features/notification/data/model/notification_api_model.dart';

abstract class INotificationDataSource {
  Future<List<NotificationApiModel>> getNotifications();
  Future<void> markNotificationsAsRead();
  Stream<NotificationApiModel> get newNotificationStream;
  Future<void> cacheNotifications(List<NotificationApiModel> notifications);
}
