import 'package:equatable/equatable.dart';
import 'user.dart';

class Message extends Equatable {
  final String id;
  final String conversationId;
  final User sender;
  final User?
  recipient; // Recipient can be null for group chats or if not explicitly tracked
  final String? text;
  final String? file; // URL to the file
  final DateTime createdAt;
  final String? tempId;

  const Message({
    required this.id,
    required this.conversationId,
    required this.sender,
    this.recipient,
    this.text,
    this.file,
    required this.createdAt,
    this.tempId
  });

  @override
  List<Object?> get props => [
    id,
    conversationId,
    sender,
    recipient,
    text,
    file,
    createdAt,
    tempId
  ];
}
