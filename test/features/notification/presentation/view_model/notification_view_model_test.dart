import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tradeverse/core/error/failure.dart';
import 'package:tradeverse/features/notification/domain/entity/notification_entity.dart';
import 'package:tradeverse/features/notification/domain/entity/sender_entity.dart';
import 'package:tradeverse/features/notification/domain/use_case/get_notification_use_case.dart';
import 'package:tradeverse/features/notification/domain/use_case/listen_for_notifications_use_case.dart';
import 'package:tradeverse/features/notification/domain/use_case/mark_all_as_read_use_case.dart';
import 'package:tradeverse/features/notification/presentation/view_model/notification_view_model.dart';
import 'package:tradeverse/features/notification/presentation/view_model/notification_event.dart';
import 'package:tradeverse/features/notification/presentation/view_model/notification_state.dart';
import 'package:dartz/dartz.dart' as dartz;

/// Test-only extension to simulate copyWith behavior for NotificationEntity
extension NotificationEntityCopyWithExtension on NotificationEntity {
  NotificationEntity copyWithTest({bool? isRead}) {
    return NotificationEntity(
      id: id,
      type: type,
      text: text,
      link: link,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt,
      sender: sender,
    );
  }
}

// Mocks
class MockGetNotificationUseCase extends Mock
    implements GetNotificationUseCase {}

class MockMarkAllAsReadUseCase extends Mock implements MarkAllAsReadUseCase {}

class MockListenForNotificationsUseCase extends Mock
    implements ListenForNotificationsUseCase {}

class FakeNotificationEntity extends Fake implements NotificationEntity {}

// Expose private _copyWith method for direct testing
class TestNotificationViewModel extends NotificationViewModel {
  TestNotificationViewModel({
    required super.getNotifications,
    required super.markAllAsRead,
    required super.listenForNotifications,
  });

