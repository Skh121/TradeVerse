// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserApiModel _$UserApiModelFromJson(Map<String, dynamic> json) => UserApiModel(
      idModel: json['_id'] as String,
      fullNameModel: json['fullName'] as String,
      roleModel: json['role'] as String,
    );

Map<String, dynamic> _$UserApiModelToJson(UserApiModel instance) =>
    <String, dynamic>{
      '_id': instance.idModel,
      'fullName': instance.fullNameModel,
      'role': instance.roleModel,
    };
