import 'package:hive_flutter/hive_flutter.dart';
import 'package:tradeverse/app/constant/hive/hive_table_constant.dart';
import 'package:tradeverse/features/notification/data/model/sender_api_model.dart';

part 'sender_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.senderTableId)
class SenderHiveModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String fullName;

  SenderHiveModel({required this.id, required this.fullName});

  factory SenderHiveModel.fromApiModel(SenderApiModel model) {
    return SenderHiveModel(id: model.id, fullName: model.fullName);
  }

  SenderApiModel toApiModel() {
    return SenderApiModel(id: id, fullName: fullName);
  }
}
