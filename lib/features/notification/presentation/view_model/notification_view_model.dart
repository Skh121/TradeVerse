import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradeverse/features/notification/domain/entity/notification_entity.dart';
import 'package:tradeverse/features/notification/domain/use_case/get_notification_use_case.dart';
import 'package:tradeverse/features/notification/domain/use_case/listen_for_notifications_use_case.dart';
import 'package:tradeverse/features/notification/domain/use_case/mark_all_as_read_use_case.dart';
import 'notification_event.dart';
import 'notification_state.dart';

class NotificationViewModel extends Bloc<NotificationEvent, NotificationState> {
  final GetNotificationUseCase _getNotifications;
  final MarkAllAsReadUseCase _markAllAsRead;
  final ListenForNotificationsUseCase _listenForNotifications;
  StreamSubscription? _notificationSubscription;

  NotificationViewModel({
    required GetNotificationUseCase getNotifications,
    required MarkAllAsReadUseCase markAllAsRead,
    required ListenForNotificationsUseCase listenForNotifications,
  }) : _getNotifications = getNotifications,
       _markAllAsRead = markAllAsRead,
       _listenForNotifications = listenForNotifications,
       super(NotificationInitial()) {
    on<LoadNotifications>(_onLoadNotifications);
    on<MarkAllAsRead>(_onMarkAllAsRead);
    on<NotificationReceived>(_onNotificationReceived);

    _subscribeToNotificationStream();
  }

  void _subscribeToNotificationStream() {
    _notificationSubscription?.cancel();
    _notificationSubscription = _listenForNotifications().listen((
      notification,
    ) {
      add(NotificationReceived(notification));
    });
  }

  Future<void> _onLoadNotifications(
    LoadNotifications event,
    Emitter<NotificationState> emit,
  ) async {
    emit(NotificationLoading());
    final result = await _getNotifications();
    result.fold((failure) => emit(NotificationError(failure.message)), (
      notifications,
    ) {
      final unreadCount = notifications.where((n) => !n.isRead).length;
      emit(
        NotificationLoaded(
          notifications: notifications,
          unreadCount: unreadCount,
        ),
      );
    });
  }

  void _onNotificationReceived(
    NotificationReceived event,
    Emitter<NotificationState> emit,
  ) {
    final currentState = state;
    if (currentState is NotificationLoaded) {
      final updatedList = [event.notification, ...currentState.notifications];
      final unreadCount = updatedList.where((n) => !n.isRead).length;
      emit(
        NotificationLoaded(
          notifications: updatedList,
          unreadCount: unreadCount,
        ),
      );
    }
  }

  Future<void> _onMarkAllAsRead(
    MarkAllAsRead event,
    Emitter<NotificationState> emit,
  ) async {
    final currentState = state;
    if (currentState is NotificationLoaded && currentState.unreadCount > 0) {
      final optimisticNotifications =
          currentState.notifications.map((n) {
            return n.isRead ? n : _copyWith(n, isRead: true);
          }).toList();

      emit(
        NotificationLoaded(
          notifications: optimisticNotifications,
          unreadCount: 0,
        ),
      );

      final result = await _markAllAsRead();
      result.fold(
        (failure) {
          // If the API call fails, revert the state and maybe show an error
          emit(
            NotificationLoaded(
              notifications: currentState.notifications,
              unreadCount: currentState.unreadCount,
            ),
          );
        },
        (_) {}, // On success, do nothing as UI is already updated
      );
    }
  }

  NotificationEntity _copyWith(NotificationEntity entity, {bool? isRead}) {
    return NotificationEntity(
      id: entity.id,
      type: entity.type,
      text: entity.text,
      link: entity.link,
      isRead: isRead ?? entity.isRead,
      createdAt: entity.createdAt,
      sender: entity.sender,
    );
  }

  @override
  Future<void> close() {
    _notificationSubscription?.cancel();
    return super.close();
  }
}
