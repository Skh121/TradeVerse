import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:tradeverse/features/payment/domain/entity/payment_plan_entity.dart';

part 'payment_api_model.g.dart';

@JsonSerializable()
class PaymentApiModel extends Equatable {
  final String name;
  final double monthlyPrice;
  final double yearlyPrice;
  final String savedAmount; 
  final List<String> features; 

  const PaymentApiModel({
    required this.name,
    required this.monthlyPrice,
    required this.yearlyPrice,
    required this.savedAmount,
    required this.features,
  });

  factory PaymentApiModel.fromJson(Map<String, dynamic> json) =>
      _$PaymentApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentApiModelToJson(this);

  PaymentPlanEntity toEntity() {
    return PaymentPlanEntity(
      name: name,
      monthlyPrice: monthlyPrice,
      yearlyPrice: yearlyPrice,
      savedAmount: double.tryParse(savedAmount.replaceAll('%', '')) ?? 0.0,
      features:
          features
              .map(
                (featureText) => PlanFeature(text: featureText, included: true),
              )
              .toList(),
    );
  }

  @override
  List<Object?> get props => [
    name,
    monthlyPrice,
    yearlyPrice,
    savedAmount,
    features,
  ];
}
