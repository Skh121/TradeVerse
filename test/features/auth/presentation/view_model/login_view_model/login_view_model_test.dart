import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tradeverse/core/error/failure.dart';
import 'package:tradeverse/features/auth/domain/use_case/auth_login_use_case.dart';
import 'package:tradeverse/features/auth/presentation/view_model/login_view_model/login_event.dart';
import 'package:tradeverse/features/auth/presentation/view_model/login_view_model/login_state.dart';
import 'package:tradeverse/features/auth/presentation/view_model/login_view_model/login_view_model.dart';

// Mocks
class MockAuthLoginUsecase extends Mock implements AuthLoginUsecase {}

class FakeBuildContext extends Fake implements BuildContext {
  @override
  bool get mounted => true;
}

void main() {
  late MockAuthLoginUsecase mockAuthLoginUsecase;
  late List<String> snackbarMessages;

  const email = 'test@example.com';
  const password = 'password123';

  void testSnackBar({
    required BuildContext context,
    required String message,
    Color? color,
  }) {
    snackbarMessages.add(message);
  }

  setUpAll(() {
    registerFallbackValue(LoginParams(email: email, password: password));
    registerFallbackValue(FakeBuildContext());
  });

  setUp(() {
    mockAuthLoginUsecase = MockAuthLoginUsecase();
    snackbarMessages = [];
  });

  group('LoginViewModel - Bloc Tests', () {
    test('initial state is correct', () {
      final vm = LoginViewModel(mockAuthLoginUsecase);
      expect(vm.state, const LoginState());
    });

    blocTest<LoginViewModel, LoginState>(
      'emits updated email on LoginEmailChanged',
      build: () => LoginViewModel(mockAuthLoginUsecase),
      act: (bloc) => bloc.add(const LoginEmailChanged(email)),
      expect: () => [const LoginState(email: email)],
    );

    blocTest<LoginViewModel, LoginState>(
      'emits updated password on LoginPasswordChanged',
      build: () => LoginViewModel(mockAuthLoginUsecase),
      act: (bloc) => bloc.add(const LoginPasswordChanged(password)),
      expect: () => [const LoginState(password: password)],
    );

    blocTest<LoginViewModel, LoginState>(
      'LoginSubmitted failure: emits [submitting, failure] and calls snackbar',
      build: () {
        when(() => mockAuthLoginUsecase(any())).thenAnswer(
          (_) async => Left(ApiFailure(message: 'Invalid credentials')),
        );
        return LoginViewModel(mockAuthLoginUsecase, showSnackbar: testSnackBar);
      },
      act: (bloc) {
        bloc.add(const LoginEmailChanged(email));
        bloc.add(const LoginPasswordChanged(password));
        bloc.add(LoginSubmitted(FakeBuildContext(), email, password));
      },
      wait: const Duration(seconds: 1),
      expect:
          () => [
            const LoginState(email: email),
            const LoginState(email: email, password: password),
            const LoginState(
              email: email,
              password: password,
              formStatus: FormStatus.submitting,
              message: 'Submission Under Process',
            ),
            const LoginState(
              email: email,
              password: password,
              formStatus: FormStatus.failure,
              message: 'Login Failed',
            ),
          ],
      verify: (_) {
        verify(() => mockAuthLoginUsecase(any())).called(1);
        expect(snackbarMessages, contains('Login Failed!'));
      },
    );

    blocTest<LoginViewModel, LoginState>(
      'LoginSubmitted success: emits [submitting, success] and calls snackbar',
      build: () {
        when(
          () => mockAuthLoginUsecase(any()),
        ).thenAnswer((_) async => const Right('LoggedIn'));
        return LoginViewModel(mockAuthLoginUsecase, showSnackbar: testSnackBar);
      },
      act: (bloc) {
        bloc.add(const LoginEmailChanged(email));
        bloc.add(const LoginPasswordChanged(password));
        bloc.add(LoginSubmitted(FakeBuildContext(), email, password));
      },
      wait: const Duration(seconds: 2),
      expect:
          () => [
            const LoginState(email: email),
            const LoginState(email: email, password: password),
            const LoginState(
              email: email,
              password: password,
              formStatus: FormStatus.submitting,
              message: 'Submission Under Process',
            ),
            const LoginState(
              email: email,
              password: password,
              formStatus: FormStatus.success,
              message: 'Login Successfull',
            ),
          ],
      verify: (_) {
        verify(() => mockAuthLoginUsecase(any())).called(1);
        expect(snackbarMessages, contains('Login Successful!'));
      },
    );
  });
}
