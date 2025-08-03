import 'package:equatable/equatable.dart';

abstract class ForgotPasswordEvent extends Equatable {
  const ForgotPasswordEvent();
  @override
  List<Object?> get props => [];
}

class RequestOtpEvent extends ForgotPasswordEvent {
  final String email;
  const RequestOtpEvent({required this.email});
  @override
  List<Object?> get props => [email];
}

class VerifyOtpEvent extends ForgotPasswordEvent {
  final String email;
  final String otp;
  const VerifyOtpEvent({required this.email, required this.otp});
  @override
  List<Object?> get props => [email, otp];
}

class ResetPasswordWithOtpEvent extends ForgotPasswordEvent {
  final String resetToken;
  final String newPassword;
  const ResetPasswordWithOtpEvent({
    required this.resetToken,
    required this.newPassword,
  });
  @override
  List<Object?> get props => [resetToken, newPassword];
}
