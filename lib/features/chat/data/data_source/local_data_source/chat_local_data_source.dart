import 'package:tradeverse/core/network/hive_service.dart';
import 'package:tradeverse/features/chat/data/data_source/chat_data_source.dart';
import 'package:tradeverse/features/chat/data/models/conversation_api_model.dart';
import 'package:tradeverse/features/chat/data/models/conversation_hive_model.dart';
import 'package:tradeverse/features/chat/data/models/message_api_model.dart';
import 'package:tradeverse/features/chat/data/models/message_hive_model.dart';
import 'package:tradeverse/features/chat/data/models/user_api_model.dart';
import 'package:tradeverse/features/chat/data/models/user_hive_model.dart';
import 'package:tradeverse/features/chat/data/models/find_or_create_conversation_response_api_model.dart';

class ChatLocalDataSource implements IChatDataSource {
  final HiveService _hiveService;

  ChatLocalDataSource({required HiveService hiveService})
    : _hiveService = hiveService;

  // ---------------------------- GET METHODS ----------------------------

  @override
  Future<List<ConversationApiModel>> getConversations() async {
    print('Hive contains ${_hiveService.conversationBox.length} conversations'); // 🔍 Debug
    return _hiveService.conversationBox.values
        .map((e) => e.toApiModel())
        .toList();
  }

  @override
  Future<List<MessageApiModel>> getMessages(String conversationId) async {
    return _hiveService.messageBox.values
        .where((e) => e.conversationId == conversationId)
        .map((e) => e.toApiModel())
        .toList();
  }

  @override
  Future<List<UserApiModel>> getChatUsers() async {
    return _hiveService.chatUserBox.values.map((e) => e.toApiModel()).toList();
  }

  // ---------------------------- CACHE METHODS ----------------------------

  @override
  Future<void> cacheConversations(
    List<ConversationApiModel> conversations,
  ) async {
    await _hiveService.conversationBox.clear();
    for (final conv in conversations) {
      await _hiveService.conversationBox.put(
        conv.id,
        ConversationHiveModel.fromApiModel(conv),
      );
    }
  }

  @override
  Future<void> cacheMessages(
    String conversationId,
    List<MessageApiModel> messages,
  ) async {
    final filtered = messages.where((e) => e.conversationId == conversationId);
    for (final msg in filtered) {
      await _hiveService.messageBox.put(
        msg.id,
        MessageHiveModel.fromApiModel(msg),
      );
    }
  }

  @override
  Future<void> cacheChatUsers(List<UserApiModel> users) async {
    await _hiveService.chatUserBox.clear();
    for (final user in users) {
      await _hiveService.chatUserBox.put(
        user.id,
        UserHiveModel.fromApiModel(user),
      );
    }
  }

  // ---------------------------- REMOTE-ONLY METHODS ----------------------------

  @override
  Future<MessageApiModel> createMessage({
    required String conversationId,
    required String recipientId,
    String? text,
    String? filePath,
    String? tempId,
  }) {
    throw UnimplementedError(
      'Local data source does not support creating messages.',
    );
  }

  @override
  Future<FindOrCreateConversationResponseApiModel> findOrCreateConversation({
    required String recipientId,
  }) {
    throw UnimplementedError(
      'Local data source does not support finding or creating conversations.',
    );
  }

  @override
  void connectSocket() {}

  @override
  void disconnectSocket() {}

  @override
  void joinUserRoom(String userId) {}

  @override
  void joinConversation(String conversationId) {}

  @override
  void sendMessageSocket(Map<String, dynamic> messageData) {}

  @override
  Stream<MessageApiModel> listenForMessages() => const Stream.empty();
}
