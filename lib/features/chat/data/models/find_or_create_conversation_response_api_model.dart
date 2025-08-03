// lib/features/chat/data/models/find_or_create_conversation_response_api_model.dart
import 'package:json_annotation/json_annotation.dart';
import 'conversation_api_model.dart'; // Import the ConversationApiModel

part 'find_or_create_conversation_response_api_model.g.dart';

@JsonSerializable()
class FindOrCreateConversationResponseApiModel {
  @JsonKey(name: 'conversation')
  final ConversationApiModel conversation;
  @JsonKey(name: 'isNew') // This field MUST be returned by your backend
  final bool isNew;

  const FindOrCreateConversationResponseApiModel({
    required this.conversation,
    required this.isNew,
  });

  factory FindOrCreateConversationResponseApiModel.fromJson(
    Map<String, dynamic> json,
  ) => _$FindOrCreateConversationResponseApiModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$FindOrCreateConversationResponseApiModelToJson(this);
}
