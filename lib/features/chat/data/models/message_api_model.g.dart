// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageApiModel _$MessageApiModelFromJson(Map<String, dynamic> json) =>
    MessageApiModel(
      idModel: json['_id'] as String,
      conversationIdModel: json['conversationId'] as String,
      senderModel: _userFromJson(json['sender'] as Map<String, dynamic>),
      recipientModel:
          _nullableUserFromJson(json['recipient'] as Map<String, dynamic>?),
      textModel: json['text'] as String?,
      fileModel: json['file'] as String?,
      createdAtModel: DateTime.parse(json['createdAt'] as String),
      tempIdModel: json['tempId'] as String?,
    );

Map<String, dynamic> _$MessageApiModelToJson(MessageApiModel instance) =>
    <String, dynamic>{
      '_id': instance.idModel,
      'conversationId': instance.conversationIdModel,
      'sender': _userToJson(instance.senderModel),
      'recipient': _nullableUserToJson(instance.recipientModel),
      'text': instance.textModel,
      'file': instance.fileModel,
      'createdAt': instance.createdAtModel.toIso8601String(),
      'tempId': instance.tempIdModel,
    };
