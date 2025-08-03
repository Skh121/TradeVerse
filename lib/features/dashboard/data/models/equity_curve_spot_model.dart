import 'package:json_annotation/json_annotation.dart';

part 'equity_curve_spot_model.g.dart';

@JsonSerializable()
class EquityCurveSpotModel {
  @JsonKey(name: 'name')
  final String dateName;

  @JsonKey(name: 'value')
  final double value;

  const EquityCurveSpotModel({required this.dateName, required this.value});

  // Factory constructor to deserialize JSON into an EquityCurveSpotModel instance
  factory EquityCurveSpotModel.fromJson(Map<String, dynamic> json) =>
      _$EquityCurveSpotModelFromJson(json);

  // Method to serialize an EquityCurveSpotModel instance into JSON
  Map<String, dynamic> toJson() => _$EquityCurveSpotModelToJson(this);
}
