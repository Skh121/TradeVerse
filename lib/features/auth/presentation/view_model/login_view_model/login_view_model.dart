import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradeverse/app/service_locator/service_locator.dart';
import 'package:tradeverse/core/common/snackbar/my_snackbar.dart';
import 'package:tradeverse/features/auth/domain/use_case/auth_login_use_case.dart';
import 'package:tradeverse/features/auth/presentation/view/signup_view.dart';
import 'package:tradeverse/features/auth/presentation/view_model/login_view_model/login_event.dart';
import 'package:tradeverse/features/auth/presentation/view_model/login_view_model/login_state.dart';
import 'package:tradeverse/features/auth/presentation/view_model/signup_view_model/signup_view_model.dart';
import 'package:tradeverse/view/dashboard.dart';

class LoginViewModel extends Bloc<LoginEvent, LoginState> {
  final AuthLoginUsecase _authLoginUsecase;
  LoginViewModel(this._authLoginUsecase) : super(LoginState()) {
    on<LoginEmailChanged>(_onEmailChanged);
    on<LoginPasswordChanged>(_onPasswordChanged);
    on<LoginSubmitted>(_onLoginSubmitted);
    on<ResetFormStatus>(_onResetFormStatus);
    on<NavigateToSignupEvent>(_onNavigateToSignup);
    on<NavigateToDashboardView>(_onNavigateToDashboard);
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

    result.fold(
      (left) => {
        emit(
          state.copyWith(
            formStatus: FormStatus.failure,
            message: "Login Failed",
          ),
        ),
        showSnackbar(
          message: 'Login Failed!',
          context: event.context,
          color: Colors.red,
        ),
      },
      (right) async {
        emit(
          state.copyWith(
            formStatus: FormStatus.success,
            message: "Login Successfull",
          ),
        );
        showSnackbar(
          message: 'Login Successful!',
          context: event.context,
          color: Colors.green,
        );
        await Future.delayed(Duration(seconds: 1));
        if (event.context.mounted) {
          add(NavigateToDashboardView(context: event.context));
        }
      },
    );
  }

  void _onNavigateToSignup(
    NavigateToSignupEvent event,
    Emitter<LoginState> emit,
  ) {
    if (event.context.mounted) {
      Navigator.push(
        event.context,
        MaterialPageRoute(
          builder:
              (context) => BlocProvider.value(
                value: serviceLocator<SignupViewModel>(),
                child: SignupView(),
              ),
        ),
      );
    }
  }

  void _onNavigateToDashboard(
    NavigateToDashboardView event,
    Emitter<LoginState> emit,
  ) {
    if (event.context.mounted) {
      Navigator.push(
        event.context,
        MaterialPageRoute(builder: (context) => Dashboard()),
      );
    }
  }

  void _onResetFormStatus(ResetFormStatus event, Emitter<LoginState> emit) {
    emit(state.copyWith(formStatus: FormStatus.initial, message: null));
  }
}
