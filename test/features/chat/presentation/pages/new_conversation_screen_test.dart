import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:tradeverse/features/chat/domain/entity/user.dart';
import 'package:tradeverse/features/chat/domain/entity/conversation.dart';
import 'package:tradeverse/features/chat/presentation/pages/new_conversation_screen.dart';
import 'package:tradeverse/features/chat/presentation/view_model/chat_bloc.dart';
import 'package:tradeverse/features/chat/presentation/view_model/chat_event.dart';
import 'package:tradeverse/features/chat/presentation/view_model/chat_state.dart';

// Mock Classes
class MockChatBloc extends Mock implements ChatBloc {}

class FakeChatEvent extends Fake implements ChatEvent {}

class FakeChatState extends Fake implements ChatState {}

void main() {
  late MockChatBloc chatBloc;

  final currentUser = User(
    id: 'user1',
    fullName: 'Current User',
    role: 'Member',
  );

  setUpAll(() {
    registerFallbackValue(FakeChatEvent());
    registerFallbackValue(FakeChatState());
  });

  setUp(() {
    chatBloc = MockChatBloc();
  });

  Widget makeTestableWidget() {
    return MaterialApp(
      home: BlocProvider<ChatBloc>.value(
        value: chatBloc,
        child: NewConversationScreen(currentUser: currentUser),
      ),
    );
  }

  testWidgets('should dispatch LoadChatUsers event on initState', (
    tester,
  ) async {
    when(() => chatBloc.state).thenReturn(ChatInitial());
    when(() => chatBloc.stream).thenAnswer((_) => const Stream.empty());

    await tester.pumpWidget(makeTestableWidget());
    verify(() => chatBloc.add(const LoadChatUsers())).called(1);
  });

  testWidgets(
    'should display loading indicator when chatUsersStatus is loading',
    (tester) async {
      when(() => chatBloc.state).thenReturn(
        ChatLoaded(
          conversations: const [],
          messages: const [],
          chatUsers: const [],
          chatUsersStatus: ChatUsersLoadingStatus.loading,
        ),
      );
      when(() => chatBloc.stream).thenAnswer((_) => const Stream.empty());

      await tester.pumpWidget(makeTestableWidget());

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    },
  );

  testWidgets('should display no users text when chatUsers list is empty', (
    tester,
  ) async {
    when(() => chatBloc.state).thenReturn(
      ChatLoaded(
        conversations: const [],
        messages: const [],
        chatUsers: const [],
        chatUsersStatus: ChatUsersLoadingStatus.loaded,
      ),
    );
    when(() => chatBloc.stream).thenAnswer((_) => const Stream.empty());

    await tester.pumpWidget(makeTestableWidget());

    expect(find.text('No other users found.'), findsOneWidget);
  });

  testWidgets(
    'should display list of users excluding current user and respond to tap',
    (tester) async {
      final otherUser = User(
        id: 'user2',
        fullName: 'Other User',
        role: 'Admin',
      );

      when(() => chatBloc.state).thenReturn(
        ChatLoaded(
          conversations: const [],
          messages: const [],
          chatUsers: [currentUser, otherUser],
          chatUsersStatus: ChatUsersLoadingStatus.loaded,
        ),
      );
      when(() => chatBloc.stream).thenAnswer((_) => const Stream.empty());

      when(() => chatBloc.add(any())).thenReturn(null);

      await tester.pumpWidget(makeTestableWidget());

      expect(find.text('Other User'), findsOneWidget);
      expect(find.text('Current User'), findsNothing);

      await tester.tap(find.text('Other User'));
      await tester.pump();

      verify(
        () => chatBloc.add(
          FindOrCreateNewConversation(recipientId: otherUser.id),
        ),
      ).called(1);
      expect(find.text('Processing...'), findsOneWidget);
    },
  );

  testWidgets('should show error snackbar when ChatError state emitted', (
    tester,
  ) async {
    final errorState = ChatError(message: 'Error occurred');

    final controller = StreamController<ChatState>.broadcast();

    when(() => chatBloc.state).thenReturn(ChatInitial());
    when(() => chatBloc.stream).thenAnswer((_) => controller.stream);

    await tester.pumpWidget(makeTestableWidget());

    // Add error state to stream to trigger BlocConsumer listener
    controller.add(errorState);
    await tester.pump(); // rebuild widget after state change

    expect(find.text('Error occurred'), findsOneWidget);

    await controller.close();
  });

  testWidgets(
    'should show success snackbar and pop on ConversationOperationSuccess',
    (tester) async {
      final conversation = Conversation(
        id: 'conv1',
        participants: [],
        updatedAt: DateTime.now(),
      );

      final successState = ConversationOperationSuccess(
        conversation: conversation,
        isNewConversation: true,
      );

      final navigatorKey = GlobalKey<NavigatorState>();

      final controller = StreamController<ChatState>.broadcast();

      when(() => chatBloc.state).thenReturn(ChatInitial());
      when(() => chatBloc.stream).thenAnswer((_) => controller.stream);

      await tester.pumpWidget(
        MaterialApp(
          navigatorKey: navigatorKey,
          home: BlocProvider<ChatBloc>.value(
            value: chatBloc,
            child: NewConversationScreen(currentUser: currentUser),
          ),
        ),
      );

      controller.add(successState);
      await tester.pump();

      expect(find.text('User added for conversation!'), findsOneWidget);

      // Wait for snackbar animation and navigation pop
      await tester.pumpAndSettle();

      await controller.close();
    },
  );
}
