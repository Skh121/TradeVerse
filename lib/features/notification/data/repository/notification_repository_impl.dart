import 'package:tradeverse/core/network/network_info.dart';
import 'package:tradeverse/features/notification/domain/entity/notification_entity.dart';
import 'package:tradeverse/features/notification/domain/repository/notification_repository.dart';
import 'package:tradeverse/features/notification/data/data_source/notification_data_source.dart';

class NotificationRepositoryImpl implements INotificationRepository {
  final INotificationDataSource remoteDataSource;
  final INotificationDataSource localDataSource;
  final INetworkInfo networkInfo;

  NotificationRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Stream<NotificationEntity> get newNotificationStream {
    return remoteDataSource.newNotificationStream.map(
      (model) => model.toEntity(),
    );
  }

  @override
  Future<List<NotificationEntity>> getNotifications() async {
    final isConnected = await networkInfo.isConnected;

    try {
      if (isConnected) {
        final remoteModels = await remoteDataSource.getNotifications();
        await localDataSource.cacheNotifications(remoteModels); // save to Hive
        return remoteModels.map((model) => model.toEntity()).toList();
      } else {
        final localModels = await localDataSource.getNotifications();
        return localModels.map((model) => model.toEntity()).toList();
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> markNotificationsAsRead() async {
    final isConnected = await networkInfo.isConnected;

    try {
      if (isConnected) {
        await remoteDataSource.markNotificationsAsRead();
      }
      await localDataSource.markNotificationsAsRead();
    } catch (e) {
      rethrow;
    }
  }
}
