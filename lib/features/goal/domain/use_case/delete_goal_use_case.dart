import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:tradeverse/core/error/failure.dart';
import '../repository/goal_repository.dart';

class DeleteGoalUseCaseParams extends Equatable {
  final String id;

  const DeleteGoalUseCaseParams({required this.id});

  @override
  List<Object> get props => [id];
}

/// Use case for deleting a goal.
class DeleteGoalUseCase {
  final IGoalRepository repository;

  DeleteGoalUseCase(this.repository);

  Future<Either<Failure, String>> call(DeleteGoalUseCaseParams params) async {
    return await repository.deleteGoal(params.id);
  }
}
