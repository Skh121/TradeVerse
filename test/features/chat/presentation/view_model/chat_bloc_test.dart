import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tradeverse/core/error/failure.dart';
import 'package:tradeverse/core/network/socket_service.dart';
import 'package:tradeverse/features/chat/data/models/message_api_model.dart';
import 'package:tradeverse/features/chat/domain/entity/conversation.dart';
import 'package:tradeverse/features/chat/domain/entity/message.dart';
import 'package:tradeverse/features/chat/domain/entity/user.dart';
import 'package:tradeverse/features/chat/domain/use_case/create_message_use_case.dart';
import 'package:tradeverse/features/chat/domain/use_case/find_or_create_conversation_use_case.dart';
import 'package:tradeverse/features/chat/domain/use_case/get_chat_users_use_case.dart';
import 'package:tradeverse/features/chat/domain/use_case/get_conversations_use_case.dart';
import 'package:tradeverse/features/chat/domain/use_case/get_messages_use_case.dart';
import 'package:tradeverse/features/chat/presentation/view_model/chat_bloc.dart';
import 'package:tradeverse/features/chat/presentation/view_model/chat_event.dart';
import 'package:tradeverse/features/chat/presentation/view_model/chat_state.dart';

// Mocks
class MockGetConversationsUseCase extends Mock
    implements GetConversationsUseCase {}

class MockGetMessagesUseCase extends Mock implements GetMessagesUseCase {}

class MockCreateMessageUseCase extends Mock implements CreateMessageUseCase {}

class CreateMessageUseCaseParamsFake extends Fake
    implements CreateMessageUseCaseParams {}

class GetMessagesUseCaseParamsFake extends Fake
    implements GetMessagesUseCaseParams {}

class FindOrCreateConversationUseCaseParamsFake extends Fake
    implements FindOrCreateConversationUseCaseParams {}

class MockFindOrCreateConversationUseCase extends Mock
    implements FindOrCreateConversationUseCase {}

class MockGetChatUsersUseCase extends Mock implements GetChatUsersUseCase {}

class MockSocketService extends Mock implements SocketService {}

// Helper extension for copyWith for Message entity (since none was provided)
extension MessageCopyWith on Message {
  Message copyWith({
    String? id,
    String? conversationId,
    User? sender,
    User? recipient,
    String? text,
    String? file,
    DateTime? createdAt,
    String? tempId,
  }) {
    return Message(
      id: id ?? this.id,
      conversationId: conversationId ?? this.conversationId,
      sender: sender ?? this.sender,
      recipient: recipient ?? this.recipient,
      text: text ?? this.text,
      file: file ?? this.file,
      createdAt: createdAt ?? this.createdAt,
      tempId: tempId ?? this.tempId,
    );
  }
}

