import 'package:json_annotation/json_annotation.dart';
import 'package:tradeverse/features/chat/domain/entity/user.dart';

part 'user_api_model.g.dart'; 

@JsonSerializable()
class UserApiModel extends User {
  // Renamed to UserApiModel
  @JsonKey(name: '_id')
  final String idModel;
  @JsonKey(name: 'fullName')
  final String fullNameModel;
  @JsonKey(name: 'role')
  final String roleModel;

  const UserApiModel({
    required this.idModel,
    required this.fullNameModel,
    required this.roleModel,
  }) : super(id: idModel, fullName: fullNameModel, role: roleModel);

  factory UserApiModel.fromJson(Map<String, dynamic> json) =>
      _$UserApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserApiModelToJson(this);
}
