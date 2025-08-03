// lib/features/goal/domain/repository/goal_repository.dart

import 'package:dartz/dartz.dart'; // For Either
import 'package:tradeverse/core/error/failure.dart';
import '../entity/goal_entity.dart';

/// Abstract interface for the Goal Repository.
/// Defines the contract for goal-related operations.
abstract class IGoalRepository {
  /// Creates a new goal.
  Future<Either<Failure, GoalEntity>> createGoal({
    required String type,
    required String period,
    required double targetValue,
    required DateTime startDate,
    required DateTime endDate,
  });

  /// Fetches all goals for the logged-in user.
  Future<Either<Failure, List<GoalEntity>>> getGoals();

  /// Deletes a goal by its ID.
  Future<Either<Failure, String>> deleteGoal(
    String id,
  ); // Returns a message string on success
}
