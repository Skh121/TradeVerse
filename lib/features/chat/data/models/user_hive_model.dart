import 'package:hive_flutter/hive_flutter.dart';
import 'package:tradeverse/app/constant/hive/hive_table_constant.dart';
import 'package:tradeverse/features/chat/data/models/user_api_model.dart';

part 'user_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.chatUserTableId)
class UserHiveModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String fullName;

  @HiveField(2)
  final String role;

  UserHiveModel({required this.id, required this.fullName, required this.role});

  factory UserHiveModel.fromApiModel(UserApiModel model) {
    return UserHiveModel(
      id: model.id,
      fullName: model.fullName,
      role: model.role,
    );
  }

  UserApiModel toApiModel() {
    return UserApiModel(idModel: id, fullNameModel: fullName, roleModel: role);
  }
}
