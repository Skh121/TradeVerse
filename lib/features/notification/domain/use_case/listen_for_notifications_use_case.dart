import 'package:tradeverse/features/notification/domain/entity/notification_entity.dart';
import 'package:tradeverse/features/notification/domain/repository/notification_repository.dart';

class ListenForNotificationsUseCase {
  final INotificationRepository _repository;

  ListenForNotificationsUseCase(this._repository);

  Stream<NotificationEntity> call() {
    return _repository.newNotificationStream;
  }
}
