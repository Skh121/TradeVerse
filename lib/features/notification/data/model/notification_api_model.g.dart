// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationApiModel _$NotificationApiModelFromJson(
        Map<String, dynamic> json) =>
    NotificationApiModel(
      id: json['_id'] as String,
      type: json['type'] as String,
      text: json['text'] as String,
      link: json['link'] as String?,
      isRead: json['isRead'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      sender: json['sender'] == null
          ? null
          : SenderApiModel.fromJson(json['sender'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$NotificationApiModelToJson(
        NotificationApiModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'type': instance.type,
      'text': instance.text,
      'link': instance.link,
      'isRead': instance.isRead,
      'createdAt': instance.createdAt.toIso8601String(),
      'sender': instance.sender?.toJson(),
    };
