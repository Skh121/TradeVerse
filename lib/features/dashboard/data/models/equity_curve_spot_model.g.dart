// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'equity_curve_spot_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EquityCurveSpotModel _$EquityCurveSpotModelFromJson(
        Map<String, dynamic> json) =>
    EquityCurveSpotModel(
      dateName: json['name'] as String,
      value: (json['value'] as num).toDouble(),
    );

Map<String, dynamic> _$EquityCurveSpotModelToJson(
        EquityCurveSpotModel instance) =>
    <String, dynamic>{
      'name': instance.dateName,
      'value': instance.value,
    };
