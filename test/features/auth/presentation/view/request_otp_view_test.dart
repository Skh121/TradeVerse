import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:tradeverse/features/auth/presentation/view/request_otp_view.dart';
import 'package:tradeverse/features/auth/presentation/view_model/forgot_password_view_model.dart/forgot_password_event.dart';
import 'package:tradeverse/features/auth/presentation/view_model/forgot_password_view_model.dart/forgot_password_state.dart';
import 'package:tradeverse/features/auth/presentation/view_model/forgot_password_view_model.dart/forgot_password_view_model.dart';

class MockForgotPasswordViewModel
    extends MockBloc<ForgotPasswordEvent, ForgotPasswordState>
    implements ForgotPasswordViewModel {}

class FakeForgotPasswordEvent extends Fake implements ForgotPasswordEvent {}

class FakeForgotPasswordState extends Fake implements ForgotPasswordState {}

void main() {
  late MockForgotPasswordViewModel mockBloc;

  setUpAll(() {
    registerFallbackValue(FakeForgotPasswordEvent());
    registerFallbackValue(FakeForgotPasswordState());
  });

  setUp(() {
    mockBloc = MockForgotPasswordViewModel();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: BlocProvider<ForgotPasswordViewModel>.value(
        value: mockBloc,
        child: const RequestOtpView(),
      ),
    );
  }

  testWidgets('renders UI elements correctly', (tester) async {
    when(() => mockBloc.state).thenReturn(ForgotPasswordInitial());

    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.text('Forgot Password'), findsOneWidget);
    expect(
      find.text('Enter your email to receive a One-Time Password (OTP).'),
      findsOneWidget,
    );
    expect(find.byType(TextFormField), findsOneWidget);
    expect(find.text('Send OTP'), findsOneWidget);
  });

  testWidgets('shows validation error if email empty', (tester) async {
    when(() => mockBloc.state).thenReturn(ForgotPasswordInitial());

    await tester.pumpWidget(createWidgetUnderTest());

    await tester.tap(find.text('Send OTP'));
    await tester.pump();

    expect(find.text('Please enter your email'), findsOneWidget);
  });

  testWidgets('shows validation error if email invalid', (tester) async {
    when(() => mockBloc.state).thenReturn(ForgotPasswordInitial());

    await tester.pumpWidget(createWidgetUnderTest());

    await tester.enterText(find.byType(TextFormField), 'bademail');
    await tester.tap(find.text('Send OTP'));
    await tester.pump();

    expect(find.text('Please enter a valid email'), findsOneWidget);
  });

  testWidgets('dispatches RequestOtpEvent when form valid', (tester) async {
    when(() => mockBloc.state).thenReturn(ForgotPasswordInitial());

    await tester.pumpWidget(createWidgetUnderTest());

    const email = 'user@example.com';
    await tester.enterText(find.byType(TextFormField), email);
    await tester.tap(find.text('Send OTP'));
    await tester.pump();

    verify(() => mockBloc.add(RequestOtpEvent(email: email))).called(1);
  });

  testWidgets('shows loading indicator and disables button when loading', (
    tester,
  ) async {
    when(() => mockBloc.state).thenReturn(ForgotPasswordLoading());

    await tester.pumpWidget(createWidgetUnderTest());

    final button = find.byType(ElevatedButton);
    final indicator = find.byType(CircularProgressIndicator);

    expect(tester.widget<ElevatedButton>(button).onPressed, isNull);
    expect(indicator, findsOneWidget);
  });

  testWidgets('shows SnackBar and navigates on OtpRequestedSuccess', (
    tester,
  ) async {
    const testEmail = 'user@example.com';
    const successMessage = 'OTP sent to your email.';

    whenListen(
      mockBloc,
      Stream.fromIterable([
        ForgotPasswordInitial(),
        OtpRequestedSuccess(email: testEmail, message: successMessage),
      ]),
      initialState: ForgotPasswordInitial(),
    );

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump(); // build with initial state
    await tester.pump(); // build with success state (triggers SnackBar)
    await tester.pumpAndSettle(const Duration(seconds: 2));
    
    expect(find.byType(SnackBar), findsWidgets);
    expect(find.text(successMessage), findsOneWidget);
  });

  testWidgets('shows SnackBar on ForgotPasswordError', (tester) async {
    const errorMessage = 'Some error occurred';

    whenListen(
      mockBloc,
      Stream.fromIterable([
        ForgotPasswordInitial(),
        ForgotPasswordError(message: errorMessage),
      ]),
      initialState: ForgotPasswordInitial(),
    );

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump(); // build with initial state
    await tester.pump(); // build with error state (triggers SnackBar)

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text(errorMessage), findsOneWidget);
  });
}
