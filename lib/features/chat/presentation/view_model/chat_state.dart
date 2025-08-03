import 'package:equatable/equatable.dart';
import 'package:tradeverse/features/chat/domain/entity/conversation.dart';
import 'package:tradeverse/features/chat/domain/entity/message.dart';
import 'package:tradeverse/features/chat/domain/entity/user.dart';

enum MessagesLoadingStatus { initial, loading, loaded, error }

enum ChatUsersLoadingStatus { initial, loading, loaded, error }

abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object?> get props => [];
}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatLoaded extends ChatState {
  final List<Conversation> conversations;
  final List<Message> messages;
  final List<User> chatUsers;
  final String? currentConversationId;
  final MessagesLoadingStatus messagesStatus;
  final ChatUsersLoadingStatus chatUsersStatus;
  final String? errorMessage;

  const ChatLoaded({
    required this.conversations,
    required this.messages,
    required this.chatUsers,
    this.currentConversationId,
    this.messagesStatus = MessagesLoadingStatus.initial,
    this.chatUsersStatus = ChatUsersLoadingStatus.initial,
    this.errorMessage,
  });

  ChatLoaded copyWith({
    List<Conversation>? conversations,
    List<Message>? messages,
    List<User>? chatUsers,
    String? currentConversationId,
    MessagesLoadingStatus? messagesStatus,
    ChatUsersLoadingStatus? chatUsersStatus,
    String? errorMessage,
  }) {
    return ChatLoaded(
      conversations: conversations ?? this.conversations,
      messages: messages ?? this.messages,
      chatUsers: chatUsers ?? this.chatUsers,
      currentConversationId:
          currentConversationId ?? this.currentConversationId,
      messagesStatus: messagesStatus ?? this.messagesStatus,
      chatUsersStatus: chatUsersStatus ?? this.chatUsersStatus,
      errorMessage: errorMessage, // Allow null to clear error
    );
  }

  @override
  List<Object?> get props => [
    conversations,
    messages,
    chatUsers,
    currentConversationId,
    messagesStatus,
    chatUsersStatus,
    errorMessage,
  ];
}

class ChatError extends ChatState {
  final String message;

  const ChatError({required this.message});

  @override
  List<Object?> get props => [message];
}

class ConversationOperationSuccess extends ChatState {
  final Conversation conversation;
  final bool isNewConversation;

  const ConversationOperationSuccess({required this.conversation, required this.isNewConversation});

  @override
  List<Object?> get props => [conversation, isNewConversation];
}
