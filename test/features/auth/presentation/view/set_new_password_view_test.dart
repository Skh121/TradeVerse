import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tradeverse/features/auth/presentation/view/set_new_password_view.dart';
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
        child: const SetNewPasswordView(resetToken: 'test-token'),
      ),
    );
  }

  testWidgets('renders form correctly', (tester) async {
    when(() => mockBloc.state).thenReturn(ForgotPasswordInitial());

    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.text('Set New Password'), findsOneWidget);
    expect(find.text('Enter your new password.'), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(2));
    expect(find.text('Reset Password'), findsOneWidget);
  });

  testWidgets('shows validation error when fields are empty', (tester) async {
    when(() => mockBloc.state).thenReturn(ForgotPasswordInitial());

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.tap(find.text('Reset Password'));
    await tester.pump();

    expect(find.text('Please enter a new password'), findsOneWidget);
    expect(find.text('Please confirm your password'), findsOneWidget);
  });

  testWidgets('shows error if passwords do not match', (tester) async {
    when(() => mockBloc.state).thenReturn(ForgotPasswordInitial());

    await tester.pumpWidget(createWidgetUnderTest());

    await tester.enterText(find.byType(TextFormField).at(0), 'password123');
    await tester.enterText(find.byType(TextFormField).at(1), 'different123');
    await tester.tap(find.text('Reset Password'));
    await tester.pump();

    expect(find.text('Passwords do not match'), findsOneWidget);
  });

  testWidgets('dispatches ResetPasswordWithOtpEvent on valid input', (
    tester,
  ) async {
    when(() => mockBloc.state).thenReturn(ForgotPasswordInitial());

    await tester.pumpWidget(createWidgetUnderTest());

    await tester.enterText(find.byType(TextFormField).at(0), 'password123');
    await tester.enterText(find.byType(TextFormField).at(1), 'password123');
    await tester.tap(find.text('Reset Password'));
    await tester.pump();

    verify(
      () => mockBloc.add(
        ResetPasswordWithOtpEvent(
          resetToken: 'test-token',
          newPassword: 'password123',
        ),
      ),
    ).called(1);
  });

  testWidgets(
    'disables button and shows CircularProgressIndicator when loading',
    (tester) async {
      when(() => mockBloc.state).thenReturn(ForgotPasswordLoading());

      await tester.pumpWidget(createWidgetUnderTest());

      final button = find.byType(ElevatedButton);
      final indicator = find.byType(CircularProgressIndicator);

      expect(tester.widget<ElevatedButton>(button).onPressed, isNull);
      expect(indicator, findsOneWidget);
    },
  );

  testWidgets('shows SnackBar on ForgotPasswordError', (tester) async {
    const errorMessage = 'Failed to reset password';

    whenListen(
      mockBloc,
      Stream.fromIterable([
        ForgotPasswordInitial(),
        ForgotPasswordError(message: errorMessage),
      ]),
      initialState: ForgotPasswordInitial(),
    );

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump(); // process error state
    await tester.pump(); // allow SnackBar to show

    expect(find.text(errorMessage), findsOneWidget);
  });
}
