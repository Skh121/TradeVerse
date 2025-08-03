// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkout_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CheckoutResponseModel _$CheckoutResponseModelFromJson(
        Map<String, dynamic> json) =>
    CheckoutResponseModel(
      sessionId: json['sessionId'] as String?,
      checkoutUrl: json['url'] as String,
    );

Map<String, dynamic> _$CheckoutResponseModelToJson(
        CheckoutResponseModel instance) =>
    <String, dynamic>{
      'sessionId': instance.sessionId,
      'url': instance.checkoutUrl,
    };
