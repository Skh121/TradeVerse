import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tradeverse/core/error/failure.dart';
import 'package:tradeverse/features/auth/domain/entity/user_entity.dart';
import 'package:tradeverse/features/auth/domain/use_case/auth_login_use_case.dart';
import 'package:tradeverse/features/auth/presentation/view_model/login_view_model/login_event.dart';
import 'package:tradeverse/features/auth/presentation/view_model/login_view_model/login_state.dart';
import 'package:tradeverse/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:dartz/dartz.dart';

// Mocks
class MockAuthLoginUsecase extends Mock implements AuthLoginUsecase {}

class MockBuildContext extends Mock implements BuildContext {}

class FakeLoginParams extends Fake implements LoginParams {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const MethodChannel secureStorageChannel = MethodChannel(
    'plugins.it_nomads.com/flutter_secure_storage',
  );

  setUpAll(() {
    registerFallbackValue(FakeLoginParams());

    // Mock platform channel methods used by FlutterSecureStorage
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(secureStorageChannel, (
          MethodCall methodCall,
        ) async {
          return null; // Simulates success
        });
  });

  late MockAuthLoginUsecase mockAuthLoginUsecase;
  late LoginViewModel loginViewModel;
  late MockBuildContext mockContext;
  late void Function({
    required BuildContext context,
    required String message,
    Color? color,
  })
  mockShowSnackbar;

  const testEmail = 'test@example.com';
  const testPassword = 'password123';

  final testUser = UserEntity(
    id: '1',
    fullName: 'Test User',
    email: testEmail,
    password: testPassword,
    token: 'token123',
    role: 'member',
  );

  setUp(() {
    mockAuthLoginUsecase = MockAuthLoginUsecase();
    mockShowSnackbar =
        ({
          required BuildContext context,
          required String message,
          Color? color,
        }) {};

    mockContext = MockBuildContext();
    when(() => mockContext.mounted).thenReturn(true);

    loginViewModel = LoginViewModel(
      mockAuthLoginUsecase,
      showSnackbar: mockShowSnackbar,
    );
  });

  group('LoginViewModel', () {
    test('initial state is correct', () {
      expect(loginViewModel.state.email, '');
      expect(loginViewModel.state.password, '');
      expect(loginViewModel.state.formStatus, FormStatus.initial);
      expect(loginViewModel.state.message, isNull);
      expect(loginViewModel.state.user, isNull);
    });

    test('emits updated email when LoginEmailChanged event is added', () {
      final email = 'newemail@example.com';

      expectLater(
        loginViewModel.stream,
        emits(loginViewModel.state.copyWith(email: email)),
      );

      loginViewModel.add(LoginEmailChanged(email));
    });

    test('emits updated password when LoginPasswordChanged event is added', () {
      final password = 'newpassword';

      expectLater(
        loginViewModel.stream,
        emits(loginViewModel.state.copyWith(password: password)),
      );

      loginViewModel.add(LoginPasswordChanged(password));
    });

    group('LoginSubmitted', () {
      test(
        'emits submitting and success states, calls showSnackbar on success',
        () async {
          when(
            () => mockAuthLoginUsecase.call(any()),
          ).thenAnswer((_) async => Right(testUser));

          var snackbarCalled = false;
          loginViewModel = LoginViewModel(
            mockAuthLoginUsecase,
            showSnackbar: ({
              required BuildContext context,
              required String message,
              Color? color,
            }) {
              snackbarCalled = true;
              expect(message, 'Login Successfull!');
              expect(color, Colors.green);
            },
          );

          final context = mockContext;

          final future = expectLater(
            loginViewModel.stream,
            emitsInOrder([
              loginViewModel.state.copyWith(
                formStatus: FormStatus.submitting,
                message: 'Submission Under Process',
              ),
              loginViewModel.state.copyWith(
                formStatus: FormStatus.success,
                message: 'Login Successfull',
                email: testEmail,
                user: testUser,
              ),
            ]),
          );

          loginViewModel.add(LoginSubmitted(context, testEmail, testPassword));

          await future;

          expect(snackbarCalled, isTrue);
          verify(
            () => mockAuthLoginUsecase.call(
              LoginParams(email: testEmail, password: testPassword),
            ),
          ).called(1);
        },
      );

      test(
        'emits submitting and failure states, calls showSnackbar on failure',
        () async {
          when(() => mockAuthLoginUsecase.call(any())).thenAnswer(
            (_) async => Left(ServerFailure(message: 'Login Failed')),
          );

          var snackbarCalled = false;
          loginViewModel = LoginViewModel(
            mockAuthLoginUsecase,
            showSnackbar: ({
              required BuildContext context,
              required String message,
              Color? color,
            }) {
              snackbarCalled = true;
              expect(message, 'Login Failed!');
              expect(color, Colors.red);
            },
          );

          final context = mockContext;

          final future = expectLater(
            loginViewModel.stream,
            emitsInOrder([
              loginViewModel.state.copyWith(
                formStatus: FormStatus.submitting,
                message: 'Submission Under Process',
              ),
              loginViewModel.state.copyWith(
                formStatus: FormStatus.failure,
                message: 'Login Failed',
                user: null,
              ),
            ]),
          );

          loginViewModel.add(LoginSubmitted(context, testEmail, testPassword));

          await future;

          expect(snackbarCalled, isTrue);

          verify(
            () => mockAuthLoginUsecase.call(
              LoginParams(email: testEmail, password: testPassword),
            ),
          ).called(1);
        },
      );
    });
  });
}
