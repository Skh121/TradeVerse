import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:tradeverse/features/notification/domain/entity/notification_entity.dart';
import 'package:tradeverse/features/notification/presentation/view_model/notification_event.dart';
import 'package:tradeverse/features/notification/presentation/view_model/notification_state.dart';
import 'package:tradeverse/features/notification/presentation/view_model/notification_view_model.dart';

class NotificationView extends StatefulWidget {
  const NotificationView({super.key});

  @override
  State<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  @override
  void initState() {
    super.initState();
    context.read<NotificationViewModel>().add(MarkAllAsRead());
  }

  IconData _getIconForType(String type) {
    switch (type) {
      case 'goal_achieved':
        return Icons.emoji_events_outlined;
      case 'password_changed':
        return Icons.lock_outline;
      case 'new_message':
        return Icons.mail_outline;
      case 'weekly_summary':
        return Icons.summarize_outlined;
      default:
        return Icons.notifications_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Notifications")),
      body: BlocBuilder<NotificationViewModel, NotificationState>(
        builder: (context, state) {
          if (state is NotificationLoading || state is NotificationInitial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is NotificationError) {
            return Center(child: Text(state.message));
          }
          if (state is NotificationLoaded) {
            if (state.notifications.isEmpty) {
              return const Center(
                child: Text(
                  "You have no notifications.",
                  style: TextStyle(color: Colors.grey),
                ),
              );
            }
            return RefreshIndicator(
              onRefresh: () async {
                context.read<NotificationViewModel>().add(LoadNotifications());
              },
              child: ListView.builder(
                itemCount: state.notifications.length,
                itemBuilder: (context, index) {
                  final notification = state.notifications[index];
                  return _NotificationTile(
                    notification: notification,
                    icon: _getIconForType(notification.type),
                  );
                },
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final NotificationEntity notification;
  final IconData icon;

  const _NotificationTile({required this.notification, required this.icon});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      leading: CircleAvatar(
        backgroundColor:
            notification.isRead
                ? theme.scaffoldBackgroundColor
                : theme.primaryColor.withOpacity(0.1),
        child: Icon(
          icon,
          color: notification.isRead ? Colors.grey : theme.primaryColor,
        ),
      ),
      title: Text(
        notification.text,
        style: TextStyle(
          fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,
        ),
      ),
      subtitle: Text(
        timeago.format(notification.createdAt),
        style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
      ),
      onTap: () {
        if (notification.link != null) {
          print("Navigate to: ${notification.link}");
        }
      },
    );
  }
}
