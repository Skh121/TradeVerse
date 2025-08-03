import 'package:json_annotation/json_annotation.dart';
import 'package:tradeverse/features/payment/domain/entity/checkout_response_entity.dart';

part 'checkout_response_model.g.dart';

@JsonSerializable()
class CheckoutResponseModel {
  final String? sessionId;

  @JsonKey(name: 'url')
  final String checkoutUrl;

  const CheckoutResponseModel({this.sessionId, required this.checkoutUrl});

  factory CheckoutResponseModel.fromJson(Map<String, dynamic> json) =>
      _$CheckoutResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$CheckoutResponseModelToJson(this);

  CheckoutResponseEntity toEntity() => CheckoutResponseEntity(
    sessionId: sessionId ?? '', 
    checkoutUrl: checkoutUrl,
  );
}
