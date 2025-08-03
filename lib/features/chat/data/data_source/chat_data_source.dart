import 'package:tradeverse/features/chat/data/models/find_or_create_conversation_response_api_model.dart';

import '../models/conversation_api_model.dart';
import '../models/message_api_model.dart';
import '../models/user_api_model.dart';

abstract class IChatDataSource {
  Future<List<ConversationApiModel>> getConversations();
  Future<List<MessageApiModel>> getMessages(String conversationId);
  Future<MessageApiModel> createMessage({
    required String conversationId,
    required String recipientId,
    String? text,
    String? filePath,
    String? tempId,
  });
  Future<FindOrCreateConversationResponseApiModel> findOrCreateConversation({
    required String recipientId,
  });
  Future<List<UserApiModel>> getChatUsers();
  void connectSocket();
  void disconnectSocket();
  void joinUserRoom(String userId);
  void joinConversation(String conversationId);
  void sendMessageSocket(Map<String, dynamic> messageData);
  Stream<MessageApiModel> listenForMessages();
  Future<void> cacheConversations(List<ConversationApiModel> conversations);
  Future<void> cacheMessages(
    String conversationId,
    List<MessageApiModel> messages,
  );
  Future<void> cacheChatUsers(List<UserApiModel> users);
}
