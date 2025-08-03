import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:tradeverse/core/error/failure.dart';
import '../entity/goal_entity.dart';
import '../repository/goal_repository.dart';

/// Parameters for the [CreateGoalUseCase] use case.
class CreateGoalUseCaseParams extends Equatable {
  final String type;
  final String period;
  final double targetValue;
  final DateTime startDate;
  final DateTime endDate;

  const CreateGoalUseCaseParams({
    required this.type,
    required this.period,
    required this.targetValue,
    required this.startDate,
    required this.endDate,
  });

  @override
  List<Object> get props => [type, period, targetValue, startDate, endDate];
}

/// Use case for creating a new goal.
class CreateGoalUseCase {
  final IGoalRepository repository;

  CreateGoalUseCase(this.repository);

  Future<Either<Failure, GoalEntity>> call(CreateGoalUseCaseParams params) async {
    return await repository.createGoal(
      type: params.type,
      period: params.period,
      targetValue: params.targetValue,
      startDate: params.startDate,
      endDate: params.endDate,
    );
  }
}
