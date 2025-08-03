import 'package:tradeverse/features/notification/domain/entity/notification_entity.dart';

abstract class INotificationRepository {
  Future<List<NotificationEntity>> getNotifications();
  Future<void> markNotificationsAsRead();
  Stream<NotificationEntity> get newNotificationStream;
}
