import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart'; // Import for MockBloc
import 'package:tradeverse/app/service_locator/service_locator.dart';
import 'package:tradeverse/features/auth/presentation/view/login_view.dart';
import 'package:tradeverse/features/auth/presentation/view/request_otp_view.dart';
import 'package:tradeverse/features/auth/presentation/view/signup_view.dart';
import 'package:tradeverse/features/auth/presentation/view_model/forgot_password_view_model.dart/forgot_password_event.dart';
import 'package:tradeverse/features/auth/presentation/view_model/forgot_password_view_model.dart/forgot_password_state.dart';
import 'package:tradeverse/features/auth/presentation/view_model/forgot_password_view_model.dart/forgot_password_view_model.dart';
import 'package:tradeverse/features/auth/presentation/view_model/login_view_model/login_event.dart';
import 'package:tradeverse/features/auth/presentation/view_model/login_view_model/login_state.dart';
import 'package:tradeverse/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:tradeverse/features/auth/presentation/view_model/signup_view_model/signup_event.dart';
import 'package:tradeverse/features/auth/presentation/view_model/signup_view_model/signup_state.dart';
import 'package:tradeverse/features/auth/presentation/view_model/signup_view_model/signup_view_model.dart';

// Mocks
class MockLoginViewModel extends MockBloc<LoginEvent, LoginState>
    implements LoginViewModel {}

class MockSignupViewModel extends MockBloc<SignupEvent, SignupState>
    implements SignupViewModel {}

class MockForgotPasswordViewModel
    extends MockBloc<ForgotPasswordEvent, ForgotPasswordState>
    implements ForgotPasswordViewModel {}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

// Fakes
class FakeLoginEvent extends Fake implements LoginEvent {}

class FakeSignupEvent extends Fake implements SignupEvent {}

class FakeForgotPasswordEvent extends Fake implements ForgotPasswordEvent {}

class FakeLoginState extends Fake implements LoginState {}

class FakeSignupState extends Fake implements SignupState {}

class FakeForgotPasswordState extends Fake implements ForgotPasswordState {}

class FakeRoute extends Fake implements Route<dynamic> {}

