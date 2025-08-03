import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String? id;
  final String fullName;
  final String email;
  final String password;
  final String? token;
  final String? role;

  const UserEntity({
    this.id,
    required this.fullName,
    required this.email,
    required this.password,
    this.token,
    this.role,
  });

  @override
  List<Object?> get props => [id, fullName, email, password,token, role];
}
