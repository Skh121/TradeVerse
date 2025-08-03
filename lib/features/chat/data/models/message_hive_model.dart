import 'package:hive_flutter/hive_flutter.dart';
import 'package:tradeverse/app/constant/hive/hive_table_constant.dart';
import 'package:tradeverse/features/chat/data/models/message_api_model.dart';
import 'package:tradeverse/features/chat/data/models/user_api_model.dart';
import 'package:tradeverse/features/chat/data/models/user_hive_model.dart';

part 'message_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.messageTableId)
class MessageHiveModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String conversationId;

  @HiveField(2)
  final UserHiveModel sender;

  @HiveField(3)
  final UserHiveModel? recipient;

  @HiveField(4)
  final String? text;

  @HiveField(5)
  final String? file;

  @HiveField(6)
  final DateTime createdAt;

  @HiveField(7)
  final String? tempId;

  MessageHiveModel({
    required this.id,
    required this.conversationId,
    required this.sender,
    this.recipient,
    this.text,
    this.file,
    required this.createdAt,
    this.tempId,
  });

  factory MessageHiveModel.fromApiModel(MessageApiModel model) {
    return MessageHiveModel(
      id: model.id,
      conversationId: model.conversationId,
      sender: UserHiveModel.fromApiModel(model.sender as UserApiModel),
      recipient:
          model.recipient != null
              ? UserHiveModel.fromApiModel(model.recipient as UserApiModel)
              : null,
      text: model.text,
      file: model.file,
      createdAt: model.createdAt,
      tempId: model.tempId,
    );
  }

  MessageApiModel toApiModel() {
    return MessageApiModel(
      idModel: id,
      conversationIdModel: conversationId,
      senderModel: sender.toApiModel(),
      recipientModel: recipient?.toApiModel(),
      textModel: text,
      fileModel: file,
      createdAtModel: createdAt,
      tempIdModel: tempId,
    );
  }
}
