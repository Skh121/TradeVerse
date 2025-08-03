import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:tradeverse/features/auth/domain/entity/user_entity.dart';

part 'user_api_model.g.dart';

@JsonSerializable()
class UserApiModel extends Equatable {
  @JsonKey(name: '_id')
  final String? id;
  final String fullName;
  final String email;
  final String? password;
  final String? token;
  final String? role;

  const UserApiModel({
    this.id,
    required this.fullName,
    required this.email,
    this.password,
    this.token,
    this.role,
  });

  factory UserApiModel.fromJson(Map<String, dynamic> json) {
    return _$UserApiModelFromJson(json);
  }

  Map<String, dynamic> toJson() => _$UserApiModelToJson(this);

  UserEntity toEntity() {
    return UserEntity(
      id: id,

      fullName: fullName,

      email: email,

      token: token,
      role: role,
      password: '',
    );
  }

  factory UserApiModel.fromEntity(UserEntity userEntity) {
    final user = UserApiModel(
      fullName: userEntity.fullName,

      email: userEntity.email,

      password: userEntity.password,
      token: userEntity.token,
      role: userEntity.role,
    );

    return user;
  }

  @override
  List<Object?> get props => [id, fullName, email, password, token, role];
}
