import 'package:dartz/dartz.dart';
import 'package:tradeverse/core/error/failure.dart';
import 'package:tradeverse/core/network/network_info.dart';
import 'package:tradeverse/features/chat/data/data_source/chat_data_source.dart';
import 'package:tradeverse/features/chat/domain/entity/conversation.dart';
import 'package:tradeverse/features/chat/domain/entity/message.dart';
import 'package:tradeverse/features/chat/domain/entity/user.dart';
import 'package:tradeverse/features/chat/domain/repository/chat_repository.dart';

class ChatRepositoryImpl implements IChatRepository {
  final IChatDataSource remoteDataSource;
  final IChatDataSource localDataSource;
  final INetworkInfo networkInfo;

  ChatRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Conversation>>> getConversations() async {
    try {
      final isConnected = await networkInfo.isConnected;
      final result =
          isConnected
              ? await remoteDataSource.getConversations()
              : await localDataSource.getConversations();

      if (isConnected) {
        await localDataSource.cacheConversations(result);
      }

      return Right(
        result.map((model) {
          return Conversation(
            id: model.idModel,
            participants: model.participantsList,
            updatedAt: model.updatedAtModel,
          );
        }).toList(),
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Message>>> getMessages(
    String conversationId,
  ) async {
    try {
      final isConnected = await networkInfo.isConnected;
      final result =
          isConnected
              ? await remoteDataSource.getMessages(conversationId)
              : await localDataSource.getMessages(conversationId);
      if (isConnected) {
        await localDataSource.cacheMessages(conversationId, result);
      }

      return Right(
        result.map((model) {
          return Message(
            id: model.idModel,
            conversationId: model.conversationIdModel,
            sender: model.senderModel,
            recipient: model.recipientModel,
            text: model.textModel,
            file: model.fileModel,
            createdAt: model.createdAtModel,
            tempId: model.tempIdModel,
          );
        }).toList(),
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Message>> createMessage({
    required String conversationId,
    required String recipientId,
    String? text,
    String? filePath,
    String? tempId,
  }) async {
    try {
      final isConnected = await networkInfo.isConnected;
      if (!isConnected) {
        return const Left(
          ConnectionFailure(message: "Cannot send message while offline"),
        );
      }

      final result = await remoteDataSource.createMessage(
        conversationId: conversationId,
        recipientId: recipientId,
        text: text,
        filePath: filePath,
        tempId: tempId,
      );

      return Right(
        Message(
          id: result.idModel,
          conversationId: result.conversationIdModel,
          sender: result.senderModel,
          recipient: result.recipientModel,
          text: result.textModel,
          file: result.fileModel,
          createdAt: result.createdAtModel,
          tempId: result.tempIdModel,
        ),
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Tuple2<Conversation, bool>>> findOrCreateConversation({
    required String recipientId,
  }) async {
    try {
      final isConnected = await networkInfo.isConnected;
      if (!isConnected) {
        return const Left(
          ConnectionFailure(
            message: "Offline – Cannot create or find conversation",
          ),
        );
      }

      final responseModel = await remoteDataSource.findOrCreateConversation(
        recipientId: recipientId,
      );
      final conversation = Conversation(
        id: responseModel.conversation.idModel,
        participants: responseModel.conversation.participantsList,
        updatedAt: responseModel.conversation.updatedAtModel,
      );

      return Right(Tuple2(conversation, responseModel.isNew));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<User>>> getChatUsers() async {
    try {
      final isConnected = await networkInfo.isConnected;
      final result =
          isConnected
              ? await remoteDataSource.getChatUsers()
              : await localDataSource.getChatUsers();

      if (isConnected) {
        await localDataSource.cacheChatUsers(result);
      }

      return Right(
        result.map((model) {
          return User(
            id: model.idModel,
            fullName: model.fullNameModel,
            role: model.roleModel,
          );
        }).toList(),
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
