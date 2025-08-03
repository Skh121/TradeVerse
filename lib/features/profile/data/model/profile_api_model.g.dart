// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubscriptionModel _$SubscriptionModelFromJson(Map<String, dynamic> json) =>
    SubscriptionModel(
      planModel: json['plan'] as String?,
    );

Map<String, dynamic> _$SubscriptionModelToJson(SubscriptionModel instance) =>
    <String, dynamic>{
      'plan': instance.planModel,
    };

UserDetailModel _$UserDetailModelFromJson(Map<String, dynamic> json) =>
    UserDetailModel(
      fullNameModel: json['fullName'] as String,
      emailModel: json['email'] as String,
    );

Map<String, dynamic> _$UserDetailModelToJson(UserDetailModel instance) =>
    <String, dynamic>{
      'fullName': instance.fullNameModel,
      'email': instance.emailModel,
    };

ProfileModel _$ProfileModelFromJson(Map<String, dynamic> json) => ProfileModel(
      idModel: json['_id'] as String?,
      userModel: UserDetailModel.fromJson(json['user'] as Map<String, dynamic>),
      subscriptionModel: _subscriptionFromJson(json['subscription']),
      firstNameModel: json['firstName'] as String,
      lastNameModel: json['lastName'] as String,
      bioModel: json['bio'] as String,
      avatarModel: json['avatar'] as String?,
    );

Map<String, dynamic> _$ProfileModelToJson(ProfileModel instance) =>
    <String, dynamic>{
      '_id': instance.idModel,
      'user': instance.userModel,
      'subscription': instance.subscriptionModel,
      'firstName': instance.firstNameModel,
      'lastName': instance.lastNameModel,
      'bio': instance.bioModel,
      'avatar': instance.avatarModel,
    };
