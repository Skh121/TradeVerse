import 'package:equatable/equatable.dart';

enum FormStatus {
  initial,
  submitting,
  success,
  failure
}
 
class LoginState extends Equatable {
  final String email;
  final String password;
  final FormStatus formStatus;
  final String? message;
 
  const LoginState({
    this.email = '',
    this.password = '',
    this.formStatus = FormStatus.initial,
    this.message
  });
 
  LoginState copyWith({
    String? email,
    String? password,
    bool? rememberMe,
    bool? obscurePassword,
    FormStatus? formStatus,
    String? message
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      formStatus: formStatus ?? this.formStatus,
      message: message ?? this.message
    );
  }
 
  @override
  List<Object?> get props => [
    email,
    password,
    formStatus,
    message
  ];
}