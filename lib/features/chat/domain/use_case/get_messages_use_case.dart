import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:tradeverse/app/use_case/use_case.dart';
import 'package:tradeverse/core/error/failure.dart';
import 'package:tradeverse/features/chat/domain/entity/message.dart';
import 'package:tradeverse/features/chat/domain/repository/chat_repository.dart';

class GetMessagesUseCase
    implements UseCaseWithParams<List<Message>, GetMessagesUseCaseParams> {
  // Updated interface
  final IChatRepository repository;

  GetMessagesUseCase(this.repository);

  @override
  Future<Either<Failure, List<Message>>> call(GetMessagesUseCaseParams params) async {
    return await repository.getMessages(params.conversationId);
  }
}

class GetMessagesUseCaseParams extends Equatable {
  final String conversationId;

  const GetMessagesUseCaseParams({required this.conversationId});

  @override
  List<Object?> get props => [conversationId];
}

