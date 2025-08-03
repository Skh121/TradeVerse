import 'package:equatable/equatable.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:tradeverse/app/constant/hive/hive_table_constant.dart';
import 'package:tradeverse/features/auth/domain/entity/user_entity.dart';
import 'package:uuid/uuid.dart';

part 'auth_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.userTableId)
class AuthHiveModel extends Equatable {
  @HiveField(0)
  final String? id;

  @HiveField(1)
  final String email;

  @HiveField(2)
  final String fullName;

  @HiveField(3)
  final String password;

  @HiveField(4)
  final String role;

  @HiveField(5)
  final String token;

  AuthHiveModel({
    String? id,
    required this.email,
    required this.fullName,
    required this.password,
    required this.role,
    required this.token,
  }) : id = id ?? const Uuid().v4();

  factory AuthHiveModel.fromEntity(UserEntity entity) {
    return AuthHiveModel(
      id: entity.id,
      email: entity.email,
      fullName: entity.fullName,
      password: entity.password,
      role: entity.role ?? 'user',
      token: entity.token ?? '',
    );
  }

  UserEntity toEntity() {
    return UserEntity(
      id: id,
      email: email,
      fullName: fullName,
      password: password,
      role: role,
      token: token,
    );
  }

  @override
  List<Object?> get props => [id, email, fullName, password, role, token];
}
