import 'package:equatable/equatable.dart';

abstract class ForgotPasswordState extends Equatable {
  const ForgotPasswordState();
  @override
  List<Object?> get props => [];
}

class ForgotPasswordInitial extends ForgotPasswordState {}

class ForgotPasswordLoading extends ForgotPasswordState {}

class ForgotPasswordError extends ForgotPasswordState {
  final String message;
  const ForgotPasswordError({required this.message});
  @override
  List<Object?> get props => [message];
}

// NEW: Forgot Password States
class OtpRequestedSuccess extends ForgotPasswordState {
  final String email; // Store email to pass to next screen
  final String message;
  const OtpRequestedSuccess({
    required this.email,
    this.message = 'OTP sent to your email.',
  });
  @override
  List<Object?> get props => [email, message];
}

class OtpVerifiedSuccess extends ForgotPasswordState {
  final String resetToken; // Pass this token to the final password reset screen
  final String message;
  const OtpVerifiedSuccess({
    required this.resetToken,
    this.message = 'OTP verified successfully.',
  });
  @override
  List<Object?> get props => [resetToken, message];
}

class PasswordResetWithOtpSuccess extends ForgotPasswordState {
  final String message;
  const PasswordResetWithOtpSuccess({
    this.message = 'Password has been reset successfully.',
  });
  @override
  List<Object?> get props => [message];
}
