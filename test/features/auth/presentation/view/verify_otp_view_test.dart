import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradeverse/features/auth/presentation/view/verify_otp_view.dart';
import 'package:tradeverse/features/auth/presentation/view/set_new_password_view.dart';
import 'package:tradeverse/features/auth/presentation/view_model/forgot_password_view_model.dart/forgot_password_event.dart';
import 'package:tradeverse/features/auth/presentation/view_model/forgot_password_view_model.dart/forgot_password_state.dart';
import 'package:tradeverse/features/auth/presentation/view_model/forgot_password_view_model.dart/forgot_password_view_model.dart';

class MockForgotPasswordViewModel extends Mock
    implements ForgotPasswordViewModel {}

class FakeForgotPasswordEvent extends Fake implements ForgotPasswordEvent {}

void main() {
  late ForgotPasswordViewModel mockBloc;
  setUpAll(() {
    registerFallbackValue(FakeForgotPasswordEvent());
  });

  setUp(() {
    mockBloc = MockForgotPasswordViewModel();

    // Provide a default state
    when(() => mockBloc.state).thenReturn(ForgotPasswordInitial());

    // Provide a stubbed stream
    when(
      () => mockBloc.stream,
    ).thenAnswer((_) => Stream<ForgotPasswordState>.fromIterable([]));
  });

  Widget buildTestableWidget(String email) {
    return MaterialApp(
      home: BlocProvider<ForgotPasswordViewModel>.value(
        value: mockBloc,
        child: VerifyOtpView(email: email),
      ),
    );
  }

  testWidgets('should show OTP form and verify button', (tester) async {
    when(() => mockBloc.state).thenReturn(ForgotPasswordInitial());

    await tester.pumpWidget(buildTestableWidget('test@example.com'));

    expect(
      find.text(
        'An OTP has been sent to test@example.com. Please enter it below.',
      ),
      findsOneWidget,
    );

    expect(find.byType(TextFormField), findsOneWidget);

    // Find the ElevatedButton
    final button = find.byType(ElevatedButton);
    expect(button, findsOneWidget);

    // Check button text inside the ElevatedButton
    final buttonText = find.descendant(
      of: button,
      matching: find.text('Verify OTP'),
    );
    expect(buttonText, findsOneWidget);
  });

  testWidgets('should show error snackbar on ForgotPasswordError state', (
    tester,
  ) async {
    whenListen(
      mockBloc,
      Stream.fromIterable([
        ForgotPasswordInitial(),
        const ForgotPasswordError(message: 'Invalid OTP'),
      ]),
      initialState: ForgotPasswordInitial(),
    );

    await tester.pumpWidget(buildTestableWidget('test@example.com'));
    await tester.pump(); // First rebuild
    await tester.pump(const Duration(seconds: 1)); // Wait for snackbar

    expect(find.text('Invalid OTP'), findsOneWidget);
  });

  testWidgets('should navigate to SetNewPasswordView on OtpVerifiedSuccess', (
    tester,
  ) async {
    const resetToken = 'reset-token-123';

    whenListen(
      mockBloc,
      Stream.fromIterable([
        ForgotPasswordInitial(),
        const OtpVerifiedSuccess(resetToken: resetToken),
      ]),
      initialState: ForgotPasswordInitial(),
    );

    await tester.pumpWidget(buildTestableWidget('test@example.com'));
    await tester.pump(); // Listen rebuild
    await tester.pumpAndSettle(); // Wait for navigation to complete

    expect(find.byType(SetNewPasswordView), findsOneWidget);
    expect(find.text('OTP verified successfully.'), findsOneWidget);
  });

  testWidgets('should dispatch VerifyOtpEvent on form submit', (tester) async {
    when(() => mockBloc.state).thenReturn(ForgotPasswordInitial());
    when(() => mockBloc.add(any())).thenReturn(null);

    await tester.pumpWidget(buildTestableWidget('test@example.com'));

    final otpField = find.byType(TextFormField);
    await tester.enterText(otpField, '123456');

    final verifyButton = find.widgetWithText(ElevatedButton, 'Verify OTP');
    await tester.tap(verifyButton);
    await tester.pump();

    verify(
      () => mockBloc.add(
        const VerifyOtpEvent(email: 'test@example.com', otp: '123456'),
      ),
    ).called(1);
  });

  testWidgets('should show validator error when OTP is empty or invalid', (
    tester,
  ) async {
    when(() => mockBloc.state).thenReturn(ForgotPasswordInitial());

    await tester.pumpWidget(buildTestableWidget('test@example.com'));

    // Empty OTP submit
    final verifyButton = find.widgetWithText(ElevatedButton, 'Verify OTP');
    await tester.tap(verifyButton);
    await tester.pump();
    expect(find.text('Please enter the OTP'), findsOneWidget);

    // Invalid OTP length submit
    await tester.enterText(find.byType(TextFormField), '123');
    await tester.tap(verifyButton);
    await tester.pump();
    expect(find.text('OTP must be 6 digits'), findsOneWidget);
  });
}