void main() {
  final testUser = User(id: 'user1', fullName: 'Test User', role: 'member');
  final testRecipient = User(
    id: 'user2',
    fullName: 'Recipient User',
    role: 'member',
  );
  final testConversation = Conversation(
    id: 'conv1',
    participants: [testUser, testRecipient],
    updatedAt: DateTime.now(),
  );
  final testMessage = Message(
    id: 'msg1',
    conversationId: 'conv1',
    sender: testUser,
    recipient: testRecipient,
    text: 'Hello',
    file: null,
    createdAt: DateTime.now(),
  );

  late ChatBloc chatBloc;
  late MockGetConversationsUseCase mockGetConversations;
  late MockGetMessagesUseCase mockGetMessages;
  late MockCreateMessageUseCase mockCreateMessage;
  late MockFindOrCreateConversationUseCase mockFindOrCreateConversation;
  late MockGetChatUsersUseCase mockGetChatUsers;
  late MockSocketService mockSocketService;

  setUpAll(() {
    registerFallbackValue(GetMessagesUseCaseParamsFake());
    registerFallbackValue(CreateMessageUseCaseParamsFake());
    registerFallbackValue(FindOrCreateConversationUseCaseParamsFake());
  });

  setUp(() {
    mockGetConversations = MockGetConversationsUseCase();
    mockGetMessages = MockGetMessagesUseCase();
    mockCreateMessage = MockCreateMessageUseCase();
    mockFindOrCreateConversation = MockFindOrCreateConversationUseCase();
    mockGetChatUsers = MockGetChatUsersUseCase();
    mockSocketService = MockSocketService();

    // Now testMessage is already declared here, no problem
    when(
      () => mockCreateMessage(any()),
    ).thenAnswer((_) async => Right(testMessage));

    chatBloc = ChatBloc(
      getConversations: mockGetConversations,
      getMessages: mockGetMessages,
      createMessage: mockCreateMessage,
      findOrCreateConversation: mockFindOrCreateConversation,
      getChatUsers: mockGetChatUsers,
      socketService: mockSocketService,
    );
  });

  tearDown(() {
    chatBloc.close();
  });

  // Create corresponding MessageApiModel for socket stream tests
  final testMessageApiModel = MessageApiModel(
    idModel: testMessage.id,
    conversationIdModel: testMessage.conversationId,
    senderModel: testMessage.sender,
    recipientModel: testMessage.recipient,
    textModel: testMessage.text,
    fileModel: testMessage.file,
    createdAtModel: testMessage.createdAt,
    tempIdModel: testMessage.tempId,
  );

  // ... All your group tests below remain unchanged ...

  group('LoadConversations', () {
    blocTest<ChatBloc, ChatState>(
      'emits [ChatLoading, ChatLoaded] when getConversations succeeds',
      build: () {
        when(
          () => mockGetConversations(),
        ).thenAnswer((_) async => Right([testConversation]));
        return chatBloc;
      },
      act: (bloc) => bloc.add(const LoadConversations()),
      expect:
          () => [
            ChatLoading(),
            ChatLoaded(
              conversations: [testConversation],
              messages: [],
              chatUsers: [],
            ),
          ],
      verify: (_) {
        verify(() => mockGetConversations()).called(1);
      },
    );

    blocTest<ChatBloc, ChatState>(
      'emits [ChatLoading, ChatError] when getConversations fails',
      build: () {
        when(
          () => mockGetConversations(),
        ).thenAnswer((_) async => Left(ServerFailure(message: 'Server error')));
        return chatBloc;
      },
      act: (bloc) => bloc.add(const LoadConversations()),
      expect: () => [ChatLoading(), ChatError(message: 'Server error')],
    );
  });

  group('LoadMessages', () {
    blocTest<ChatBloc, ChatState>(
      'emits loading then loaded with messages on success',
      build: () {
        when(
          () => mockGetMessages(any()),
        ).thenAnswer((_) async => Right([testMessage]));
        when(() => mockSocketService.joinConversation(any())).thenReturn(null);
        return chatBloc;
      },
      seed:
          () => ChatLoaded(
            conversations: [testConversation],
            messages: [],
            chatUsers: [],
          ),
      act: (bloc) => bloc.add(const LoadMessages(conversationId: 'conv1')),
      expect:
          () => [
            isA<ChatLoaded>().having(
              (s) => s.messagesStatus,
              'messagesStatus',
              MessagesLoadingStatus.loading,
            ),
            isA<ChatLoaded>()
                .having(
                  (s) => s.messagesStatus,
                  'messagesStatus',
                  MessagesLoadingStatus.loaded,
                )
                .having((s) => s.messages.length, 'messages length', 1)
                .having(
                  (s) => s.currentConversationId,
                  'currentConversationId',
                  'conv1',
                ),
          ],
      verify: (_) {
        verify(
          () => mockGetMessages(
            GetMessagesUseCaseParams(conversationId: 'conv1'),
          ),
        ).called(1);
        verify(() => mockSocketService.joinConversation('conv1')).called(1);
      },
    );

    blocTest<ChatBloc, ChatState>(
      'emits loading then error when getMessages fails',
      build: () {
        when(
          () => mockGetMessages(any()),
        ).thenAnswer((_) async => Left(ServerFailure(message: 'Server error')));
        return chatBloc;
      },
      seed:
          () => ChatLoaded(
            conversations: [testConversation],
            messages: [],
            chatUsers: [],
          ),
      act: (bloc) => bloc.add(const LoadMessages(conversationId: 'conv1')),
      expect:
          () => [
            isA<ChatLoaded>().having(
              (s) => s.messagesStatus,
              'messagesStatus',
              MessagesLoadingStatus.loading,
            ),
            isA<ChatLoaded>()
                .having(
                  (s) => s.messagesStatus,
                  'messagesStatus',
                  MessagesLoadingStatus.error,
                )
                .having((s) => s.errorMessage, 'errorMessage', 'Server error'),
          ],
    );
  });

  group('SendMessage', () {
    blocTest<ChatBloc, ChatState>(
      'adds optimistic message and sends API and socket message',
      build: () {
        // Override to succeed in this test explicitly (optional, since default stub exists)
        when(
          () => mockCreateMessage(any()),
        ).thenAnswer((_) async => Right(testMessage));
        when(() => mockSocketService.sendMessage(any())).thenReturn(null);
        return chatBloc;
      },
      seed:
          () => ChatLoaded(
            conversations: [testConversation],
            messages: [],
            chatUsers: [],
            currentConversationId: 'conv1',
          ),
      act:
          (bloc) => bloc.add(
            SendMessage(
              sender: testUser,
              recipient: testRecipient,
              text: 'Hello',
            ),
          ),
      expect:
          () => [
            isA<ChatLoaded>().having(
              (s) => s.messages.length,
              'messages length',
              1,
            ),
          ],
      verify: (_) {
        verify(() => mockCreateMessage(any())).called(1);
        verify(() => mockSocketService.sendMessage(any())).called(1);
      },
    );

    blocTest<ChatBloc, ChatState>(
      'removes optimistic message on API failure',
      build: () {
        when(() => mockCreateMessage(any())).thenAnswer(
          (_) async => Left(ServerFailure(message: 'Failed to send')),
        );
        when(() => mockSocketService.sendMessage(any())).thenReturn(null);
        return chatBloc;
      },
      seed:
          () => ChatLoaded(
            conversations: [testConversation],
            messages: [],
            chatUsers: [],
            currentConversationId: 'conv1',
          ),
      act:
          (bloc) => bloc.add(
            SendMessage(
              sender: testUser,
              recipient: testRecipient,
              text: 'Hello',
            ),
          ),
      expect:
          () => [
            isA<ChatLoaded>().having(
              (s) => s.messages.length,
              'messages length',
              1,
            ),
            isA<ChatLoaded>()
                .having((s) => s.messages.length, 'messages length', 0)
                .having(
                  (s) => s.errorMessage,
                  'errorMessage',
                  contains('Failed to send message'),
                ),
          ],
    );
  });

  group('MessageReceived', () {
    blocTest<ChatBloc, ChatState>(
      'adds new message if conversation matches and message is new',
      build: () => chatBloc,
      seed:
          () => ChatLoaded(
            conversations: [testConversation],
            messages: [],
            chatUsers: [],
            currentConversationId: 'conv1',
          ),
      act: (bloc) => bloc.add(MessageReceived(testMessage)),
      expect:
          () => [
            isA<ChatLoaded>().having(
              (s) => s.messages.length,
              'messages length',
              1,
            ),
          ],
    );

    blocTest<ChatBloc, ChatState>(
      'replaces optimistic message with real message if tempId matches',
      build: () => chatBloc,
      seed:
          () => ChatLoaded(
            conversations: [testConversation],
            messages: [
              Message(
                id: 'temp_123',
                conversationId: 'conv1',
                sender: testUser,
                recipient: testRecipient,
                text: 'Hello',
                file: null,
                createdAt: DateTime.now(),
                tempId: 'temp_123',
              ),
            ],
            chatUsers: [],
            currentConversationId: 'conv1',
          ),
      act: (bloc) {
        final realMessage = testMessage.copyWith(tempId: 'temp_123');
        bloc.add(MessageReceived(realMessage));
      },
      expect:
          () => [
            isA<ChatLoaded>().having(
              (s) => s.messages.first.id,
              'first message id',
              testMessage.id,
            ),
          ],
    );

    blocTest<ChatBloc, ChatState>(
      'reloads conversations if incoming message conversation id differs',
      build: () {
        when(
          () => mockGetConversations(),
        ).thenAnswer((_) async => Right([testConversation]));
        return chatBloc;
      },
      seed:
          () => ChatLoaded(
            conversations: [testConversation],
            messages: [],
            chatUsers: [],
            currentConversationId: 'conv1',
          ),
      act:
          (bloc) => bloc.add(
            MessageReceived(
              testMessage.copyWith(conversationId: 'differentConv'),
            ),
          ),
      expect:
          () => [
            ChatLoading(),
            ChatLoaded(
              conversations: [testConversation],
              messages: [],
              chatUsers: [],
            ),
          ],
    );

    blocTest<ChatBloc, ChatState>(
      'does nothing on MessageReceived when state is not ChatLoaded',
      build: () => chatBloc,
      seed: () => ChatInitial(),
      act: (bloc) => bloc.add(MessageReceived(testMessage)),
      expect: () => [],
    );
  });

  group('ConnectSocket and DisconnectSocket', () {
    test(
      'calls socketService connect and listenForMessages on ConnectSocket',
      () async {
        when(() => mockSocketService.connect()).thenReturn(null);
        when(
          () => mockSocketService.listenForMessages(),
        ).thenAnswer((_) => const Stream.empty());

        chatBloc.add(const ConnectSocket());
        await untilCalled(() => mockSocketService.connect());
        verify(() => mockSocketService.connect()).called(1);
        verify(() => mockSocketService.listenForMessages()).called(1);
      },
    );

    test('calls socketService disconnect on DisconnectSocket', () async {
      when(() => mockSocketService.disconnect()).thenReturn(null);

      chatBloc.add(const DisconnectSocket());
      await Future.delayed(Duration.zero);

      verify(() => mockSocketService.disconnect()).called(1);
    });
  });

  group('FindOrCreateNewConversation', () {
    blocTest<ChatBloc, ChatState>(
      'emits ConversationOperationSuccess on success',
      build: () {
        when(
          () => mockFindOrCreateConversation(any()),
        ).thenAnswer((_) async => Right(Tuple2(testConversation, true)));
        return chatBloc;
      },
      act:
          (bloc) =>
              bloc.add(const FindOrCreateNewConversation(recipientId: 'user2')),
      expect:
          () => [
            ChatLoading(),
            ConversationOperationSuccess(
              conversation: testConversation,
              isNewConversation: true,
            ),
          ],
    );

    blocTest<ChatBloc, ChatState>(
      'emits ChatError on failure',
      build: () {
        when(
          () => mockFindOrCreateConversation(any()),
        ).thenAnswer((_) async => Left(ServerFailure(message: 'Error')));
        return chatBloc;
      },
      act:
          (bloc) =>
              bloc.add(const FindOrCreateNewConversation(recipientId: 'user2')),
      expect: () => [ChatLoading(), ChatError(message: 'Error')],
    );
  });

  group('LoadChatUsers', () {
    blocTest<ChatBloc, ChatState>(
      'loads chat users successfully',
      build: () {
        when(
          () => mockGetChatUsers(),
        ).thenAnswer((_) async => Right([testUser]));
        return chatBloc;
      },
      seed: () => ChatLoaded(conversations: [], messages: [], chatUsers: []),
      act: (bloc) => bloc.add(const LoadChatUsers()),
      expect:
          () => [
            isA<ChatLoaded>().having(
              (s) => s.chatUsersStatus,
              'chatUsersStatus',
              ChatUsersLoadingStatus.loading,
            ),
            isA<ChatLoaded>()
                .having(
                  (s) => s.chatUsersStatus,
                  'chatUsersStatus',
                  ChatUsersLoadingStatus.loaded,
                )
                .having((s) => s.chatUsers.length, 'chatUsers length', 1),
          ],
    );

    blocTest<ChatBloc, ChatState>(
      'emits error when loading chat users fails',
      build: () {
        when(
          () => mockGetChatUsers(),
        ).thenAnswer((_) async => Left(ServerFailure(message: 'Failed')));
        return chatBloc;
      },
      seed: () => ChatLoaded(conversations: [], messages: [], chatUsers: []),
      act: (bloc) => bloc.add(const LoadChatUsers()),
      expect:
          () => [
            isA<ChatLoaded>().having(
              (s) => s.chatUsersStatus,
              'chatUsersStatus',
              ChatUsersLoadingStatus.loading,
            ),
            isA<ChatLoaded>()
                .having(
                  (s) => s.chatUsersStatus,
                  'chatUsersStatus',
                  ChatUsersLoadingStatus.error,
                )
                .having((s) => s.errorMessage, 'errorMessage', 'Failed'),
          ],
    );
  });

  test('close cancels subscription and disposes socketService', () async {
    when(() => mockSocketService.dispose()).thenReturn(null);

    when(() => mockSocketService.connect()).thenReturn(null);
    when(
      () => mockSocketService.listenForMessages(),
    ).thenAnswer((_) => const Stream.empty());

    chatBloc.add(const ConnectSocket());
    await untilCalled(() => mockSocketService.connect());

    await chatBloc.close();

    verify(() => mockSocketService.dispose()).called(1);
  });

  group('Socket message stream handling', () {
    test(
      'SocketService emits message triggers MessageReceived event',
      () async {
        final controller = StreamController<MessageApiModel>();

        when(
          () => mockSocketService.listenForMessages(),
        ).thenAnswer((_) => controller.stream);
        when(() => mockSocketService.connect()).thenReturn(null);

        chatBloc.add(const ConnectSocket());
        await untilCalled(() => mockSocketService.connect());

        chatBloc.emit(
          ChatLoaded(
            conversations: [testConversation],
            messages: [],
            chatUsers: [],
            currentConversationId: 'conv1',
          ),
        );

        controller.add(testMessageApiModel);

        await Future.delayed(const Duration(milliseconds: 100));

        expect(chatBloc.state, isA<ChatLoaded>());
        final loadedState = chatBloc.state as ChatLoaded;
        expect(loadedState.messages.length, 1);

        await controller.close();
      },
    );
  });
}
