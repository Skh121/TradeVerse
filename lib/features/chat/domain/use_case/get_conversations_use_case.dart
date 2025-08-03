import 'package:dartz/dartz.dart';
import 'package:tradeverse/app/use_case/use_case.dart';
import 'package:tradeverse/core/error/failure.dart';
import 'package:tradeverse/features/chat/domain/entity/conversation.dart';
import 'package:tradeverse/features/chat/domain/repository/chat_repository.dart';


class GetConversationsUseCase implements UseCaseWithoutParams<List<Conversation>> {
  // Updated interface
  final IChatRepository repository;

  GetConversationsUseCase(this.repository);

  @override
  Future<Either<Failure, List<Conversation>>> call() async {
    // No params in call
    return await repository.getConversations();
  }
}
