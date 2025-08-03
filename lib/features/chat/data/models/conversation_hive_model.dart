import 'package:hive_flutter/hive_flutter.dart';
import 'package:tradeverse/app/constant/hive/hive_table_constant.dart';
import 'package:tradeverse/features/chat/data/models/conversation_api_model.dart';
import 'package:tradeverse/features/chat/data/models/user_api_model.dart';
import 'package:tradeverse/features/chat/data/models/user_hive_model.dart';

part 'conversation_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.conversationTableId)
class ConversationHiveModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final List<UserHiveModel> participants;

  @HiveField(2)
  final DateTime updatedAt;

  ConversationHiveModel({
    required this.id,
    required this.participants,
    required this.updatedAt,
  });

  factory ConversationHiveModel.fromApiModel(ConversationApiModel model) {
    return ConversationHiveModel(
      id: model.id,
      participants:
          model.participants
              .map((e) => UserHiveModel.fromApiModel(e as UserApiModel))
              .toList(),
      updatedAt: model.updatedAt,
    );
  }

  ConversationApiModel toApiModel() {
    return ConversationApiModel(
      idModel: id,
      participantsList: participants.map((e) => e.toApiModel()).toList(),
      updatedAtModel: updatedAt,
    );
  }
}
