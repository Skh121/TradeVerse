import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object?> get props => [];
}

class LoginEmailChanged extends LoginEvent {
  final String email;

  const LoginEmailChanged(this.email);

  @override
  List<Object?> get props => [email];
}

class LoginPasswordChanged extends LoginEvent {
  final String password;

  const LoginPasswordChanged(this.password);

  @override
  List<Object?> get props => [password];
}

class LoginSubmitted extends LoginEvent {
  final BuildContext context;
  final String email;
  final String password;

  const LoginSubmitted(this.context, this.email, this.password);

  @override
  List<Object?> get props => [context, email, password];
}

class ResetFormStatus extends LoginEvent {}

// class NavigateToSignupEvent extends LoginEvent {
//   final BuildContext context;
//   const NavigateToSignupEvent({required this.context});
// }

// class NavigateToDashboardView extends LoginEvent {
//   final BuildContext context;
//   const NavigateToDashboardView({required this.context});
// }