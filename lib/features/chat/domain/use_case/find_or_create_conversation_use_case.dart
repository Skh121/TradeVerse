import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:tradeverse/app/use_case/use_case.dart';
import 'package:tradeverse/core/error/failure.dart';
import 'package:tradeverse/features/chat/domain/entity/conversation.dart';
import 'package:tradeverse/features/chat/domain/repository/chat_repository.dart';

class FindOrCreateConversationUseCase
    implements
        UseCaseWithParams<
          Tuple2<Conversation, bool>,
          FindOrCreateConversationUseCaseParams
        > {
  // Updated interface
  final IChatRepository repository;

  FindOrCreateConversationUseCase(this.repository);

  @override
  Future<Either<Failure, Tuple2<Conversation, bool>>> call(
    FindOrCreateConversationUseCaseParams params,
  ) async {
    return await repository.findOrCreateConversation(
      recipientId: params.recipientId,
    );
  }
}

class FindOrCreateConversationUseCaseParams extends Equatable {
  final String recipientId;

  const FindOrCreateConversationUseCaseParams({required this.recipientId});

  @override
  List<Object?> get props => [recipientId];
}
