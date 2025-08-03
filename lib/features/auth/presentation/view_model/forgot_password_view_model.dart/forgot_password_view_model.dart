import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradeverse/core/error/failure.dart';
import 'package:tradeverse/features/auth/domain/use_case/request_otp_use_case.dart';
import 'package:tradeverse/features/auth/domain/use_case/reset_password_with_otp_use_case.dart';
import 'package:tradeverse/features/auth/domain/use_case/verify_otp_use_case.dart';
import 'package:tradeverse/features/auth/presentation/view_model/forgot_password_view_model.dart/forgot_password_event.dart';
import 'package:tradeverse/features/auth/presentation/view_model/forgot_password_view_model.dart/forgot_password_state.dart';

class ForgotPasswordViewModel
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  final RequestOtpUsecase requestOtpUsecase; // NEW
  final VerifyOtpUsecase verifyOtpUsecase; // NEW
  final ResetPasswordWithOtpUsecase resetPasswordWithOtpUsecase; // NEW

  ForgotPasswordViewModel({
    required this.requestOtpUsecase, // NEW
    required this.verifyOtpUsecase, // NEW
    required this.resetPasswordWithOtpUsecase, // NEW
  }) : super(ForgotPasswordInitial()) {
    on<RequestOtpEvent>(_onRequestOtp); // NEW handler
    on<VerifyOtpEvent>(_onVerifyOtp); // NEW handler
    on<ResetPasswordWithOtpEvent>(_onResetPasswordWithOtp); // NEW handler
  }

  Future<void> _onRequestOtp(
    RequestOtpEvent event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    emit(ForgotPasswordLoading());
    final result = await requestOtpUsecase(
      RequestOtpParams(email: event.email),
    );
    result.fold(
      (failure) =>
          emit(ForgotPasswordError(message: _mapFailureToMessage(failure))),
      (_) => emit(
        OtpRequestedSuccess(email: event.email),
      ), // Pass email to next state
    );
  }

  Future<void> _onVerifyOtp(
    VerifyOtpEvent event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    emit(ForgotPasswordLoading());
    final result = await verifyOtpUsecase(
      VerifyOtpParams(email: event.email, otp: event.otp),
    );
    result.fold(
      (failure) =>
          emit(ForgotPasswordError(message: _mapFailureToMessage(failure))),
      (resetToken) => emit(
        OtpVerifiedSuccess(resetToken: resetToken),
      ), // Pass resetToken to next state
    );
  }

  Future<void> _onResetPasswordWithOtp(
    ResetPasswordWithOtpEvent event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    emit(ForgotPasswordLoading());
    final result = await resetPasswordWithOtpUsecase(
      ResetPasswordWithOtpParams(
        resetToken: event.resetToken,
        newPassword: event.newPassword,
      ),
    );
    result.fold(
      (failure) =>
          emit(ForgotPasswordError(message: _mapFailureToMessage(failure))),
      (_) => emit(const PasswordResetWithOtpSuccess()),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    if (failure is ServerFailure) {
      return failure.message;
    } else if (failure is ConnectionFailure) {
      return failure.message;
    } else {
      return 'An unexpected error occurred.';
    }
  }
}
