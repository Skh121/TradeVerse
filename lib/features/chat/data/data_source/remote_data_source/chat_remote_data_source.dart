import 'package:dio/dio.dart';
import 'package:tradeverse/app/constant/api/api_endpoint.dart';
import 'package:tradeverse/core/error/failure.dart';
import 'package:tradeverse/core/network/api_service.dart';
import 'package:tradeverse/core/network/socket_service.dart';
import 'package:tradeverse/features/chat/data/data_source/chat_data_source.dart';
import 'package:tradeverse/features/chat/data/models/conversation_api_model.dart';
import 'package:tradeverse/features/chat/data/models/find_or_create_conversation_response_api_model.dart';
import 'package:tradeverse/features/chat/data/models/message_api_model.dart';
import 'package:tradeverse/features/chat/data/models/user_api_model.dart';

class ChatRemoteDataSource implements IChatDataSource {
  final ApiService apiService;
  final SocketService socketService;

  ChatRemoteDataSource({
    required this.apiService, // Inject ApiService
    required this.socketService, // Inject SocketService
  });

  @override
  Future<List<ConversationApiModel>> getConversations() async {
    try {
      final response = await apiService.get(ApiEndpoints.conversations);
      final List<dynamic> jsonList = response.data as List<dynamic>;
      return jsonList
          .map(
            (json) =>
                ConversationApiModel.fromJson(json as Map<String, dynamic>),
          )
          .toList();
    } on DioException catch (e) {
      throw ServerFailure(message: e.message ?? 'Failed to load conversations');
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }

  @override
  Future<List<MessageApiModel>> getMessages(String conversationId) async {
    try {
      final response = await apiService.get(
        ApiEndpoints.getMessages(conversationId),
      );
      final List<dynamic> jsonList = response.data as List<dynamic>;
      return jsonList
          .map((json) => MessageApiModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ServerFailure(message: e.message ?? 'Failed to load messages');
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }

  @override
  Future<MessageApiModel> createMessage({
    required String conversationId,
    required String recipientId,
    String? text,
    String? filePath,
    String? tempId,
  }) async {
    try {
      FormData formData = FormData.fromMap({
        'conversationId': conversationId,
        'recipient': recipientId,
        if (text != null) 'text': text,
        if (filePath != null && filePath.isNotEmpty)
          'file': await MultipartFile.fromFile(
            filePath,
            filename: filePath.split('/').last,
          ),
        if (tempId != null) 'tempId': tempId,
      });

      final response = await apiService.post(
        ApiEndpoints.createMessage,
        data: formData,
        options: Options(headers: {'Content-Type': 'multipart/form-data'}),
      );

      return MessageApiModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ServerFailure(message: e.message ?? 'Failed to create message');
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }

  @override
  Future<FindOrCreateConversationResponseApiModel> findOrCreateConversation({
    // Updated return type
    required String recipientId,
  }) async {
    try {
      final response = await apiService.post(
        ApiEndpoints.findOrCreateConversation,
        data: {'recipientId': recipientId},
      );
      // Parse the new response model
      return FindOrCreateConversationResponseApiModel.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throw ServerFailure(
        message: e.message ?? 'Failed to find or create conversation',
      );
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }

  @override
  Future<List<UserApiModel>> getChatUsers() async {
    try {
      final response = await apiService.get(ApiEndpoints.chatUsers);
      final List<dynamic> jsonList = response.data as List<dynamic>;
      return jsonList
          .map((json) => UserApiModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ServerFailure(message: e.message ?? 'Failed to load chat users');
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }

  @override
  void connectSocket() {
    socketService.connect();
  }

  @override
  void disconnectSocket() {
    socketService.disconnect();
  }

  @override
  void joinUserRoom(String userId) {
    socketService.joinUserRoom(userId);
  }

  @override
  void joinConversation(String conversationId) {
    socketService.joinConversation(conversationId);
  }

  @override
  void sendMessageSocket(Map<String, dynamic> messageData) {
    socketService.sendMessage(messageData); // Delegated to SocketService
  }

  @override
  Stream<MessageApiModel> listenForMessages() {
    return socketService.listenForMessages(); // Delegated to SocketService
  }

  @override
  Future<void> cacheConversations(List<ConversationApiModel> _) async {}

  @override
  Future<void> cacheMessages(
    String conversationId,
    List<MessageApiModel> messages,
  ) async {}

  @override
  Future<void> cacheChatUsers(List<UserApiModel> users) async {}
}
