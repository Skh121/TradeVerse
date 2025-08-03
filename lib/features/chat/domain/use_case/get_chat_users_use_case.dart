import 'package:dartz/dartz.dart';
import 'package:tradeverse/app/use_case/use_case.dart';
import 'package:tradeverse/core/error/failure.dart';
import 'package:tradeverse/features/chat/domain/entity/user.dart';
import 'package:tradeverse/features/chat/domain/repository/chat_repository.dart';

class GetChatUsersUseCase implements UseCaseWithoutParams<List<User>> {
  // Updated interface
  final IChatRepository repository;

  GetChatUsersUseCase(this.repository);

  @override
  Future<Either<Failure, List<User>>> call() async {
    // No params in call
    return await repository.getChatUsers();
  }
}
