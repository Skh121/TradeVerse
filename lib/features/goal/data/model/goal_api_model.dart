// lib/features/goal/data/models/goal_api_model.dart

import 'package:json_annotation/json_annotation.dart';
import '../../domain/entity/goal_entity.dart';

part 'goal_api_model.g.dart';

// Helper function to parse progress, which can be string or num
double _progressFromJson(dynamic json) {
  if (json is String) {
    return double.tryParse(json) ?? 0.0;
  } else if (json is num) {
    return json.toDouble();
  }
  return 0.0;
}

@JsonSerializable()
class GoalApiModel extends GoalEntity {
  @JsonKey(name: '_id')
  final String idModel;

  @JsonKey(name: 'type')
  final String typeModel;

  @JsonKey(name: 'period')
  final String periodModel;

  @JsonKey(name: 'targetValue')
  final double targetValueModel;

  @JsonKey(name: 'progress', fromJson: _progressFromJson)
  final double progressModel;

  @JsonKey(name: 'startDate')
  final DateTime startDateModel;

  @JsonKey(name: 'endDate')
  final DateTime endDateModel;

  @JsonKey(name: 'achieved')
  final bool achievedModel;

  @JsonKey(name: 'createdAt')
  final DateTime? createdAtModel;
  @JsonKey(name: 'updatedAt')
  final DateTime? updatedAtModel;

  const GoalApiModel({
    required this.idModel,
    required this.typeModel,
    required this.periodModel,
    required this.targetValueModel,
    required this.progressModel,
    required this.startDateModel,
    required this.endDateModel,
    required this.achievedModel,
    this.createdAtModel,
    this.updatedAtModel,
  }) : super(
         id: idModel,
         type: typeModel,
         period: periodModel,
         targetValue: targetValueModel,
         progress: progressModel,
         startDate: startDateModel,
         endDate: endDateModel,
         achieved: achievedModel,
         createdAt: createdAtModel,
         updatedAt: updatedAtModel,
       );

  factory GoalApiModel.fromJson(Map<String, dynamic> json) =>
      _$GoalApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$GoalApiModelToJson(this);

  // Convert to GoalEntity (already handled by extension, but can be explicit for clarity)
  GoalEntity toEntity() {
    return GoalEntity(
      id: idModel,
      type: typeModel,
      period: periodModel,
      targetValue: targetValueModel,
      progress: progressModel,
      startDate: startDateModel,
      endDate: endDateModel,
      achieved: achievedModel,
      createdAt: createdAtModel,
      updatedAt: updatedAtModel,
    );
  }
}
