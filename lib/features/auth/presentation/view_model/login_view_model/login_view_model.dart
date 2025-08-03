import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradeverse/app/secure_storage/secure_storage_service.dart';
import 'package:tradeverse/core/common/snackbar/my_snackbar.dart';
import 'package:tradeverse/features/auth/domain/use_case/auth_login_use_case.dart';
import 'package:tradeverse/features/auth/presentation/view_model/login_view_model/login_event.dart';
import 'package:tradeverse/features/auth/presentation/view_model/login_view_model/login_state.dart';

class LoginViewModel extends Bloc<LoginEvent, LoginState> {
  final AuthLoginUsecase _authLoginUsecase;
  final void Function({
    required BuildContext context,
    required String message,
    Color? color,
  })
  _showSnackbar;

  LoginViewModel(
    this._authLoginUsecase, {
    void Function({
      required BuildContext context,
      required String message,
      Color? color,
    })?
    showSnackbar,
  }) : _showSnackbar = showSnackbar ?? showMySnackbar,
       super(const LoginState()) {
    on<LoginEmailChanged>(_onEmailChanged);
    on<LoginPasswordChanged>(_onPasswordChanged);
    on<LoginSubmitted>(_onLoginSubmitted);
  }

  void _onEmailChanged(LoginEmailChanged event, Emitter<LoginState> emit) {
    final email = event.email;

    emit(state.copyWith(email: email));
  }

  void _onPasswordChanged(
    LoginPasswordChanged event,
    Emitter<LoginState> emit,
  ) {
    final password = event.password;

    emit(state.copyWith(password: password));
  }

  void _onLoginSubmitted(LoginSubmitted event, Emitter<LoginState> emit) async {
    final email = event.email;
    final password = event.password;

    emit(
      state.copyWith(
        formStatus: FormStatus.submitting,
        message: 'Submission Under Process',
      ),
    );

    final result = await _authLoginUsecase(
      LoginParams(email: email, password: password),
    );

    await result.fold(
      (left) async {
        emit(
          state.copyWith(
            formStatus: FormStatus.failure,
            message: "Login Failed",
            user: null,
          ),
        );

        if (event.context.mounted) {
          _showSnackbar(
            message: 'Login Failed!',
            context: event.context,
            color: Colors.red,
          );
        }
      },
      (userEntity) async {
        final storage = SecureStorageService();
        await storage.saveUserData(
          token: userEntity.token ?? "",
          role: userEntity.role ?? "user",
          id: userEntity.id ?? "",
          fullName: userEntity.fullName,
          email: userEntity.email,
        );

        emit(
          state.copyWith(
            formStatus: FormStatus.success,
            message: "Login Successfull",
            email: email,
            user: userEntity,
          ),
        );

        if (event.context.mounted) {
          _showSnackbar(
            message: 'Login Successfull!',
            context: event.context,
            color: Colors.green,
          );
        }

        await Future.delayed(const Duration(seconds: 1));
      },
    );
  }
}
