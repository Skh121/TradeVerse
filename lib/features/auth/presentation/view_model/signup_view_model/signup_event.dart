import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
 
abstract class SignupEvent extends Equatable {
  const SignupEvent();
 
  @override
  List<Object?> get props => [];
}
 
 class NavigateToLoginEvent extends SignupEvent {
  final BuildContext context;
  const NavigateToLoginEvent({required this.context});
  
 }
class RegisterEmailChanged extends SignupEvent {
  final String email;
  const RegisterEmailChanged(this.email);
 
  @override
  List<Object?> get props => [email];
}
 
class RegisterFullNameChanged extends SignupEvent {
  final String fullName;
  const RegisterFullNameChanged(this.fullName);
 
  @override
  List<Object?> get props => [fullName];
}
 
class RegisterPasswordChanged extends SignupEvent {
  final String password;
  const RegisterPasswordChanged(this.password);
 
  @override
  List<Object?> get props => [password];
}
 
class OnSubmittedEvent extends SignupEvent {
  final String email;
  final String fullName;
  final String password;
  final BuildContext context;

  const OnSubmittedEvent(this.email, this.fullName, this.password, this.context);

  @override
  List<Object?> get props => [email, fullName, password];
}

 
class FormReset extends SignupEvent {}
 