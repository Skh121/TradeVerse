import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tradeverse/app/service_locator/service_locator.dart';
import 'package:tradeverse/features/auth/presentation/view/login_view.dart';
import 'package:tradeverse/features/auth/presentation/view/signup_view.dart';
import 'package:tradeverse/features/auth/presentation/view_model/login_view_model/login_state.dart';
import 'package:tradeverse/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:tradeverse/features/auth/presentation/view_model/signup_view_model/signup_event.dart';
import 'package:tradeverse/features/auth/presentation/view_model/signup_view_model/signup_state.dart';
import 'package:tradeverse/features/auth/presentation/view_model/signup_view_model/signup_view_model.dart';

// Mocks using mocktail
class MockSignupViewModel extends Mock implements SignupViewModel {}

class MockLoginViewModel extends Mock implements LoginViewModel {}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

// Fake classes for fallback values
class FakeSignupEvent extends Fake implements SignupEvent {}

class FakeLoginState extends Fake implements LoginState {}

class FakeSignupState extends Fake implements SignupState {}

class FakeRoute extends Fake implements Route<dynamic> {}

void main() {
  late SignupViewModel mockSignupViewModel;
  late LoginViewModel mockLoginViewModel;
  late MockNavigatorObserver mockNavigatorObserver;

  // This setup runs once before all tests
  setUpAll(() {
    registerFallbackValue(FakeSignupEvent());
    registerFallbackValue(FakeSignupState());
    registerFallbackValue(FakeLoginState());
    registerFallbackValue(FakeRoute());
  });

  // This setup runs before each individual test
  setUp(() {
    mockSignupViewModel = MockSignupViewModel();
    mockLoginViewModel = MockLoginViewModel();
    mockNavigatorObserver = MockNavigatorObserver();

    // Stub the initial states and streams for both view models
    when(() => mockSignupViewModel.state).thenReturn(const SignupState());
    when(
      () => mockSignupViewModel.stream,
    ).thenAnswer((_) => Stream.fromIterable([]));
    when(() => mockSignupViewModel.close()).thenAnswer((_) async {});

    when(() => mockLoginViewModel.state).thenReturn(const LoginState());
    when(
      () => mockLoginViewModel.stream,
    ).thenAnswer((_) => Stream.fromIterable([]));
    when(() => mockLoginViewModel.close()).thenAnswer((_) async {});

    // Configure the service locator to return our mock instance for the test.
    if (serviceLocator.isRegistered<LoginViewModel>()) {
      serviceLocator.unregister<LoginViewModel>();
    }
    serviceLocator.registerSingleton<LoginViewModel>(mockLoginViewModel);
  });

  // This runs after each test to clean up the service locator
  tearDown(() {
    serviceLocator.unregister<LoginViewModel>();
  });

  // Helper to pump the widget within a MaterialApp and BlocProvider
  Future<void> pumpSignupView(WidgetTester tester) async {
    await tester.pumpWidget(
      BlocProvider<SignupViewModel>.value(
        value: mockSignupViewModel,
        child: MaterialApp(
          home: SignupView(),
          navigatorObservers: [mockNavigatorObserver],
        ),
      ),
    );
  }

  group('SignupView', () {
    testWidgets('renders all initial UI elements correctly', (tester) async {
      await pumpSignupView(tester);

      // ✅ FIX: Changed finder to ' Signin' with a leading space to match the source code.
      final lastElementFinder = find.text('Signin');
      await tester.ensureVisible(lastElementFinder);
      await tester.pumpAndSettle();

      // Assertions for all visible widgets
      expect(find.text('Welcome!'), findsOneWidget);
      expect(
        find.byType(Image),
        findsNWidgets(3),
      ); // Background, Logo, Google Logo
      expect(
        find.widgetWithText(TextFormField, 'Enter your Full Name'),
        findsOneWidget,
      );
      expect(
        find.widgetWithText(TextFormField, 'Enter your Email Address'),
        findsOneWidget,
      );
      expect(
        find.widgetWithText(TextFormField, 'Enter your Password'),
        findsOneWidget,
      );
      expect(
        find.widgetWithText(ElevatedButton, 'Sign Up Now'),
        findsOneWidget,
      );
      expect(find.text('Signin with google'), findsOneWidget);

      // ✅ FIX: Use a more robust predicate that inspects the TextSpan children directly.
      expect(
        find.byWidgetPredicate((widget) {
          if (widget is RichText) {
            final span = widget.text as TextSpan;
            if (span.children == null) return false;
            // Check if any of the children is a TextSpan with the expected text.
            return span.children!.any(
              (inlineSpan) =>
                  inlineSpan is TextSpan &&
                  inlineSpan.text == 'Already have an account?',
            );
          }
          return false;
        }),
        findsOneWidget,
      );

      expect(lastElementFinder, findsOneWidget);
    });

    group('Form Input Handling', () {
      testWidgets('entering full name adds RegisterFullNameChanged event', (
        tester,
      ) async {
        await pumpSignupView(tester);
        await tester.enterText(
          find.widgetWithText(TextFormField, 'Enter your Full Name'),
          'test',
        );
        verify(
          () => mockSignupViewModel.add(const RegisterFullNameChanged('test')),
        ).called(1);
      });

      testWidgets('entering email adds RegisterEmailChanged event', (
        tester,
      ) async {
        await pumpSignupView(tester);
        await tester.enterText(
          find.widgetWithText(TextFormField, 'Enter your Email Address'),
          'test',
        );
        verify(
          () => mockSignupViewModel.add(const RegisterEmailChanged('test')),
        ).called(1);
      });

      testWidgets('entering password adds RegisterPasswordChanged event', (
        tester,
      ) async {
        await pumpSignupView(tester);
        await tester.enterText(
          find.widgetWithText(TextFormField, 'Enter your Password'),
          'test',
        );
        verify(
          () => mockSignupViewModel.add(const RegisterPasswordChanged('test')),
        ).called(1);
      });
    });

    group('Form Validation', () {
      testWidgets('shows error for empty fields on submit', (tester) async {
        await pumpSignupView(tester);
        await tester.tap(find.widgetWithText(ElevatedButton, 'Sign Up Now'));
        await tester.pump();

        expect(find.text('Please enter your full name'), findsOneWidget);
        expect(find.text('Please enter an email address'), findsOneWidget);
        expect(find.text('Please enter a password'), findsOneWidget);
      });

      testWidgets('shows error for invalid email format', (tester) async {
        await pumpSignupView(tester);
        await tester.enterText(
          find.widgetWithText(TextFormField, 'Enter your Email Address'),
          'invalid-email',
        );
        await tester.tap(find.widgetWithText(ElevatedButton, 'Sign Up Now'));
        await tester.pump();
        expect(find.text('Please enter a valid email address'), findsOneWidget);
      });

      testWidgets('shows error for short password', (tester) async {
        await pumpSignupView(tester);
        await tester.enterText(
          find.widgetWithText(TextFormField, 'Enter your Password'),
          'short',
        );
        await tester.tap(find.widgetWithText(ElevatedButton, 'Sign Up Now'));
        await tester.pump();
        expect(
          find.text('Password must be at least 6 characters long'),
          findsOneWidget,
        );
      });
    });

    group('Form Submission', () {
      testWidgets('adds OnSubmittedEvent when form is valid', (tester) async {
        const fullName = 'Test User';
        const email = 'test@example.com';
        const password = 'password123';

        when(() => mockSignupViewModel.state).thenReturn(
          const SignupState(
            fullName: fullName,
            email: email,
            password: password,
          ),
        );

        await pumpSignupView(tester);

        await tester.enterText(
          find.widgetWithText(TextFormField, 'Enter your Full Name'),
          fullName,
        );
        await tester.enterText(
          find.widgetWithText(TextFormField, 'Enter your Email Address'),
          email,
        );
        await tester.enterText(
          find.widgetWithText(TextFormField, 'Enter your Password'),
          password,
        );
        await tester.pump();

        await tester.tap(find.widgetWithText(ElevatedButton, 'Sign Up Now'));
        await tester.pump();

        final captured =
            verify(
              () => mockSignupViewModel.add(
                captureAny(that: isA<OnSubmittedEvent>()),
              ),
            ).captured;
        expect(captured.length, 1);
        final event = captured.first as OnSubmittedEvent;
        expect(event.fullName, fullName);
        expect(event.email, email);
        expect(event.password, password);
      });

      testWidgets('does not add OnSubmittedEvent when form is invalid', (
        tester,
      ) async {
        await pumpSignupView(tester);
        await tester.tap(find.widgetWithText(ElevatedButton, 'Sign Up Now'));
        await tester.pump();

        verifyNever(
          () => mockSignupViewModel.add(any(that: isA<OnSubmittedEvent>())),
        );
      });
    });

    group('Other Interactions', () {
      testWidgets('tapping "Signin with google" does not throw error', (
        tester,
      ) async {
        await pumpSignupView(tester);
        clearInteractions(mockNavigatorObserver);

        final googleButtonFinder = find.text('Signin with google');
        await tester.ensureVisible(googleButtonFinder);
        await tester.tap(googleButtonFinder);
        await tester.pumpAndSettle();

        verifyNever(() => mockNavigatorObserver.didPush(any(), any()));
        expect(find.byType(SignupView), findsOneWidget);
      });
    });

    group('Navigation to LoginView', () {
      testWidgets('tapping "Signin" navigates to LoginView', (tester) async {
        await pumpSignupView(tester);
        clearInteractions(mockNavigatorObserver);

        // ✅ FIX: Changed finder to ' Signin' with a leading space.
        final signinLinkFinder = find.text('Signin');
        await tester.ensureVisible(signinLinkFinder);
        await tester.pumpAndSettle();

        await tester.tap(signinLinkFinder);
        await tester.pumpAndSettle();

        verify(() => mockNavigatorObserver.didPush(any(), any())).called(1);
        expect(find.byType(LoginView), findsOneWidget);
      });
    });
  });
}