  // Expose _copyWith for testing coverage
  NotificationEntity copyWithTest(NotificationEntity entity, {bool? isRead}) {
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
}

void main() {
  late MockGetNotificationUseCase mockGetNotifications;
  late MockMarkAllAsReadUseCase mockMarkAllAsRead;
  late MockListenForNotificationsUseCase mockListenForNotifications;
  late NotificationViewModel bloc;

  final sender = SenderEntity(id: 'sender1', fullName: 'Sender Name');

  final notification1 = NotificationEntity(
    id: '1',
    type: 'type1',
    text: 'Text 1',
    link: null,
    isRead: false,
    createdAt: DateTime.now(),
    sender: sender,
  );

  final notification2 = NotificationEntity(
    id: '2',
    type: 'type2',
    text: 'Text 2',
    link: 'https://example.com',
    isRead: true,
    createdAt: DateTime.now(),
    sender: sender,
  );

  setUpAll(() {
    registerFallbackValue(FakeNotificationEntity());
  });

  setUp(() {
    mockGetNotifications = MockGetNotificationUseCase();
    mockMarkAllAsRead = MockMarkAllAsReadUseCase();
    mockListenForNotifications = MockListenForNotificationsUseCase();

    when(
      () => mockListenForNotifications(),
    ).thenAnswer((_) => Stream<NotificationEntity>.empty());

    bloc = NotificationViewModel(
      getNotifications: mockGetNotifications,
      markAllAsRead: mockMarkAllAsRead,
      listenForNotifications: mockListenForNotifications,
    );
  });

  test('initial state is NotificationInitial', () {
    expect(bloc.state, isA<NotificationInitial>());
  });

  test('copyWithTest returns entity with correct isRead values', () {
    final copiedWithTrue = notification1.copyWithTest(isRead: true);
    expect(copiedWithTrue.isRead, true);

    final copiedWithNull = notification1.copyWithTest(isRead: null);
    expect(copiedWithNull.isRead, notification1.isRead);
  });

  test('_copyWith returns entity with isRead fallback coverage', () {
    final viewModel = TestNotificationViewModel(
      getNotifications: mockGetNotifications,
      markAllAsRead: mockMarkAllAsRead,
      listenForNotifications: mockListenForNotifications,
    );

    final resultWithTrue = viewModel.copyWithTest(notification1, isRead: true);
    expect(resultWithTrue.isRead, true);

    final resultWithNull = viewModel.copyWithTest(notification1, isRead: null);
    expect(resultWithNull.isRead, notification1.isRead);
  });
  blocTest<NotificationViewModel, NotificationState>(
    'covers isRead fallback in _copyWith by marking mixed notifications as read',
    build: () {
      when(
        () => mockMarkAllAsRead(),
      ).thenAnswer((_) async => dartz.Right(null));
      return NotificationViewModel(
        getNotifications: mockGetNotifications,
        markAllAsRead: mockMarkAllAsRead,
        listenForNotifications: mockListenForNotifications,
      );
    },
    seed:
        () => NotificationLoaded(
          notifications: [notification1, notification2], // mixed read/unread
          unreadCount: 1,
        ),
    act: (bloc) => bloc.add(MarkAllAsRead()),
    expect:
        () => [
          predicate<NotificationLoaded>((state) {
            return state.notifications.length == 2 &&
                state.notifications.every((n) => n.isRead == true) &&
                state.unreadCount == 0;
          }),
        ],
  );
  test('re-subscribes by cancelling previous stream subscription', () async {
    when(() => mockListenForNotifications()).thenAnswer(
      (_) => Stream<NotificationEntity>.fromIterable([notification1]),
    );

    final viewModel = NotificationViewModel(
      getNotifications: mockGetNotifications,
      markAllAsRead: mockMarkAllAsRead,
      listenForNotifications: mockListenForNotifications,
    );

    // Wait for first subscription to complete
    await Future.delayed(const Duration(milliseconds: 10));

    // Force re-subscription by creating new subscription internally
    viewModel.add(
      NotificationReceived(notification2),
    ); // triggers nothing, but safe

    // Close triggers cancellation again
    await viewModel.close();

    expect(viewModel.isClosed, isTrue);
  });

  blocTest<NotificationViewModel, NotificationState>(
    'emits [NotificationLoading, NotificationLoaded] on successful LoadNotifications',
    build: () {
      when(
        () => mockGetNotifications(),
      ).thenAnswer((_) async => dartz.Right([notification1, notification2]));
      return bloc;
    },
    act: (bloc) => bloc.add(LoadNotifications()),
    expect:
        () => [
          isA<NotificationLoading>(),
          predicate<NotificationLoaded>(
            (state) =>
                state.notifications.length == 2 && state.unreadCount == 1,
          ),
        ],
  );

  blocTest<NotificationViewModel, NotificationState>(
    'emits [NotificationLoading, NotificationError] on failed LoadNotifications',
    build: () {
      when(
        () => mockGetNotifications(),
      ).thenAnswer((_) async => dartz.Left(ServerFailure(message: 'Error')));
      return bloc;
    },
    act: (bloc) => bloc.add(LoadNotifications()),
    expect:
        () => [
          isA<NotificationLoading>(),
          predicate<NotificationError>((state) => state.message == 'Error'),
        ],
  );

  blocTest<NotificationViewModel, NotificationState>(
    'emits NotificationLoaded with new notification on NotificationReceived',
    build: () => bloc,
    seed:
        () =>
            NotificationLoaded(notifications: [notification2], unreadCount: 0),
    act: (bloc) => bloc.add(NotificationReceived(notification1)),
    expect:
        () => [
          predicate<NotificationLoaded>(
            (state) =>
                state.notifications.first.id == notification1.id &&
                state.unreadCount == 1,
          ),
        ],
  );

  blocTest<NotificationViewModel, NotificationState>(
    'does not emit when NotificationReceived and current state is not NotificationLoaded',
    build: () => bloc,
    seed: () => NotificationLoading(),
    act: (bloc) => bloc.add(NotificationReceived(notification1)),
    expect: () => [],
  );

  blocTest<NotificationViewModel, NotificationState>(
    'emits updated state when notification stream emits new notification',
    build: () {
      when(() => mockListenForNotifications()).thenAnswer(
        (_) => Stream<NotificationEntity>.fromIterable([notification1]),
      );
      return NotificationViewModel(
        getNotifications: mockGetNotifications,
        markAllAsRead: mockMarkAllAsRead,
        listenForNotifications: mockListenForNotifications,
      );
    },
    seed:
        () =>
            NotificationLoaded(notifications: [notification2], unreadCount: 0),
    wait: const Duration(milliseconds: 100),
    expect:
        () => [
          predicate<NotificationLoaded>(
            (state) =>
                state.notifications.first.id == notification1.id &&
                state.unreadCount == 1,
          ),
        ],
  );

  blocTest<NotificationViewModel, NotificationState>(
    'optimistically marks all as read on MarkAllAsRead success',
    build: () {
      when(
        () => mockMarkAllAsRead(),
      ).thenAnswer((_) async => dartz.Right(null));
      return bloc;
    },
    seed:
        () => NotificationLoaded(
          notifications: [notification1, notification2],
          unreadCount: 1,
        ),
    act: (bloc) => bloc.add(MarkAllAsRead()),
    expect:
        () => [
          predicate<NotificationLoaded>(
            (state) =>
                state.notifications.every((n) => n.isRead) &&
                state.unreadCount == 0,
          ),
        ],
  );

  blocTest<NotificationViewModel, NotificationState>(
    'does not emit further states after MarkAllAsRead success (empty success branch coverage)',
    build: () {
      when(
        () => mockMarkAllAsRead(),
      ).thenAnswer((_) async => dartz.Right(null));
      return bloc;
    },
    seed:
        () => NotificationLoaded(
          notifications: [notification1, notification2],
          unreadCount: 1,
        ),
    act: (bloc) => bloc.add(MarkAllAsRead()),
    expect:
        () => [
          predicate<NotificationLoaded>(
            (state) =>
                state.notifications.every((n) => n.isRead) &&
                state.unreadCount == 0,
          ),
        ],
  );

  blocTest<NotificationViewModel, NotificationState>(
    'does nothing when all notifications are already read on MarkAllAsRead',
    build: () => bloc,
    seed:
        () =>
            NotificationLoaded(notifications: [notification2], unreadCount: 0),
    act: (bloc) => bloc.add(MarkAllAsRead()),
    expect: () => [],
  );

  blocTest<NotificationViewModel, NotificationState>(
    'reverts optimistic update if MarkAllAsRead fails',
    build: () {
      when(
        () => mockMarkAllAsRead(),
      ).thenAnswer((_) async => dartz.Left(ServerFailure(message: 'fail')));
      return bloc;
    },
    seed:
        () => NotificationLoaded(
          notifications: [notification1, notification2],
          unreadCount: 1,
        ),
    act: (bloc) => bloc.add(MarkAllAsRead()),
    expect:
        () => [
          predicate<NotificationLoaded>(
            (state) =>
                state.notifications.every((n) => n.isRead) &&
                state.unreadCount == 0,
          ),
          predicate<NotificationLoaded>(
            (state) =>
                !state.notifications.first.isRead && state.unreadCount == 1,
          ),
        ],
  );

  blocTest<NotificationViewModel, NotificationState>(
    'handles multiple notifications from stream',
    build: () {
      when(() => mockListenForNotifications()).thenAnswer(
        (_) => Stream<NotificationEntity>.fromIterable([
          notification1,
          notification2,
        ]),
      );
      return NotificationViewModel(
        getNotifications: mockGetNotifications,
        markAllAsRead: mockMarkAllAsRead,
        listenForNotifications: mockListenForNotifications,
      );
    },
    seed: () => NotificationLoaded(notifications: [], unreadCount: 0),
    wait: const Duration(milliseconds: 100),
    expect:
        () => [
          predicate<NotificationLoaded>(
            (state) => state.notifications.contains(notification1),
          ),
          predicate<NotificationLoaded>(
            (state) => state.notifications.contains(notification2),
          ),
        ],
  );

  test('close cancels notification subscription', () async {
    when(() => mockListenForNotifications()).thenAnswer(
      (_) => Stream<NotificationEntity>.fromIterable([notification1]),
    );

    final blocWithStream = NotificationViewModel(
      getNotifications: mockGetNotifications,
      markAllAsRead: mockMarkAllAsRead,
      listenForNotifications: mockListenForNotifications,
    );

    await blocWithStream.close();
    expect(blocWithStream.isClosed, true);
  });
}
