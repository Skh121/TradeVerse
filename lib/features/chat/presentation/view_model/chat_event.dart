import 'package:equatable/equatable.dart';
import 'package:tradeverse/features/chat/domain/entity/user.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object?> get props => [];
}

class ConnectSocket extends ChatEvent {
  const ConnectSocket();
}

class DisconnectSocket extends ChatEvent {
  const DisconnectSocket();
}

class JoinUserRoom extends ChatEvent {
  final String userId;
  const JoinUserRoom({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class JoinConversation extends ChatEvent {
  final String conversationId;
  const JoinConversation({required this.conversationId});

  @override
  List<Object?> get props => [conversationId];
}

class LoadConversations extends ChatEvent {
  const LoadConversations();
}

class LoadMessages extends ChatEvent {
  final String conversationId;
  const LoadMessages({required this.conversationId});

  @override
  List<Object?> get props => [conversationId];
}

class SendMessage extends ChatEvent {
  final String? text;
  final String? filePath;
  final User sender;
  final User recipient; // The other participant in the conversation

  const SendMessage({
    this.text,
    this.filePath,
    required this.sender,
    required this.recipient,
  });

  @override
  List<Object?> get props => [text, filePath, sender, recipient];
}

class MessageReceived extends ChatEvent {
  final dynamic message; // Can be Message entity or raw data from socket
  const MessageReceived(this.message);

  @override
  List<Object?> get props => [message];
}

class FindOrCreateNewConversation extends ChatEvent {
  final String recipientId;
  const FindOrCreateNewConversation({required this.recipientId});

  @override
  List<Object?> get props => [recipientId];
}

class LoadChatUsers extends ChatEvent {
  const LoadChatUsers();
}
