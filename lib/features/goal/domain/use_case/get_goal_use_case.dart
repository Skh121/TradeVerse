import 'package:dartz/dartz.dart';
import 'package:tradeverse/core/error/failure.dart';
import '../entity/goal_entity.dart';
import '../repository/goal_repository.dart';

/// Use case for fetching all goals.
class GetGoalsUseCase {
  final IGoalRepository repository;

  GetGoalsUseCase(this.repository);

  Future<Either<Failure, List<GoalEntity>>> call() async {
    return await repository.getGoals();
  }
}
