import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradeverse/features/notification/presentation/view/notification_view.dart';
import 'package:tradeverse/features/notification/presentation/view_model/notification_event.dart';
import 'package:tradeverse/features/notification/presentation/view_model/notification_state.dart';
import 'package:tradeverse/features/notification/presentation/view_model/notification_view_model.dart';

class NotificationIcon extends StatefulWidget {
  const NotificationIcon({super.key});

  @override
  State<NotificationIcon> createState() => _NotificationIconState();
}

class _NotificationIconState extends State<NotificationIcon> {
  @override
  void initState() {
    super.initState();
    // Load notifications when the widget is first created
    context.read<NotificationViewModel>().add(LoadNotifications());
  }

  @override
  Widget build(BuildContext context) {
    // This widget now assumes NotificationViewModel is provided by an ancestor.
    // It will listen to state changes and rebuild the badge.
    return BlocBuilder<NotificationViewModel, NotificationState>(
      builder: (context, state) {
        int unreadCount = 0;
        if (state is NotificationLoaded) {
          unreadCount = state.unreadCount;
        }

        return Badge(
          label: Text('$unreadCount'),
          isLabelVisible: unreadCount > 0,
          child: IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const NotificationView()),
              );
            },
          ),
        );
      },
    );
  }
}
