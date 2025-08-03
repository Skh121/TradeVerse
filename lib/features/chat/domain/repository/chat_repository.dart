import 'package:dartz/dartz.dart';
import 'package:tradeverse/core/error/failure.dart';
import 'package:tradeverse/features/chat/domain/entity/conversation.dart';
import 'package:tradeverse/features/chat/domain/entity/message.dart';
import 'package:tradeverse/features/chat/domain/entity/user.dart';

abstract class IChatRepository {
  Future<Either<Failure, List<Conversation>>> getConversations();
  Future<Either<Failure, List<Message>>> getMessages(String conversationId);
  Future<Either<Failure, Message>> createMessage({
    required String conversationId,
    required String recipientId,
    String? text,
    String? filePath, // Path to local file for upload
    String? tempId,
  });
  Future<Either<Failure, Tuple2<Conversation, bool>>> findOrCreateConversation({
    required String recipientId,
  });
  Future<Either<Failure, List<User>>> getChatUsers();

  // Socket.IO methods are removed from here, as they are now handled directly by SocketService
  // and injected into the Bloc/ViewModel.
}
