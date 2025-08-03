// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversation_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConversationApiModel _$ConversationApiModelFromJson(
        Map<String, dynamic> json) =>
    ConversationApiModel(
      idModel: json['_id'] as String,
      participantsList: _usersFromJson(json['participants'] as List),
      updatedAtModel: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$ConversationApiModelToJson(
        ConversationApiModel instance) =>
    <String, dynamic>{
      '_id': instance.idModel,
      'participants': _usersToJson(instance.participantsList),
      'updatedAt': instance.updatedAtModel.toIso8601String(),
    };
