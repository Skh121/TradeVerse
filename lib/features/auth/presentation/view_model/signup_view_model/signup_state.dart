import 'package:equatable/equatable.dart';

enum EmailFormStatus { initial, submitting, success, failure }
 
class SignupState extends Equatable {
  final String email;
  final String fullName;
  final String password;
  final EmailFormStatus emailFormStatus;
  final String? message;
 
  const SignupState({
    this.email = '',
    this.fullName = '',
    this.password = '',
    this.emailFormStatus = EmailFormStatus.initial,
    this.message
  });
 
  SignupState copyWith({
    String? email,
    String? fullName,
    String? password,
    EmailFormStatus? emailFormStatus,
    String? message
  }) {
    return SignupState(
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      password: password ?? this.password,
      emailFormStatus: emailFormStatus ?? this.emailFormStatus,
      message: message ?? this.message
    );
  }
 
  @override
  List<Object?> get props => [
    email,
    fullName,
    password,
    emailFormStatus,
    message
  ];
}