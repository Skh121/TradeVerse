import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:tradeverse/features/notification/data/model/sender_api_model.dart';
import 'package:tradeverse/features/notification/domain/entity/notification_entity.dart';

part 'notification_api_model.g.dart';

@JsonSerializable(explicitToJson: true) // Use explicitToJson for nested models
class NotificationApiModel extends Equatable {
  @JsonKey(name: '_id')
  final String id;
  final String type;
  final String text;
  final String? link;
  final bool isRead;
  final DateTime createdAt;
  final SenderApiModel? sender;

  const NotificationApiModel({
    required this.id,
    required this.type,
    required this.text,
    this.link,
    required this.isRead,
    required this.createdAt,
    this.sender,
  });

  factory NotificationApiModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationApiModelToJson(this);

  // Converts Data layer model to Domain layer entity
  NotificationEntity toEntity() {
    return NotificationEntity(
      id: id,
      type: type,
      text: text,
      link: link,
      isRead: isRead,
      createdAt: createdAt,
      sender: sender?.toEntity(), // Convert nested model to its entity
    );
  }

  // Converts Domain layer entity to Data layer model
  factory NotificationApiModel.fromEntity(NotificationEntity entity) {
    return NotificationApiModel(
      id: entity.id,
      type: entity.type,
      text: entity.text,
      link: entity.link,
      isRead: entity.isRead,
      createdAt: entity.createdAt,
      sender:
          entity.sender != null
              ? SenderApiModel.fromEntity(entity.sender!)
              : null,
    );
  }

  @override
  List<Object?> get props => [id, type, text, link, isRead, createdAt, sender];
}
