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
  final String password;
 
  const UserApiModel({
    this.id,
    required this.fullName,
    required this.email,
    required this.password,
  });
 
  factory UserApiModel.fromJson(Map<String, dynamic> json) =>
      _$UserApiModelFromJson(json);
 
  Map<String, dynamic> toJson() => _$UserApiModelToJson(this);
 
  UserEntity toEntity() {
    return UserEntity(
      id: id,
 
      fullName: fullName,
 
      email: email,
 
      password: password,
    );
  }
 
  factory UserApiModel.fromEntity(UserEntity userEntity) {
    final user = UserApiModel(
      fullName: userEntity.fullName,
 
      email: userEntity.email,
 
      password: userEntity.password,
    );
 
    return user;
  }
 
  @override
  List<Object?> get props => [id, fullName, email, password];
}
 