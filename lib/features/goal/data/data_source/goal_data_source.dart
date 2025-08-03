import 'package:tradeverse/features/goal/domain/entity/goal_entity.dart';

/// Abstract interface for the data source for goal operations.
abstract class IGoalDataSource {
  /// Creates a new goal on the remote API.
  Future<GoalEntity> createGoal({
    required String type,
    required String period,
    required double targetValue,
    required DateTime startDate,
    required DateTime endDate,
  });

  /// Fetches all goals.
  Future<List<GoalEntity>> getGoals();

  /// Deletes a goal by its ID.
  Future<String> deleteGoal(String id);

  /// Caches a list of goals.
  Future<void> cacheGoals(List<GoalEntity> goals);
}
