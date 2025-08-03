import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:tradeverse/app/use_case/use_case.dart';
import 'package:tradeverse/core/error/failure.dart';
import 'package:tradeverse/features/chat/domain/entity/message.dart';
import 'package:tradeverse/features/chat/domain/repository/chat_repository.dart';

class CreateMessageUseCase
    implements UseCaseWithParams<Message, CreateMessageUseCaseParams> {
  // Updated interface
  final IChatRepository repository;

  CreateMessageUseCase(this.repository);

  @override
  Future<Either<Failure, Message>> call(
    CreateMessageUseCaseParams params,
  ) async {
    return await repository.createMessage(
      conversationId: params.conversationId,
      recipientId: params.recipientId,
      text: params.text,
      filePath: params.filePath,
      tempId: params.tempId, // Pass tempId to the repository
    );
  }
}

class CreateMessageUseCaseParams extends Equatable {
  final String conversationId;
  final String recipientId;
  final String? text;
  final String? filePath;
  final String? tempId;

  const CreateMessageUseCaseParams({
    required this.conversationId,
    required this.recipientId,
    this.text,
    this.filePath,
    this.tempId,
  });

  @override
  List<Object?> get props => [conversationId, recipientId, text, filePath,tempId];
}
