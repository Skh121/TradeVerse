import 'package:hive_flutter/hive_flutter.dart';
import 'package:tradeverse/app/constant/hive/hive_table_constant.dart';
import 'package:tradeverse/features/notification/data/model/notification_api_model.dart';
import 'package:tradeverse/features/notification/data/model/sender_hive_model.dart';

part 'notification_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.notificationTableId)
class NotificationHiveModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String type;

  @HiveField(2)
  String text;

  @HiveField(3)
  String? link;

  @HiveField(4)
  bool isRead;

  @HiveField(5)
  DateTime createdAt;

  @HiveField(6)
  SenderHiveModel? sender;

  NotificationHiveModel({
    required this.id,
    required this.type,
    required this.text,
    this.link,
    required this.isRead,
    required this.createdAt,
    this.sender,
  });

  factory NotificationHiveModel.fromApiModel(NotificationApiModel model) {
    return NotificationHiveModel(
      id: model.id,
      type: model.type,
      text: model.text,
      link: model.link,
      isRead: model.isRead,
      createdAt: model.createdAt,
      sender: model.sender != null ? SenderHiveModel.fromApiModel(model.sender!) : null,
    );
  }

  NotificationApiModel toApiModel() {
    return NotificationApiModel(
      id: id,
      type: type,
      text: text,
      link: link,
      isRead: isRead,
      createdAt: createdAt,
      sender: sender?.toApiModel(),
    );
  }
}
