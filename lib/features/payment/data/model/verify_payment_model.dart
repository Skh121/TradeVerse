import 'package:json_annotation/json_annotation.dart';
import 'package:tradeverse/features/payment/domain/entity/verify_payment_entity.dart';

part 'verify_payment_model.g.dart';

@JsonSerializable()
class VerifyPaymentModel {
  final bool success;
  final String message;

  const VerifyPaymentModel({required this.success, required this.message});

  factory VerifyPaymentModel.fromJson(Map<String, dynamic> json) =>
      _$VerifyPaymentModelFromJson(json);

  Map<String, dynamic> toJson() => _$VerifyPaymentModelToJson(this);

  /// Convert to entity
  VerifyPaymentEntity toEntity() =>
      VerifyPaymentEntity(success: success, message: message);
}
