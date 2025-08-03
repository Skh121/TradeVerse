import 'package:tradeverse/core/error/exceptions.dart';
import 'package:tradeverse/core/network/hive_service.dart';
import 'package:tradeverse/features/notification/data/data_source/notification_data_source.dart';
import 'package:tradeverse/features/notification/data/model/notification_api_model.dart';
import 'package:tradeverse/features/notification/data/model/notification_hive_model.dart';

class NotificationLocalDataSource implements INotificationDataSource {
  final HiveService _hiveService;
  NotificationLocalDataSource({required HiveService hiveService}): _hiveService = hiveService;

  @override
  Future<List<NotificationApiModel>> getNotifications() async {
    try {
      final notifications =
          _hiveService.notificationBox.values
              .map((hiveModel) => hiveModel.toApiModel())
              .toList();
      return notifications;
    } catch (e) {
      throw CacheException(message: 'Failed to get notifications from Hive: $e');
    }
  }

  @override
  Future<void> markNotificationsAsRead() async {
    try {
      for (var notification in _hiveService.notificationBox.values) {
        if (!notification.isRead) {
          notification.isRead = true;
          await notification.save();
        }
      }
    } catch (e) {
      throw CacheException(message: 'Failed to mark notifications as read: $e');
    }
  }

  /// Stream is only provided by remote source via sockets
  @override
  Stream<NotificationApiModel> get newNotificationStream =>
      const Stream.empty();

  /// Save list of notifications from remote to local Hive box
  @override
  Future<void> cacheNotifications(
    List<NotificationApiModel> notifications,
  ) async {
    try {
      await _hiveService.notificationBox.clear();
      for (var model in notifications) {
        final hiveModel = NotificationHiveModel.fromApiModel(model);
        await _hiveService.notificationBox.put(hiveModel.id, hiveModel);
      }
    } catch (e) {
      throw CacheException(message: 'Failed to cache notifications: $e');
    }
  }
}
