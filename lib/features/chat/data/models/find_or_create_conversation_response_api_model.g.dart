// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'find_or_create_conversation_response_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FindOrCreateConversationResponseApiModel
    _$FindOrCreateConversationResponseApiModelFromJson(
            Map<String, dynamic> json) =>
        FindOrCreateConversationResponseApiModel(
          conversation: ConversationApiModel.fromJson(
              json['conversation'] as Map<String, dynamic>),
          isNew: json['isNew'] as bool,
        );

Map<String, dynamic> _$FindOrCreateConversationResponseApiModelToJson(
        FindOrCreateConversationResponseApiModel instance) =>
    <String, dynamic>{
      'conversation': instance.conversation,
      'isNew': instance.isNew,
    };
