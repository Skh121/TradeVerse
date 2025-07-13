import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tradeverse/core/error/failure.dart';
import 'package:tradeverse/features/auth/domain/use_case/auth_register_use_case.dart';
import 'package:tradeverse/features/auth/presentation/view_model/signup_view_model/signup_event.dart';
import 'package:tradeverse/features/auth/presentation/view_model/signup_view_model/signup_state.dart';
import 'package:tradeverse/features/auth/presentation/view_model/signup_view_model/signup_view_model.dart';

class MockAuthRegisterUsecase extends Mock implements AuthRegisterUsecase {}

class FakeBuildContext extends Fake implements BuildContext {}

void main() {
  late MockAuthRegisterUsecase mockAuthRegisterUsecase;
  late List<String> snackbarMessages;

  const email = 'test@example.com';
  const password = 'password123';
  const fullName = 'Test User';

  void testSnackbar({
    required BuildContext context,
    required String message,
    Color? color,
  }) {
    snackbarMessages.add(message);
  }

  setUpAll(() {
    registerFallbackValue(
      AuthRegisterParams(email: email, password: password, fullName: fullName),
    );
    registerFallbackValue(FakeBuildContext());
  });

  setUp(() {
    mockAuthRegisterUsecase = MockAuthRegisterUsecase();
    snackbarMessages = [];
  });

  group('SignupViewModel Tests', () {
    test('Initial state is correct', () {
      final vm = SignupViewModel(mockAuthRegisterUsecase);
      expect(vm.state, SignupState());
    });

    blocTest<SignupViewModel, SignupState>(
      'emits updated email on RegisterEmailChanged',
      build: () => SignupViewModel(mockAuthRegisterUsecase),
      act: (bloc) => bloc.add(const RegisterEmailChanged(email)),
      expect: () => [SignupState(email: email)],
    );

    blocTest<SignupViewModel, SignupState>(
      'emits updated fullName on RegisterFullNameChanged',
      build: () => SignupViewModel(mockAuthRegisterUsecase),
      act: (bloc) => bloc.add(const RegisterFullNameChanged(fullName)),
      expect: () => [SignupState(fullName: fullName)],
    );

    blocTest<SignupViewModel, SignupState>(
      'emits updated password on RegisterPasswordChanged',
      build: () => SignupViewModel(mockAuthRegisterUsecase),
      act: (bloc) => bloc.add(const RegisterPasswordChanged(password)),
      expect: () => [SignupState(password: password)],
    );

    blocTest<SignupViewModel, SignupState>(
      'OnSubmittedEvent success: emits [submitting, success] + snackbar',
      build: () {
        when(
          () => mockAuthRegisterUsecase.call(any()),
        ).thenAnswer((_) async => const Right(null));
        return SignupViewModel(
          mockAuthRegisterUsecase,
          showSnackbar: testSnackbar,
        );
      },
      act:
          (bloc) => bloc.add(
            OnSubmittedEvent(email, fullName, password, FakeBuildContext()),
          ),
      wait: const Duration(seconds: 2),
      expect:
          () => [
            SignupState(emailFormStatus: EmailFormStatus.submitting),
            SignupState(
              emailFormStatus: EmailFormStatus.success,
              message: 'Registration Successful!',
            ),
          ],
      verify: (_) {
        verify(() => mockAuthRegisterUsecase.call(any())).called(1);
        expect(snackbarMessages, contains('Registration Successful!'));
      },
    );

    blocTest<SignupViewModel, SignupState>(
      'OnSubmittedEvent failure: emits [submitting, failure] + snackbar',
      build: () {
        when(() => mockAuthRegisterUsecase.call(any())).thenAnswer(
          (_) async => const Left(ApiFailure(message: 'Email already in use')),
        );
        return SignupViewModel(
          mockAuthRegisterUsecase,
          showSnackbar: testSnackbar,
        );
      },
      act:
          (bloc) => bloc.add(
            OnSubmittedEvent(email, fullName, password, FakeBuildContext()),
          ),
      wait: const Duration(seconds: 2),
      expect:
          () => [
            SignupState(emailFormStatus: EmailFormStatus.submitting),
            SignupState(
              emailFormStatus: EmailFormStatus.failure,
              message: 'Registration Failed!',
            ),
          ],
      verify: (_) {
        verify(() => mockAuthRegisterUsecase.call(any())).called(1);
        expect(snackbarMessages, contains('Registration Failed!'));
      },
    );
  });
}
