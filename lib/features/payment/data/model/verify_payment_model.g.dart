// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verify_payment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VerifyPaymentModel _$VerifyPaymentModelFromJson(Map<String, dynamic> json) =>
    VerifyPaymentModel(
      success: json['success'] as bool,
      message: json['message'] as String,
    );

Map<String, dynamic> _$VerifyPaymentModelToJson(VerifyPaymentModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
    };
