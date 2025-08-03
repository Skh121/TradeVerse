import 'package:dartz/dartz.dart';
import 'package:tradeverse/app/use_case/use_case.dart';
import 'package:tradeverse/core/error/failure.dart';
import 'package:tradeverse/features/notification/domain/repository/notification_repository.dart';

class MarkAllAsReadUseCase implements UseCaseWithoutParams<void> {
  final INotificationRepository _repository;

  MarkAllAsReadUseCase(this._repository);

  @override
  Future<Either<Failure, void>> call() async {
    try {
      await _repository.markNotificationsAsRead();
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
