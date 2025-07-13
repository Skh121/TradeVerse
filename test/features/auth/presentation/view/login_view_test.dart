import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tradeverse/app/service_locator/service_locator.dart';
import 'package:tradeverse/features/auth/presentation/view/login_view.dart';
import 'package:tradeverse/features/auth/presentation/view/signup_view.dart';
import 'package:tradeverse/features/auth/presentation/view_model/login_view_model/login_event.dart';
import 'package:tradeverse/features/auth/presentation/view_model/login_view_model/login_state.dart';
import 'package:tradeverse/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:tradeverse/features/auth/presentation/view_model/signup_view_model/signup_state.dart';
import 'package:tradeverse/features/auth/presentation/view_model/signup_view_model/signup_view_model.dart';
import 'package:tradeverse/view/dashboard.dart';

// Mocks using mocktail
class MockLoginViewModel extends Mock implements LoginViewModel {}

class MockSignupViewModel extends Mock implements SignupViewModel {}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

// Fake classes for fallback values
class FakeLoginEvent extends Fake implements LoginEvent {}

class FakeLoginState extends Fake implements LoginState {}

class FakeSignupState extends Fake implements SignupState {}

class FakeRoute extends Fake implements Route<dynamic> {}

void main() {
  late LoginViewModel mockLoginViewModel;
  late SignupViewModel mockSignupViewModel;
  late MockNavigatorObserver mockNavigatorObserver;

  // This setup runs once before all tests
  setUpAll(() {
    registerFallbackValue(FakeLoginEvent());
    registerFallbackValue(FakeLoginState());
    registerFallbackValue(FakeSignupState());
    registerFallbackValue(FakeRoute());
  });

  // This setup runs before each individual test
  setUp(() {
    mockLoginViewModel = MockLoginViewModel();
    mockSignupViewModel = MockSignupViewModel();
    mockNavigatorObserver = MockNavigatorObserver();

    // Stub the initial states and streams for both view models
    when(() => mockLoginViewModel.state).thenReturn(const LoginState());
    when(
      () => mockLoginViewModel.stream,
    ).thenAnswer((_) => Stream.fromIterable([]));
    when(() => mockLoginViewModel.close()).thenAnswer((_) async {});

    when(() => mockSignupViewModel.state).thenReturn(const SignupState());
    when(
      () => mockSignupViewModel.stream,
    ).thenAnswer((_) => Stream.fromIterable([]));
    when(() => mockSignupViewModel.close()).thenAnswer((_) async {});

    // Configure the service locator to return our mock instance for the test.
    if (serviceLocator.isRegistered<SignupViewModel>()) {
      serviceLocator.unregister<SignupViewModel>();
    }
    serviceLocator.registerSingleton<SignupViewModel>(mockSignupViewModel);
  });

  // This runs after each test to clean up the service locator
  tearDown(() {
    serviceLocator.unregister<SignupViewModel>();
  });

  // Helper to pump the widget within a MaterialApp and BlocProvider
  Future<void> pumpLoginView(WidgetTester tester) async {
    await tester.pumpWidget(
      BlocProvider<LoginViewModel>.value(
        value: mockLoginViewModel,
        child: MaterialApp(
          home: LoginView(),
          // The Dashboard is a simple placeholder for navigation testing
          routes: {'/dashboard': (context) => const Dashboard()},
          navigatorObservers: [mockNavigatorObserver],
        ),
      ),
    );
  }

  group('LoginView', () {
    testWidgets('renders all initial UI elements correctly', (tester) async {
      await pumpLoginView(tester);

      // Scroll to the bottom to ensure all widgets are visible
      final lastElementFinder = find.text('Signup');
      await tester.ensureVisible(lastElementFinder);
      await tester.pumpAndSettle();

      // Assertions for all visible widgets
      expect(find.text('Welcome back!'), findsOneWidget);
      expect(
        find.byType(Image),
        findsNWidgets(3),
      ); // Background, Logo, Google Logo
      expect(
        find.widgetWithText(TextFormField, 'Enter your email address'),
        findsOneWidget,
      );
      expect(
        find.widgetWithText(TextFormField, 'Enter your password'),
        findsOneWidget,
      );
      expect(find.text('Forgot Password?'), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'Login Now'), findsOneWidget);
      expect(find.text('Signin with google'), findsOneWidget);
      expect(find.text("Don't have an account?"), findsOneWidget);
      expect(lastElementFinder, findsOneWidget);
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
        await pumpLoginView(tester);
        const email = 'test@example.com';
        const password = 'password123';

        // Enter valid data
        await tester.enterText(
          find.widgetWithText(TextFormField, 'Enter your email address'),
          email,
        );
        await tester.enterText(
          find.widgetWithText(TextFormField, 'Enter your password'),
          password,
        );
        await tester.pump();

        // Tap the login button
        await tester.tap(find.widgetWithText(ElevatedButton, 'Login Now'));
        await tester.pump();

        // Verify that the correct event was added
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
    });

    group('Bloc Listener and Navigation', () {
      testWidgets('navigates to Dashboard on successful login', (tester) async {
        // Setup the BLoC to emit a success state when listened to
        whenListen(
          mockLoginViewModel,
          Stream.fromIterable([
            const LoginState(
              formStatus: FormStatus.success,
              message: 'Login Successfull',
            ),
          ]),
          initialState: const LoginState(),
        );

        await pumpLoginView(tester);
        await tester
            .pumpAndSettle(); // Allow listener to process the state and navigate

        // Verify that a replacement navigation occurred
        verify(
          () => mockNavigatorObserver.didReplace(
            newRoute: any(named: 'newRoute'),
            oldRoute: any(named: 'oldRoute'),
          ),
        ).called(1);
        // Verify that the Dashboard is now the visible screen
        expect(find.byType(Dashboard), findsOneWidget);
        expect(find.byType(LoginView), findsNothing);
      });

      // ✅ New test to cover non-successful login states in the BlocListener
      testWidgets('does not navigate when login state is not success', (
        tester,
      ) async {
        // Setup the BLoC to emit a failure state
        whenListen(
          mockLoginViewModel,
          Stream.fromIterable([
            const LoginState(formStatus: FormStatus.failure),
          ]),
          initialState: const LoginState(),
        );

        await pumpLoginView(tester);
        // ✅ FIX: Clear interactions after the initial view is built to ignore the first push.
        clearInteractions(mockNavigatorObserver);

        await tester.pumpAndSettle();

        // Verify that no navigation methods were called on the observer *after* the initial build.
        verifyNever(
          () => mockNavigatorObserver.didReplace(
            newRoute: any(named: 'newRoute'),
            oldRoute: any(named: 'oldRoute'),
          ),
        );
        verifyNever(() => mockNavigatorObserver.didPush(any(), any()));
        // Ensure we are still on the LoginView
        expect(find.byType(LoginView), findsOneWidget);
      });
    });

    // ✅ New test group for other interactions to ensure full coverage
    group('Other Interactions', () {
      testWidgets('tapping "Forgot Password?" does not throw error', (
        tester,
      ) async {
        await pumpLoginView(tester);
        clearInteractions(mockNavigatorObserver);

        final forgotPasswordFinder = find.text('Forgot Password?');
        await tester.ensureVisible(forgotPasswordFinder);
        await tester.tap(forgotPasswordFinder);
        await tester.pumpAndSettle();

        // Verify no navigation occurred and no errors were thrown
        verifyNever(() => mockNavigatorObserver.didPush(any(), any()));
        expect(find.byType(LoginView), findsOneWidget);
      });

      testWidgets('tapping "Signin with google" does not throw error', (
        tester,
      ) async {
        await pumpLoginView(tester);
        clearInteractions(mockNavigatorObserver);

        final googleButtonFinder = find.text('Signin with google');
        await tester.ensureVisible(googleButtonFinder);
        await tester.tap(googleButtonFinder);
        await tester.pumpAndSettle();

        // Verify no navigation occurred and no errors were thrown
        verifyNever(() => mockNavigatorObserver.didPush(any(), any()));
        expect(find.byType(LoginView), findsOneWidget);
      });
    });

    group('Navigation to Signup', () {
      testWidgets('tapping "Signup" navigates to SignupView', (tester) async {
        await pumpLoginView(tester);

        // Clear interactions on the mock observer after the initial build.
        clearInteractions(mockNavigatorObserver);

        final signupLinkFinder = find.text('Signup');

        await tester.ensureVisible(signupLinkFinder);
        await tester.pumpAndSettle();

        await tester.tap(signupLinkFinder);
        await tester.pumpAndSettle();

        // Verify that exactly one push navigation occurred *after* the tap.
        verify(() => mockNavigatorObserver.didPush(any(), any())).called(1);

        // Verify that the SignupView is now on screen
        expect(find.byType(SignupView), findsOneWidget);
      });
    });
  });
}
