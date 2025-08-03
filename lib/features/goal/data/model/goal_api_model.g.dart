// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goal_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GoalApiModel _$GoalApiModelFromJson(Map<String, dynamic> json) => GoalApiModel(
      idModel: json['_id'] as String,
      typeModel: json['type'] as String,
      periodModel: json['period'] as String,
      targetValueModel: (json['targetValue'] as num).toDouble(),
      progressModel: _progressFromJson(json['progress']),
      startDateModel: DateTime.parse(json['startDate'] as String),
      endDateModel: DateTime.parse(json['endDate'] as String),
      achievedModel: json['achieved'] as bool,
      createdAtModel: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAtModel: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$GoalApiModelToJson(GoalApiModel instance) =>
    <String, dynamic>{
      '_id': instance.idModel,
      'type': instance.typeModel,
      'period': instance.periodModel,
      'targetValue': instance.targetValueModel,
      'progress': instance.progressModel,
      'startDate': instance.startDateModel.toIso8601String(),
      'endDate': instance.endDateModel.toIso8601String(),
      'achieved': instance.achievedModel,
      'createdAt': instance.createdAtModel?.toIso8601String(),
      'updatedAt': instance.updatedAtModel?.toIso8601String(),
    };
