import 'package:tradeverse/core/network/hive_service.dart';
import 'package:tradeverse/features/goal/data/data_source/goal_data_source.dart';
import 'package:tradeverse/features/goal/data/model/goal_hive_model.dart';
import 'package:tradeverse/features/goal/domain/entity/goal_entity.dart';

class GoalLocalDataSource implements IGoalDataSource {
  final HiveService _hiveService;

  GoalLocalDataSource(this._hiveService);

  @override
  Future<List<GoalEntity>> getGoals() async {
    final goals = _hiveService.goalBox.values.toList();
    return goals.map((hiveModel) => hiveModel.toEntity()).toList();
  }

  @override
  Future<GoalEntity> createGoal({
    required String type,
    required String period,
    required double targetValue,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    // Local creation is handled by caching from the remote source.
    // This method is primarily for the remote data source.
    throw UnimplementedError(
      'Create goal is not supported directly in local data source.',
    );
  }

  @override
  Future<String> deleteGoal(String id) async {
    if (_hiveService.goalBox.containsKey(id)) {
      await _hiveService.goalBox.delete(id);
      return "Goal deleted locally.";
    } else {
      throw Exception("Goal not found in local cache.");
    }
  }

  @override
  Future<void> cacheGoals(List<GoalEntity> goals) async {
    // Clear existing goals to ensure the cache is always a fresh copy.
    await _hiveService.goalBox.clear();
    // Create a map of Hive models with the goal ID as the key.
    final Map<String, GoalHiveModel> goalMap = {
      for (var goal in goals) goal.id: GoalHiveModel.fromEntity(goal),
    };
    await _hiveService.goalBox.putAll(goalMap);
  }
}
