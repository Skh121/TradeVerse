import 'package:hive_flutter/adapters.dart';

import 'plan_feature_hive_model.dart';
import 'package:tradeverse/features/payment/domain/entity/payment_plan_entity.dart';

part 'payment_hive_model.g.dart';

@HiveType(typeId: 1)
class PaymentHiveModel extends HiveObject {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final double monthlyPrice;

  @HiveField(2)
  final double yearlyPrice;

  @HiveField(3)
  final double savedAmount;

  @HiveField(4)
  final List<PlanFeatureHiveModel> features;

  PaymentHiveModel({
    required this.name,
    required this.monthlyPrice,
    required this.yearlyPrice,
    required this.savedAmount,
    required this.features,
  });

  factory PaymentHiveModel.fromEntity(PaymentPlanEntity entity) {
    return PaymentHiveModel(
      name: entity.name,
      monthlyPrice: entity.monthlyPrice,
      yearlyPrice: entity.yearlyPrice,
      savedAmount: entity.savedAmount,
      features:
          entity.features
              .map((e) => PlanFeatureHiveModel.fromEntity(e))
              .toList(),
    );
  }

  PaymentPlanEntity toEntity() {
    return PaymentPlanEntity(
      name: name,
      monthlyPrice: monthlyPrice,
      yearlyPrice: yearlyPrice,
      savedAmount: savedAmount,
      features: features.map((e) => e.toEntity()).toList(),
    );
  }
}
