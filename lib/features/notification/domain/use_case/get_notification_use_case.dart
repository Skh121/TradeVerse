import 'package:dartz/dartz.dart';
import 'package:tradeverse/app/use_case/use_case.dart';
import 'package:tradeverse/core/error/failure.dart';
import 'package:tradeverse/features/notification/domain/entity/notification_entity.dart';
import 'package:tradeverse/features/notification/domain/repository/notification_repository.dart';

class GetNotificationUseCase
    implements UseCaseWithoutParams<List<NotificationEntity>> {
  final INotificationRepository _repository;

  GetNotificationUseCase(this._repository);

  @override
  Future<Either<Failure, List<NotificationEntity>>> call() async {
    try {
      final notifications = await _repository.getNotifications();
      return Right(notifications);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
