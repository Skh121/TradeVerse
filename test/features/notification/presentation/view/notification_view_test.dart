import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tradeverse/features/notification/domain/entity/notification_entity.dart';
import 'package:tradeverse/features/notification/presentation/view/notification_view.dart';
import 'package:tradeverse/features/notification/presentation/view_model/notification_event.dart';
import 'package:tradeverse/features/notification/presentation/view_model/notification_state.dart';
import 'package:tradeverse/features/notification/presentation/view_model/notification_view_model.dart';

// Mocks for BLoC and Events
class MockNotificationViewModel extends Mock implements NotificationViewModel {}

class FakeNotificationEvent extends Fake implements NotificationEvent {}

class FakeNotificationState extends Fake implements NotificationState {}

// A custom state to test the fallback SizedBox.shrink()
class UnknownNotificationState extends NotificationState {}

void main() {
  // Declare test-wide variables
  late MockNotificationViewModel mockNotificationViewModel;
  late List<NotificationEntity> testNotifications;

  // Runs once before all tests in this file
  setUpAll(() {
    registerFallbackValue(FakeNotificationEvent());
    registerFallbackValue(FakeNotificationState());
  });

  // Runs before each test to ensure a clean state
  setUp(() {
    mockNotificationViewModel = MockNotificationViewModel();

    // Create comprehensive test data covering all cases
    testNotifications = [
      // Unread with link, type 'goal_achieved'
      NotificationEntity(
        id: '1',
        type: 'goal_achieved',
        text: 'Goal Achieved!',
        link: '/goals',
        isRead: false,
        createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
      ),
      // Read, type 'password_changed'
      NotificationEntity(
        id: '2',
        type: 'password_changed',
        text: 'Password Changed',
        link: null,
        isRead: true,
        createdAt: DateTime.now().subtract(const Duration(hours: 1)),
      ),
      // Unread, type 'new_message'
      NotificationEntity(
        id: '3',
        type: 'new_message',
        text: 'New Message',
        link: '/chat/123',
        isRead: false,
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
      // Unread, type 'weekly_summary'
      NotificationEntity(
        id: '4',
        type: 'weekly_summary',
        text: 'Weekly Summary Ready',
        link: '/summary',
        isRead: false,
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
      ),
      // Unread, default icon type
      NotificationEntity(
        id: '5',
        type: 'promo',
        text: 'Special Offer',
        link: '/offers',
        isRead: false,
        createdAt: DateTime.now().subtract(const Duration(days: 4)),
      ),
    ];
  });

  // Helper to pump the NotificationView widget with a mock BLoC
  Future<void> pumpWidget(WidgetTester tester) async {
    // When the BLoC is created, the stream is listened to. We need to mock this.
    when(
      () => mockNotificationViewModel.stream,
    ).thenAnswer((_) => const Stream.empty());
    when(() => mockNotificationViewModel.close()).thenAnswer((_) async {});

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<NotificationViewModel>.value(
          value: mockNotificationViewModel,
          child: const NotificationView(),
        ),
      ),
    );
  }

  group('NotificationView', () {
    testWidgets('dispatches MarkAllAsRead on initState', (tester) async {
      // Arrange
      when(
        () => mockNotificationViewModel.state,
      ).thenReturn(NotificationInitial());

      // Act
      await pumpWidget(tester);

      // Assert
      verify(() => mockNotificationViewModel.add(MarkAllAsRead())).called(1);
    });

    group('UI Rendering based on State', () {
      testWidgets('shows loading indicator for NotificationInitial state', (
        tester,
      ) async {
        when(
          () => mockNotificationViewModel.state,
        ).thenReturn(NotificationInitial());
        await pumpWidget(tester);
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });

      testWidgets('shows loading indicator for NotificationLoading state', (
        tester,
      ) async {
        when(
          () => mockNotificationViewModel.state,
        ).thenReturn(NotificationLoading());
        await pumpWidget(tester);
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });

      testWidgets('shows error message for NotificationError state', (
        tester,
      ) async {
        const errorMessage = 'Failed to load';
        when(
          () => mockNotificationViewModel.state,
        ).thenReturn(const NotificationError(errorMessage));
        await pumpWidget(tester);
        expect(find.text(errorMessage), findsOneWidget);
      });

      testWidgets(
        'shows "no notifications" message when loaded with empty list',
        (tester) async {
          when(() => mockNotificationViewModel.state).thenReturn(
            const NotificationLoaded(notifications: [], unreadCount: 0),
          );
          await pumpWidget(tester);
          expect(find.text('You have no notifications.'), findsOneWidget);
        },
      );

      testWidgets('shows list of notifications for NotificationLoaded state', (
        tester,
      ) async {
        when(() => mockNotificationViewModel.state).thenReturn(
          NotificationLoaded(notifications: testNotifications, unreadCount: 4),
        );
        await pumpWidget(tester);
        expect(find.byType(ListView), findsOneWidget);
        // The private `_NotificationTile` is implemented as a ListTile
        expect(find.byType(ListTile), findsNWidgets(testNotifications.length));
      });

      testWidgets('shows SizedBox.shrink for unknown states', (tester) async {
        when(
          () => mockNotificationViewModel.state,
        ).thenReturn(UnknownNotificationState());
        await pumpWidget(tester);
        expect(find.byType(SizedBox), findsOneWidget);
        expect(find.byType(ListView), findsNothing);
      });
    });

    group('User Interactions', () {
      testWidgets('dispatches LoadNotifications on pull-to-refresh', (
        tester,
      ) async {
        // Arrange
        when(() => mockNotificationViewModel.state).thenReturn(
          NotificationLoaded(notifications: testNotifications, unreadCount: 4),
        );
        await pumpWidget(tester);

        // Act
        // Simulate a pull-down gesture to trigger the RefreshIndicator
        await tester.drag(find.byType(ListView), const Offset(0, 300));
        await tester.pumpAndSettle(); // Wait for the refresh to complete

        // Assert
        verify(
          () => mockNotificationViewModel.add(LoadNotifications()),
        ).called(1);
      });

      testWidgets('prints navigation link when a tile with a link is tapped', (
        tester,
      ) async {
        // Arrange
        final printLogs = <String>[]; // To capture print output
        when(() => mockNotificationViewModel.state).thenReturn(
          NotificationLoaded(notifications: testNotifications, unreadCount: 4),
        );

        await runZoned(
          () async {
            await pumpWidget(tester);
            // Find the first notification tile, which has a link
            await tester.tap(find.text('Goal Achieved!'));
          },
          zoneSpecification: ZoneSpecification(
            print: (self, parent, zone, line) {
              printLogs.add(line);
            },
          ),
        );

        // Assert
        expect(printLogs, contains('Navigate to: /goals'));
      });

      testWidgets('does nothing when a tile without a link is tapped', (
        tester,
      ) async {
        // Arrange
        final printLogs = <String>[];
        when(() => mockNotificationViewModel.state).thenReturn(
          NotificationLoaded(notifications: testNotifications, unreadCount: 4),
        );

        await runZoned(
          () async {
            await pumpWidget(tester);
            // Find the notification tile for 'Password Changed', which has no link
            await tester.tap(find.text('Password Changed'));
          },
          zoneSpecification: ZoneSpecification(
            print: (self, parent, zone, line) {
              printLogs.add(line);
            },
          ),
        );

        // Assert
        expect(printLogs, isEmpty);
      });
    });

    group('Widget Logic Coverage', () {
      testWidgets('displays correct icon for each notification type', (
        tester,
      ) async {
        // Arrange
        when(() => mockNotificationViewModel.state).thenReturn(
          NotificationLoaded(notifications: testNotifications, unreadCount: 4),
        );
        await pumpWidget(tester);

        // Assert
        expect(find.byIcon(Icons.emoji_events_outlined), findsOneWidget);
        expect(find.byIcon(Icons.lock_outline), findsOneWidget);
        expect(find.byIcon(Icons.mail_outline), findsOneWidget);
        expect(find.byIcon(Icons.summarize_outlined), findsOneWidget);
        expect(
          find.byIcon(Icons.notifications_outlined),
          findsOneWidget,
        ); // For the default case
      });

      testWidgets('displays bold text for unread notifications', (
        tester,
      ) async {
        // Arrange
        when(() => mockNotificationViewModel.state).thenReturn(
          NotificationLoaded(notifications: testNotifications, unreadCount: 4),
        );
        await pumpWidget(tester);

        // Act
        final unreadTitle = tester.widget<Text>(find.text('Goal Achieved!'));

        // Assert
        expect(unreadTitle.style?.fontWeight, FontWeight.bold);
      });

      testWidgets('displays normal text for read notifications', (
        tester,
      ) async {
        // Arrange
        when(() => mockNotificationViewModel.state).thenReturn(
          NotificationLoaded(notifications: testNotifications, unreadCount: 4),
        );
        await pumpWidget(tester);

        // Act
        final readTitle = tester.widget<Text>(find.text('Password Changed'));

        // Assert
        expect(readTitle.style?.fontWeight, FontWeight.normal);
      });
    });
  });
}
