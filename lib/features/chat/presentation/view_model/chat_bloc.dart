// lib/features/chat/presentation/bloc/chat_bloc.dart
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradeverse/core/error/failure.dart';
import 'package:tradeverse/core/network/socket_service.dart';
import 'package:tradeverse/features/chat/domain/entity/conversation.dart';
import 'package:tradeverse/features/chat/domain/entity/message.dart';
import 'package:tradeverse/features/chat/domain/use_case/create_message_use_case.dart';
import 'package:tradeverse/features/chat/domain/use_case/find_or_create_conversation_use_case.dart';
import 'package:tradeverse/features/chat/domain/use_case/get_chat_users_use_case.dart';
import 'package:tradeverse/features/chat/domain/use_case/get_conversations_use_case.dart';
import 'package:tradeverse/features/chat/domain/use_case/get_messages_use_case.dart';

import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final GetConversationsUseCase getConversations;
  final GetMessagesUseCase getMessages;
  final CreateMessageUseCase createMessage;
  final FindOrCreateConversationUseCase findOrCreateConversation;
  final GetChatUsersUseCase getChatUsers;
  final SocketService socketService; // Direct dependency on SocketService

  StreamSubscription? _messagesSubscription;

  ChatBloc({
    required this.getConversations,
    required this.getMessages,
    required this.createMessage,
    required this.findOrCreateConversation,
    required this.getChatUsers,
    required this.socketService, // Inject SocketService
  }) : super(ChatInitial()) {
    on<LoadConversations>(_onLoadConversations);
    on<LoadMessages>(_onLoadMessages);
    on<SendMessage>(_onSendMessage);
    on<FindOrCreateNewConversation>(_onFindOrCreateNewConversation);
    on<LoadChatUsers>(_onLoadChatUsers);
    on<MessageReceived>(_onMessageReceived);
    on<ConnectSocket>(_onConnectSocket);
    on<DisconnectSocket>(_onDisconnectSocket);
    on<JoinUserRoom>(_onJoinUserRoom);
    on<JoinConversation>(_onJoinConversation);
  }

  Future<void> _onConnectSocket(
    ConnectSocket event,
    Emitter<ChatState> emit,
  ) async {
    socketService.connect();
    // Listen for messages directly from SocketService's stream
    _messagesSubscription?.cancel();
    _messagesSubscription = socketService.listenForMessages().listen(
      (messageApiModel) {
        // Map MessageApiModel to Message entity before adding to bloc
        final message = Message(
          id: messageApiModel.idModel,
          conversationId: messageApiModel.conversationIdModel,
          sender: messageApiModel.senderModel,
          recipient: messageApiModel.recipientModel,
          text: messageApiModel.textModel,
          file: messageApiModel.fileModel,
          createdAt: messageApiModel.createdAtModel,
          tempId: messageApiModel.tempIdModel, // Pass tempId here
        );
        add(MessageReceived(message));
      },
      onError: (error) => debugPrint('Message stream error: $error'),
      onDone: () => debugPrint('Message stream done.'),
    );
    debugPrint('Socket connected and listening for messages.');
  }

  void _onDisconnectSocket(DisconnectSocket event, Emitter<ChatState> emit) {
    socketService.disconnect();
    _messagesSubscription?.cancel();
    debugPrint('Socket disconnected and message stream cancelled.');
  }

  Future<void> _onJoinUserRoom(
    JoinUserRoom event,
    Emitter<ChatState> emit,
  ) async {
    socketService.joinUserRoom(event.userId);
  }

  Future<void> _onJoinConversation(
    JoinConversation event,
    Emitter<ChatState> emit,
  ) async {
    socketService.joinConversation(event.conversationId);
  }

  Future<void> _onLoadConversations(
    LoadConversations event,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatLoading());
    final failureOrConversations =
        await getConversations(); // Call without params
    failureOrConversations.fold(
      (failure) => emit(ChatError(message: _mapFailureToMessage(failure))),
      (conversations) => emit(
        ChatLoaded(
          conversations: conversations,
          messages: const [],
          chatUsers: const [],
        ),
      ),
    );
  }

  Future<void> _onLoadMessages(
    LoadMessages event,
    Emitter<ChatState> emit,
  ) async {
    final currentState = state;
    if (currentState is ChatLoaded) {
      emit(
        currentState.copyWith(messagesStatus: MessagesLoadingStatus.loading),
      );
      final failureOrMessages = await getMessages(
        GetMessagesUseCaseParams(conversationId: event.conversationId),
      );
      failureOrMessages.fold(
        (failure) => emit(
          currentState.copyWith(
            messagesStatus: MessagesLoadingStatus.error,
            errorMessage: _mapFailureToMessage(failure),
          ),
        ),
        (messages) {
          add(
            JoinConversation(conversationId: event.conversationId),
          ); // Use direct socket service via event
          emit(
            currentState.copyWith(
              currentConversationId: event.conversationId,
              messages: messages,
              messagesStatus: MessagesLoadingStatus.loaded,
            ),
          );
        },
      );
    }
  }

  Future<void> _onSendMessage(
    SendMessage event,
    Emitter<ChatState> emit,
  ) async {
    final currentState = state;
    if (currentState is ChatLoaded &&
        currentState.currentConversationId != null) {
      // Generate a temporary client-side ID for optimistic update
      final String tempId = 'temp_${DateTime.now().millisecondsSinceEpoch}';
      final newMessage = Message(
        id: tempId, // Use temp ID
        conversationId: currentState.currentConversationId!,
        sender: event.sender,
        recipient: event.recipient,
        text: event.text,
        file: event.filePath,
        createdAt: DateTime.now(),
        tempId: tempId, // Store tempId in the optimistic message
      );
      final updatedMessages = List<Message>.from(currentState.messages)
        ..add(newMessage);
      emit(currentState.copyWith(messages: updatedMessages));

      // Send message via API (for persistence)
      final failureOrMessage = await createMessage(
        CreateMessageUseCaseParams(
          conversationId: currentState.currentConversationId!,
          recipientId: event.recipient.id,
          text: event.text,
          filePath: event.filePath,
          tempId: tempId, // Pass tempId to the backend via API call
        ),
      );

      failureOrMessage.fold(
        (failure) {
          emit(
            currentState.copyWith(
              errorMessage:
                  'Failed to send message: ${_mapFailureToMessage(failure)}',
            ),
          );
          debugPrint(
            'Failed to send message via API: ${_mapFailureToMessage(failure)}',
          );
          // Optional: Mark the message as failed in UI or remove it
          final failedMessages = List<Message>.from(currentState.messages);
          final index = failedMessages.indexWhere((msg) => msg.id == tempId);
          if (index != -1) {
            // You might want to add a 'status' field to your Message entity
            // and update it to 'failed' here, instead of just removing.
            failedMessages.removeAt(index);
            emit(currentState.copyWith(messages: failedMessages));
          }
        },
        (message) {
          debugPrint('Message sent via API: ${message.text}');
          // The backend will emit the message via socket with its real ID.
          // We rely on the socket listener (_onMessageReceived) to update the UI
          // with the message that has the actual backend ID.
          // No need to update the state here, as _onMessageReceived will handle it.
        },
      );

      // Also send via socket for real-time delivery to other clients
      // This is primarily for other clients, but if the backend echoes,
      // the deduplication logic will handle it.
      socketService.sendMessage({
        'conversationId': currentState.currentConversationId,
        'sender': event.sender.id,
        'recipient': event.recipient.id,
        'text': event.text,
        'file': event.filePath,
        // Include the temporary ID so the backend can potentially echo it back
        // or for more advanced client-side deduplication.
        'tempId': tempId,
      });
    }
  }

  void _onMessageReceived(MessageReceived event, Emitter<ChatState> emit) {
    final currentState = state;
    debugPrint('--- MessageReceived Event Debug ---');
    debugPrint('Current State Type: ${currentState.runtimeType}');
    if (currentState is ChatLoaded) {
      debugPrint(
        'Current Conversation ID in Bloc: ${currentState.currentConversationId}',
      );
      debugPrint(
        'Incoming Message Conversation ID: ${event.message.conversationId}',
      );

      // Check if the message is for the currently active conversation
      if (currentState.currentConversationId == event.message.conversationId) {
        final List<Message> currentMessages = List.from(currentState.messages);

        // Deduplication logic:
        // Try to find a message that matches either the real backend ID OR the temporary ID.
        // The incoming message (event.message) should have the real backend ID and potentially the tempId.
        int existingMessageIndex = -1;

        // 1. Try to match by the real backend ID first (most reliable)
        if (event.message.id != null &&
            !event.message.id!.startsWith('temp_')) {
          existingMessageIndex = currentMessages.indexWhere(
            (msg) => msg.id == event.message.id,
          );
        }

        // 2. If no match by real ID, try to match by tempId (if the incoming message has one)
        if (existingMessageIndex == -1 && event.message.tempId != null) {
          existingMessageIndex = currentMessages.indexWhere(
            (msg) => msg.tempId == event.message.tempId,
          ); // Corrected this line
        }

        if (existingMessageIndex != -1) {
          // If message exists (e.g., optimistic update), replace it with the real one
          debugPrint(
            'Deduplicating message: Replacing existing message with ID ${currentMessages[existingMessageIndex].id} with incoming message ID ${event.message.id}',
          );
          currentMessages[existingMessageIndex] = event.message;
          emit(currentState.copyWith(messages: currentMessages));
        } else {
          debugPrint('Adding new message with ID: ${event.message.id}');
          final updatedMessages = List<Message>.from(currentState.messages)
            ..add(event.message);
          emit(currentState.copyWith(messages: updatedMessages));
        }
      } else {
        add(const LoadConversations());
      }
    } else {
    }
    debugPrint('--- End MessageReceived Event Debug ---');
  }

  Future<void> _onFindOrCreateNewConversation(
    FindOrCreateNewConversation event,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatLoading());
    final failureOrConversationResult = await findOrCreateConversation(
      FindOrCreateConversationUseCaseParams(recipientId: event.recipientId),
    );
    failureOrConversationResult.fold(
      (failure) => emit(ChatError(message: _mapFailureToMessage(failure))),
      (conversationResultTuple) {
        final Conversation conversation = conversationResultTuple.value1;
        final bool isNewConversation = conversationResultTuple.value2;
        emit(
          ConversationOperationSuccess(
            conversation: conversation,
            isNewConversation: isNewConversation,
          ),
        );
      },
    );
  }

  Future<void> _onLoadChatUsers(
    LoadChatUsers event,
    Emitter<ChatState> emit,
  ) async {
    final currentState = state;
    if (currentState is ChatLoaded) {
      emit(
        currentState.copyWith(chatUsersStatus: ChatUsersLoadingStatus.loading),
      );
      final failureOrUsers = await getChatUsers();
      failureOrUsers.fold(
        (failure) => emit(
          currentState.copyWith(
            chatUsersStatus: ChatUsersLoadingStatus.error,
            errorMessage: _mapFailureToMessage(failure),
          ),
        ),
        (users) => emit(
          currentState.copyWith(
            chatUsers: users,
            chatUsersStatus: ChatUsersLoadingStatus.loaded,
          ),
        ),
      );
    }
  }

  String _mapFailureToMessage(Failure failure) {
    if (failure is ServerFailure) {
      return failure.message;
    } else if (failure is ConnectionFailure) {
      return failure.message;
    } else if (failure is SocketFailure) {
      return failure.message;
    } else if (failure is ApiFailure) {
      return failure.message;
    } else if (failure is UnknownFailure) {
      return failure.message;
    }
    return 'Unexpected error';
  }

  @override
  Future<void> close() {
    _messagesSubscription?.cancel();
    socketService.dispose(); // Dispose the socket service when bloc is closed
    return super.close();
  }
}
