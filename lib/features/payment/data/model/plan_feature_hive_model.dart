import 'package:hive_flutter/adapters.dart';
import 'package:tradeverse/features/payment/domain/entity/payment_plan_entity.dart';

part 'plan_feature_hive_model.g.dart';

@HiveType(typeId: 2)
class PlanFeatureHiveModel extends HiveObject {
  @HiveField(0)
  final String text;

  @HiveField(1)
  final bool included;

  PlanFeatureHiveModel({required this.text, required this.included});

  factory PlanFeatureHiveModel.fromEntity(PlanFeature entity) =>
      PlanFeatureHiveModel(text: entity.text, included: entity.included);

  PlanFeature toEntity() => PlanFeature(text: text, included: included);
}
