import 'package:equatable/equatable.dart';
import 'package:tradeverse/features/auth/domain/entity/user_entity.dart'; // Import your UserEntity

enum FormStatus { initial, submitting, success, failure }

class LoginState extends Equatable {
  final String email;
  final String password;
  final FormStatus formStatus;
  final String? message;
  final UserEntity? user; 

  const LoginState({
    this.email = '',
    this.password = '',
    this.formStatus = FormStatus.initial,
    this.message,
    this.user, 
  });

  LoginState copyWith({
    String? email,
    String? password,
    bool? rememberMe,
    bool?
    obscurePassword,
    FormStatus? formStatus,
    String? message,
    UserEntity? user, 
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      formStatus: formStatus ?? this.formStatus,
      message: message,
      user: user ?? this.user,
    );
  }

  @override
  List<Object?> get props => [
    email,
    password,
    formStatus,
    message,
    user,
  ];
}
