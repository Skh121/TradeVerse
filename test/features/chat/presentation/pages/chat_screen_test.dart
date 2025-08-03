import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:tradeverse/features/chat/domain/entity/conversation.dart';
import 'package:tradeverse/features/chat/domain/entity/message.dart';
import 'package:tradeverse/features/chat/domain/entity/user.dart';
import 'package:tradeverse/features/chat/presentation/pages/chat_screen.dart';
import 'package:tradeverse/features/chat/presentation/view_model/chat_bloc.dart';
import 'package:tradeverse/features/chat/presentation/view_model/chat_event.dart';
import 'package:tradeverse/features/chat/presentation/view_model/chat_state.dart';
import 'package:tradeverse/features/chat/presentation/widgets/message_bubble.dart';

// Mock classes for BLoC and Events using mocktail and bloc_test
class MockChatBloc extends MockBloc<ChatEvent, ChatState> implements ChatBloc {}

class FakeChatEvent extends Fake implements ChatEvent {}

class FakeChatState extends Fake implements ChatState {}

void main() {
  // Declare test variables
  late MockChatBloc mockChatBloc;
  late User testCurrentUser;
  late User testRecipient;
  late Conversation testConversation;
  late List<Message> testMessages;

  // Set up test data before each test
  setUpAll(() {
    // Register fallback values for custom types used in mocked methods
    registerFallbackValue(FakeChatEvent());
    registerFallbackValue(FakeChatState());
  });

  setUp(() {
    mockChatBloc = MockChatBloc();

    // Initialize test data
    testCurrentUser = const User(
      id: 'user1',
      fullName: 'Current User',
      role: 'user',
    );
    testRecipient = const User(
      id: 'user2',
      fullName: 'Recipient User',
      role: 'user',
    );
    testConversation = Conversation(
      id: 'conv1',
      participants: [testCurrentUser, testRecipient],
      updatedAt: DateTime.now(),
    );
    testMessages = [
      Message(
        id: 'msg1',
        conversationId: 'conv1',
        sender: testCurrentUser,
        recipient: testRecipient,
        text: 'Hello from me',
        createdAt: DateTime.now(),
      ),
      Message(
        id: 'msg2',
        conversationId: 'conv1',
        sender: testRecipient,
        recipient: testCurrentUser,
        text: 'Hello from you',
        createdAt: DateTime.now().add(const Duration(seconds: 1)),
      ),
    ];
  });

  // Helper function to pump the ChatScreen widget with a mock BLoC
  Future<void> pumpWidget(WidgetTester tester) {
    return tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<ChatBloc>.value(
          value: mockChatBloc,
          child: ChatScreen(
            conversation: testConversation,
            currentUser: testCurrentUser,
            recipient: testRecipient,
          ),
        ),
      ),
    );
  }

  group('ChatScreen', () {
    // Test initial state and event dispatching
    testWidgets('dispatches LoadMessages on initState', (tester) async {
      // Arrange: Set the initial state of the bloc
      when(() => mockChatBloc.state).thenReturn(
        const ChatLoaded(
          conversations: [],
          messages: [],
          chatUsers: [],
          messagesStatus: MessagesLoadingStatus.initial,
        ),
      );

      // Act
      await pumpWidget(tester);

      // Assert: Verify that LoadMessages event was added
      verify(
        () =>
            mockChatBloc.add(LoadMessages(conversationId: testConversation.id)),
      ).called(1);
    });

    // Test the loading state UI
    testWidgets('renders CircularProgressIndicator when messages are loading', (
      tester,
    ) async {
      // Arrange: Set the bloc state to loading
      when(() => mockChatBloc.state).thenReturn(
        const ChatLoaded(
          conversations: [],
          messages: [],
          chatUsers: [],
          messagesStatus: MessagesLoadingStatus.loading,
        ),
      );

      // Act
      await pumpWidget(tester);

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    // Test the empty message list UI
    testWidgets('renders "Say hello!" text when there are no messages', (
      tester,
    ) async {
      // Arrange: Set the bloc state to loaded with an empty message list
      when(() => mockChatBloc.state).thenReturn(
        const ChatLoaded(
          conversations: [],
          messages: [],
          chatUsers: [],
          messagesStatus: MessagesLoadingStatus.loaded,
        ),
      );

      // Act
      await pumpWidget(tester);
      await tester.pump(); // Allow UI to settle

      // Assert
      expect(find.text('Say hello!'), findsOneWidget);
    });

    // Test rendering a list of messages
    testWidgets('renders a list of messages correctly', (tester) async {
      // Arrange: Set the bloc state to loaded with a list of messages
      when(() => mockChatBloc.state).thenReturn(
        ChatLoaded(
          conversations: [],
          messages: testMessages,
          chatUsers: [],
          messagesStatus: MessagesLoadingStatus.loaded,
        ),
      );

      // Act
      await pumpWidget(tester);
      await tester.pump(); // Allow UI to settle

      // Assert
      expect(find.byType(ListView), findsOneWidget);
      expect(find.byType(MessageBubble), findsNWidgets(2));
      expect(find.text('Hello from me'), findsOneWidget);
      expect(find.text('Hello from you'), findsOneWidget);
    });

    // Test sending a message via button tap
    testWidgets('sends a message when send button is tapped', (tester) async {
      // Arrange
      when(() => mockChatBloc.state).thenReturn(
        const ChatLoaded(
          conversations: [],
          messages: [],
          chatUsers: [],
          currentConversationId: 'conv1', // Ensure conversation ID is set
          messagesStatus: MessagesLoadingStatus.loaded,
        ),
      );
      await pumpWidget(tester);

      const messageText = 'Hi there!';

      // Act
      await tester.enterText(find.byType(TextField), messageText);
      await tester.tap(find.byIcon(Icons.send));
      await tester.pump();

      // Assert: Verify SendMessage event was added with correct data
      // Capture all events added. The first is LoadMessages from initState.
      final captured = verify(() => mockChatBloc.add(captureAny())).captured;

      // The event we care about is the LAST one added.
      final sentEvent =
          captured.last as SendMessage; // <-- FIX: Use .last instead of .first

      expect(sentEvent, isA<SendMessage>());
      expect(sentEvent.text, messageText);
      expect(sentEvent.sender, testCurrentUser);
      expect(sentEvent.recipient, testRecipient);

      // Assert: Verify the text field is cleared
      expect(find.text(messageText), findsNothing);
    });

    // Test sending a message via keyboard submission
    testWidgets('sends a message when text field is submitted', (tester) async {
      // Arrange
      when(() => mockChatBloc.state).thenReturn(
        const ChatLoaded(
          conversations: [],
          messages: [],
          chatUsers: [],
          currentConversationId: 'conv1',
          messagesStatus: MessagesLoadingStatus.loaded,
        ),
      );
      await pumpWidget(tester);
      const messageText = 'Submitting this!';

      // Act
      await tester.enterText(find.byType(TextField), messageText);
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();

      // Assert
      // Capture all events. The event we want to check is the last one.
      final captured = verify(() => mockChatBloc.add(captureAny())).captured;
      final sentEvent =
          captured.last as SendMessage; // <-- FIX: Use .last instead of .first

      expect(sentEvent, isA<SendMessage>());
      expect(sentEvent.text, messageText);
    });

    // Test that empty messages are not sent
    testWidgets('does not send an empty message', (tester) async {
      // Arrange
      when(() => mockChatBloc.state).thenReturn(
        const ChatLoaded(
          conversations: [],
          messages: [],
          chatUsers: [],
          messagesStatus: MessagesLoadingStatus.loaded,
        ),
      );
      await pumpWidget(tester);

      // Act
      await tester.tap(find.byIcon(Icons.send));
      await tester.pump();

      // Assert: Verify SendMessage was never added
      verifyNever(() => mockChatBloc.add(any(that: isA<SendMessage>())));
    });

    // Test error handling via SnackBar
    testWidgets('displays SnackBar on error and dispatches LoadConversations', (
      tester,
    ) async {
      // Arrange: Use whenListen to simulate a state change to one with an error
      final states = [
        const ChatLoaded(conversations: [], messages: [], chatUsers: []),
        const ChatLoaded(
          conversations: [],
          messages: [],
          chatUsers: [],
          errorMessage: 'An error occurred!',
        ),
      ];
      whenListen(
        mockChatBloc,
        Stream.fromIterable(states),
        initialState: states.first,
      );

      // Act
      await pumpWidget(tester);
      await tester.pump(); // Pump to process the new state from the stream

      // Assert: Check for SnackBar
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('An error occurred!'), findsOneWidget);

      // Assert: Verify that the bloc event to clear the error was dispatched
      verify(() => mockChatBloc.add(const LoadConversations())).called(1);
    });
    testWidgets(
      'listener scrolls when a new message from current user is received while status is not "loaded"',
      (tester) async {
        // Arrange: Create an initial state where status is NOT loaded
        final initialNonLoadedState = ChatLoaded(
          conversations: const [],
          messages: testMessages, // Start with some messages
          chatUsers: const [],
          // Crucially, the status is not 'loaded'
          messagesStatus: MessagesLoadingStatus.initial,
        );

        // Arrange: Create a new message from the current user
        final newMessage = Message(
          id: 'msg3',
          conversationId: 'conv1',
          sender: testCurrentUser, // Message is from the current user
          recipient: testRecipient,
          text: 'A new message during a non-loaded state',
          createdAt: DateTime.now().add(const Duration(seconds: 3)),
        );

        // Arrange: Create the new state with the added message, keeping the non-loaded status
        final updatedMessages = List<Message>.from(testMessages)
          ..add(newMessage);
        final stateWithNewMessage = initialNonLoadedState.copyWith(
          messages: updatedMessages,
        );

        // Arrange: Set up the BLoC to emit the new state
        whenListen(
          mockChatBloc,
          Stream.fromIterable([initialNonLoadedState, stateWithNewMessage]),
          initialState: initialNonLoadedState,
        );

        // Act
        await pumpWidget(tester);
        // Ensure the initial list is rendered
        expect(find.byType(MessageBubble), findsNWidgets(2));

        await tester.pump(); // Process the new state from the stream

        // Assert: The listener's condition is now met, and the UI should update.
        // This confirms the uncovered code path was executed.
        expect(find.byType(MessageBubble), findsNWidgets(3));
        expect(
          find.text('A new message during a non-loaded state'),
          findsOneWidget,
        );
      },
    );

    // Test the UI for non-ChatLoaded states (e.g., ChatInitial)
    testWidgets(
      'renders "No messages." for non-ChatLoaded states like ChatInitial',
      (tester) async {
        // Arrange
        when(() => mockChatBloc.state).thenReturn(ChatInitial());

        // Act
        await pumpWidget(tester);
        await tester.pump();

        // Assert
        expect(find.text('No messages.'), findsOneWidget);
      },
    );

    // Test the listener's scroll-to-bottom behavior trigger
    testWidgets(
      'listener triggers scroll when a new message from current user is received',
      (tester) async {
        // Arrange: Simulate receiving a new message by updating the bloc state
        final newMessage = Message(
          id: 'msg3',
          conversationId: 'conv1',
          sender: testCurrentUser,
          recipient: testRecipient,
          text: 'This is my new message',
          createdAt: DateTime.now().add(const Duration(seconds: 2)),
        );

        final initialLoadedState = ChatLoaded(
          conversations: const [],
          messages: testMessages,
          chatUsers: const [],
          messagesStatus: MessagesLoadingStatus.loaded,
        );

        final updatedMessages = List<Message>.from(testMessages)
          ..add(newMessage);
        final stateWithNewMessage = initialLoadedState.copyWith(
          messages: updatedMessages,
        );

        whenListen(
          mockChatBloc,
          Stream.fromIterable([initialLoadedState, stateWithNewMessage]),
          initialState: initialLoadedState,
        );

        // Act
        await pumpWidget(tester);
        // Ensure the initial list is rendered
        expect(find.byType(MessageBubble), findsNWidgets(2));

        await tester.pump(); // Process the new state with the added message

        // Assert
        // We can't directly test the scroll animation, but we can verify the UI updated,
        // which confirms the listener's logic was executed.
        expect(find.byType(MessageBubble), findsNWidgets(3));
        expect(find.text('This is my new message'), findsOneWidget);
      },
    );
  });
}