void main() {
  late MockLoginViewModel mockLoginViewModel;
  late MockSignupViewModel mockSignupViewModel;
  late MockForgotPasswordViewModel mockForgotPasswordViewModel;
  late MockNavigatorObserver mockNavigatorObserver;

  setUpAll(() {
    registerFallbackValue(FakeLoginEvent());
    registerFallbackValue(FakeSignupEvent());
    registerFallbackValue(FakeForgotPasswordEvent());
    registerFallbackValue(FakeLoginState());
    registerFallbackValue(FakeSignupState());
    registerFallbackValue(FakeForgotPasswordState());
    registerFallbackValue(FakeRoute());
  });

  setUp(() {
    mockLoginViewModel = MockLoginViewModel();
    mockSignupViewModel = MockSignupViewModel();
    mockForgotPasswordViewModel = MockForgotPasswordViewModel();
    mockNavigatorObserver = MockNavigatorObserver();

    // Stub the initial states for all view models
    when(() => mockLoginViewModel.state).thenReturn(const LoginState());
    when(() => mockSignupViewModel.state).thenReturn(const SignupState());
    when(
      () => mockForgotPasswordViewModel.state,
    ).thenReturn(ForgotPasswordInitial());

    // Register all necessary mocks in the service locator
    serviceLocator.allowReassignment = true;
    if (!serviceLocator.isRegistered<SignupViewModel>()) {
      serviceLocator.registerSingleton<SignupViewModel>(mockSignupViewModel);
    }
    if (!serviceLocator.isRegistered<ForgotPasswordViewModel>()) {
      serviceLocator.registerSingleton<ForgotPasswordViewModel>(
        mockForgotPasswordViewModel,
      );
    }
  });

  tearDown(() {
    serviceLocator.unregister<SignupViewModel>();
    serviceLocator.unregister<ForgotPasswordViewModel>();
  });

  Future<void> pumpLoginView(WidgetTester tester) async {
    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<LoginViewModel>.value(value: mockLoginViewModel),
          BlocProvider<SignupViewModel>.value(value: mockSignupViewModel),
          BlocProvider<ForgotPasswordViewModel>.value(
            value: mockForgotPasswordViewModel,
          ),
        ],
        child: MaterialApp(
          home: LoginView(),
          navigatorObservers: [mockNavigatorObserver],
        ),
      ),
    );
  }

  group('LoginView', () {
    testWidgets('renders all initial UI elements correctly', (tester) async {
      await pumpLoginView(tester);
      await tester.pumpAndSettle();

      expect(find.text('Welcome back!'), findsOneWidget);
      expect(find.byType(Image), findsNWidgets(2));
      expect(
        find.widgetWithText(TextFormField, 'Enter your email address'),
        findsOneWidget,
      );
      expect(
        find.widgetWithText(TextFormField, 'Enter your password'),
        findsOneWidget,
      );
      expect(find.widgetWithText(ElevatedButton, 'Login Now'), findsOneWidget);

      final forgotPasswordFinder = find.text('Forgot Password?');
      await tester.ensureVisible(forgotPasswordFinder);
      expect(forgotPasswordFinder, findsOneWidget);

      final noAccountFinder = find.text("Don't have an account?");
      await tester.ensureVisible(noAccountFinder);
      expect(noAccountFinder, findsOneWidget);

      final signupFinder = find.text('Signup');
      await tester.ensureVisible(signupFinder);
      expect(signupFinder, findsOneWidget);
    });


    group('Form Validation', () {
      testWidgets('shows error for empty fields on submit', (tester) async {
        await pumpLoginView(tester);
        await tester.tap(find.widgetWithText(ElevatedButton, 'Login Now'));
        await tester.pump();

        expect(find.text('Please enter your email address'), findsOneWidget);
        expect(find.text('Please enter your password'), findsOneWidget);
      });

      testWidgets('shows error for invalid email format', (tester) async {
        await pumpLoginView(tester);
        await tester.enterText(
          find.widgetWithText(TextFormField, 'Enter your email address'),
          'invalid-email',
        );
        await tester.tap(find.widgetWithText(ElevatedButton, 'Login Now'));
        await tester.pump();
        expect(find.text('Please enter a valid email'), findsOneWidget);
      });
    });

    group('Form Submission', () {
      testWidgets('adds LoginSubmitted event when form is valid', (
        tester,
      ) async {
        const email = 'test@example.com';
        const password = 'password123';

        when(
          () => mockLoginViewModel.state,
        ).thenReturn(const LoginState(email: email, password: password));

        await pumpLoginView(tester);

        await tester.enterText(
          find.widgetWithText(TextFormField, 'Enter your email address'),
          email,
        );
        await tester.enterText(
          find.widgetWithText(TextFormField, 'Enter your password'),
          password,
        );
        await tester.pump();

        await tester.tap(find.widgetWithText(ElevatedButton, 'Login Now'));
        await tester.pump();

        final captured =
            verify(
              () => mockLoginViewModel.add(
                captureAny(that: isA<LoginSubmitted>()),
              ),
            ).captured;
        expect(captured.length, 1);
        final event = captured.first as LoginSubmitted;
        expect(event.email, email);
        expect(event.password, password);
      });

      testWidgets('does not add LoginSubmitted event when form is invalid', (
        tester,
      ) async {
        await pumpLoginView(tester);
        await tester.tap(find.widgetWithText(ElevatedButton, 'Login Now'));
        await tester.pump();

        verifyNever(
          () => mockLoginViewModel.add(any(that: isA<LoginSubmitted>())),
        );
      });
    });

    group('Navigation', () {
      testWidgets('tapping "Forgot Password?" navigates to RequestOtpView', (
        tester,
      ) async {
        await pumpLoginView(tester);
        clearInteractions(mockNavigatorObserver);

        final forgotPasswordFinder = find.text('Forgot Password?');
        await tester.ensureVisible(forgotPasswordFinder);
        await tester.tap(forgotPasswordFinder);
        await tester.pumpAndSettle();

        verify(() => mockNavigatorObserver.didPush(any(), any())).called(1);
        expect(find.byType(RequestOtpView), findsOneWidget);
      });

      testWidgets('tapping "Signup" navigates to SignupView', (tester) async {
        await pumpLoginView(tester);
        clearInteractions(mockNavigatorObserver);

        final signupFinder = find.text('Signup');
        await tester.ensureVisible(signupFinder);
        await tester.tap(signupFinder);
        await tester.pumpAndSettle();

        verify(() => mockNavigatorObserver.didPush(any(), any())).called(1);
        expect(find.byType(SignupView), findsOneWidget);
      });
    });
  });
}
