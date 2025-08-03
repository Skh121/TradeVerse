import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tradeverse/app/constant/hive/hive_table_constant.dart';
import 'package:tradeverse/features/goal/domain/entity/goal_entity.dart';

part 'goal_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.goalTableId)
class GoalHiveModel extends Equatable {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String type;
  @HiveField(2)
  final String period;
  @HiveField(3)
  final double targetValue;
  @HiveField(4)
  final double progress;
  @HiveField(5)
  final DateTime startDate;
  @HiveField(6)
  final DateTime endDate;
  @HiveField(7)
  final bool achieved;
  @HiveField(8)
  final DateTime? createdAt;
  @HiveField(9)
  final DateTime? updatedAt;

  const GoalHiveModel({
    required this.id,
    required this.type,
    required this.period,
    required this.targetValue,
    required this.progress,
    required this.startDate,
    required this.endDate,
    required this.achieved,
    this.createdAt,
    this.updatedAt,
  });

  factory GoalHiveModel.fromEntity(GoalEntity entity) {
    return GoalHiveModel(
      id: entity.id,
      type: entity.type,
      period: entity.period,
      targetValue: entity.targetValue,
      progress: entity.progress,
      startDate: entity.startDate,
      endDate: entity.endDate,
      achieved: entity.achieved,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  GoalEntity toEntity() {
    return GoalEntity(
      id: id,
      type: type,
      period: period,
      targetValue: targetValue,
      progress: progress,
      startDate: startDate,
      endDate: endDate,
      achieved: achieved,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    type,
    period,
    targetValue,
    progress,
    startDate,
    endDate,
    achieved,
    createdAt,
    updatedAt,
  ];
}
