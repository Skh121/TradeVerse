import 'package:equatable/equatable.dart';
import 'package:tradeverse/features/notification/domain/entity/notification_entity.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object> get props => [];
}

/// Event to fetch the initial list of notifications.
class LoadNotifications extends NotificationEvent {}

/// Event triggered when a new notification is received from the socket stream.
class NotificationReceived extends NotificationEvent {
  final NotificationEntity notification;

  const NotificationReceived(this.notification);
  @override
  List<Object> get props => [notification];
}

class MarkAllAsRead extends NotificationEvent {}
