import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:tradeverse/features/goal/domain/entity/goal_entity.dart';
import 'package:tradeverse/features/goal/presentation/view/goal_view.dart';
import 'package:tradeverse/features/goal/presentation/view_model/goal_event.dart';
import 'package:tradeverse/features/goal/presentation/view_model/goal_state.dart';
import 'package:tradeverse/features/goal/presentation/view_model/goal_view_model.dart';

// Mocks for BLoC and Events
class MockGoalViewModel extends MockBloc<GoalEvent, GoalState>
    implements GoalViewModel {}

class FakeGoalEvent extends Fake implements GoalEvent {}

class FakeGoalState extends Fake implements GoalState {}

class _CustomMockGoalViewModel extends Mock implements GoalViewModel {
  _CustomMockGoalViewModel(this._initialState, this._stream);

  final GoalState _initialState;
  final Stream<GoalState> _stream;

  @override
  GoalState get state => _initialState; // Always returns the initial state we give it.

  @override
  Stream<GoalState> get stream => _stream; // Emits states from the stream we give it.
}

void main() {
  // Declare test-wide variables
  late MockGoalViewModel mockGoalViewModel;
  late GoalEntity testGoal;

  // Runs once before all tests in this file
  setUpAll(() {
    registerFallbackValue(FakeGoalEvent());
    registerFallbackValue(FakeGoalState());
  });

  // Runs before each test to ensure a clean state
  setUp(() {
    mockGoalViewModel = MockGoalViewModel();
    testGoal = GoalEntity(
      id: '1',
      type: 'pnl',
      period: 'weekly',
      targetValue: 500,
      progress: 50,
      achieved: false,
      startDate: DateTime(2025, 8, 1),
      endDate: DateTime(2025, 8, 7),
    );
  });

  // Helper to pump the GoalView widget with a mock BLoC
  Future<void> pumpWidget(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<GoalViewModel>.value(
          value: mockGoalViewModel,
          child: const GoalView(),
        ),
      ),
    );
  }

  // Helper to fill the form with valid data
  Future<void> fillFormWithValidData(WidgetTester tester) async {
    // Find the field by its label text and enter a value.
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Target Value (e.g., 500 or 65)'),
      '500',
    );

    // Select Start Date
    await tester.tap(find.byIcon(Icons.calendar_today).first);
    await tester.pumpAndSettle();
    await tester.tap(
      find.text('OK'),
    ); // Note: This picks the current date, which is fine for the test.
    await tester.pumpAndSettle();

    // Select End Date
    await tester.tap(find.byIcon(Icons.calendar_today).last);
    await tester.pumpAndSettle();
    await tester.tap(
      find.text('OK'),
    ); // Select the same day to ensure start is not after end.
    await tester.pumpAndSettle();
  }

  group('GoalView', () {
    testWidgets('dispatches FetchGoals on initState', (tester) async {
      // Arrange: Set initial state
      when(() => mockGoalViewModel.state).thenReturn(GoalInitial());

      // Act
      await pumpWidget(tester);

      // Assert: Verify that FetchGoals event was added
      verify(() => mockGoalViewModel.add(FetchGoals())).called(1);
    });

    group('UI Rendering based on State', () {
      // In test/features/goal/presentation/view/goal_view_test.dart

      testWidgets(
        'shows loading indicators when state is GoalLoading initially',
        (tester) async {
          when(() => mockGoalViewModel.state).thenReturn(GoalLoading());
          await pumpWidget(tester);
          expect(find.byType(CircularProgressIndicator), findsNWidgets(2));
        },
      );

      testWidgets('shows "No goals" message when loaded with empty list', (
        tester,
      ) async {
        // Arrange
        when(
          () => mockGoalViewModel.state,
        ).thenReturn(const GoalLoaded(goals: []));

        // Act
        await pumpWidget(tester);
        await tester.pump();

        // Assert
        expect(find.text('No goals set yet.'), findsOneWidget);
      });

      testWidgets('renders list of goals when state is GoalLoaded with data', (
        tester,
      ) async {
        // Arrange
        when(
          () => mockGoalViewModel.state,
        ).thenReturn(GoalLoaded(goals: [testGoal]));

        // Act
        await pumpWidget(tester);
        await tester.pump();

        // Assert
        expect(find.byType(Card), findsOneWidget);
        expect(find.text('P&L Goal (Weekly)'), findsOneWidget);
        expect(find.text('Progress: 50.0%'), findsOneWidget);
      });

      testWidgets('renders achieved text when goal is achieved', (
        tester,
      ) async {
        // Arrange
        final achievedGoal = testGoal.copyWith(achieved: true);
        when(
          () => mockGoalViewModel.state,
        ).thenReturn(GoalLoaded(goals: [achievedGoal]));

        // Act
        await pumpWidget(tester);
        await tester.pump();

        // Assert
        expect(find.text('🎉 Goal Achieved!'), findsOneWidget);
      });
    });

    group('Form Interactions', () {
      testWidgets('changes dropdown values on selection', (tester) async {
        // Arrange
        when(
          () => mockGoalViewModel.state,
        ).thenReturn(const GoalLoaded(goals: []));
        await pumpWidget(tester);

        // Act & Assert for Goal Type
        // Find the dropdown by the text it displays ('P&L') and tap it.
        await tester.tap(find.text('P&L'));
        await tester.pumpAndSettle();
        // Find the option in the opened menu and tap it.
        await tester.tap(find.text('Win Rate').last);
        await tester.pumpAndSettle();
        // Verify the value has changed.
        expect(find.text('Win Rate'), findsOneWidget);

        // Act & Assert for Period
        // Find the dropdown by the text it displays ('Weekly') and tap it.
        await tester.tap(find.text('Weekly'));
        await tester.pumpAndSettle();
        // Find the option in the opened menu and tap it.
        await tester.tap(find.text('Monthly').last);
        await tester.pumpAndSettle();
        // Verify the value has changed.
        expect(find.text('Monthly'), findsOneWidget);
      });

      testWidgets('shows validation errors for empty fields', (tester) async {
        // Arrange
        when(
          () => mockGoalViewModel.state,
        ).thenReturn(const GoalLoaded(goals: []));
        await pumpWidget(tester);

        // Act
        await tester.tap(find.text('Save Goal'));
        await tester.pump();

        // Assert
        expect(find.text('Please enter a target value'), findsOneWidget);
        expect(find.text('Please select a start date'), findsOneWidget);
        expect(find.text('Please select an end date'), findsOneWidget);
      });

      testWidgets('shows validation error for invalid number', (tester) async {
        // Arrange
        when(
          () => mockGoalViewModel.state,
        ).thenReturn(const GoalLoaded(goals: []));
        await pumpWidget(tester);

        // Act
        // Find the TextFormField by its visible label text.
        final targetValueField = find.widgetWithText(
          TextFormField,
          'Target Value (e.g., 500 or 65)',
        );
        await tester.enterText(targetValueField, 'abc');
        await tester.tap(find.text('Save Goal'));
        await tester.pump();

        // Assert
        expect(find.text('Please enter a valid number'), findsOneWidget);
      });
    });

    group('Goal Creation', () {
      testWidgets('shows SnackBar if start date is after end date', (
        tester,
      ) async {
        // Arrange
        when(
          () => mockGoalViewModel.state,
        ).thenReturn(const GoalLoaded(goals: []));
        await pumpWidget(tester);

        // Act: Enter valid target using the new, robust key finder
        await tester.enterText(
          find.byKey(const Key('targetValue_textFormField')),
          '500',
        );

        // Select Start Date: August 4th, 2025
        // Note: The current date in the test is Aug 3, 2025
        await tester.tap(find.byIcon(Icons.calendar_today).first);
        await tester.pumpAndSettle();
        // Tapping '4' is brittle. A better way would be to find the exact date,
        // but for this test, we'll proceed.
        await tester.tap(find.text('4'));
        await tester.tap(find.text('OK'));
        await tester.pumpAndSettle();

        // Select End Date: August 3rd, 2025 (before start date)
        await tester.tap(find.byIcon(Icons.calendar_today).last);
        await tester.pumpAndSettle();
        await tester.tap(find.text('3'));
        await tester.tap(find.text('OK'));
        await tester.pumpAndSettle();

        // Tap save button
        await tester.tap(find.text('Save Goal'));
        await tester.pump(); // pump to show SnackBar

        // Assert
        expect(find.byType(SnackBar), findsOneWidget);
        expect(
          find.text('Start date must be before end date.'),
          findsOneWidget,
        );
        verifyNever(
          () => mockGoalViewModel.add(any(that: isA<CreateGoalEvent>())),
        );
      });

      testWidgets(
        'dispatches CreateGoalEvent on valid submission and clears form',
        (tester) async {
          // Arrange
          when(
            () => mockGoalViewModel.state,
          ).thenReturn(const GoalLoaded(goals: []));
          await pumpWidget(tester);

          // Act
          await fillFormWithValidData(tester);
          await tester.tap(find.text('Save Goal'));
          await tester.pump();

          // Assert
          verify(
            () => mockGoalViewModel.add(any(that: isA<CreateGoalEvent>())),
          ).called(1);
          expect(
            find.text('500'),
            findsNothing,
          ); // Check if controller is cleared
        },
      );
    });

    group('Goal Deletion', () {
      testWidgets('cancels deletion when "Cancel" is tapped in dialog', (
        tester,
      ) async {
        // Arrange
        when(
          () => mockGoalViewModel.state,
        ).thenReturn(GoalLoaded(goals: [testGoal]));
        await pumpWidget(tester);
        await tester.pumpAndSettle(); // Allow list to build

        // Act
        final deleteIconFinder = find.byIcon(Icons.delete);

        // *** THE FIX: Scroll the delete icon into view before tapping ***
        await tester.ensureVisible(deleteIconFinder);
        await tester.pumpAndSettle(); // Let the scroll animation finish

        // Now that it's visible, tap the icon
        await tester.tap(deleteIconFinder);
        await tester.pumpAndSettle(); // Wait for the dialog to appear

        // Assert: The dialog is now found successfully
        expect(find.byType(AlertDialog), findsOneWidget);

        // Tap the "Cancel" button inside the dialog
        await tester.tap(find.text('Cancel'));
        await tester.pumpAndSettle(); // Wait for the dialog to disappear

        // Assert: The dialog is gone and no delete event was sent
        expect(find.byType(AlertDialog), findsNothing);
        verifyNever(
          () => mockGoalViewModel.add(any(that: isA<DeleteGoalEvent>())),
        );
      });

      testWidgets(
        'dispatches DeleteGoalEvent when "Delete" is tapped in dialog',
        (tester) async {
          // Arrange
          when(
            () => mockGoalViewModel.state,
          ).thenReturn(GoalLoaded(goals: [testGoal]));
          await pumpWidget(tester);
          await tester.pumpAndSettle();

          // Act
          final deleteIconFinder = find.byIcon(Icons.delete);

          // *** THE FIX: Also apply the scroll here ***
          await tester.ensureVisible(deleteIconFinder);
          await tester.pumpAndSettle();

          await tester.tap(deleteIconFinder);
          await tester.pumpAndSettle();

          // Assert: The dialog appears
          expect(find.byType(AlertDialog), findsOneWidget);

          // Tap the "Delete" button inside the dialog
          await tester.tap(find.text('Delete'));
          await tester.pumpAndSettle();

          // Assert: The dialog is gone and the delete event was sent
          expect(find.byType(AlertDialog), findsNothing);
          verify(
            () => mockGoalViewModel.add(DeleteGoalEvent(id: testGoal.id)),
          ).called(1);
        },
      );
    });
    group('Listener State Changes', () {
      testWidgets('shows success SnackBar for GoalOperationSuccess', (
        tester,
      ) async {
        // Arrange
        whenListen(
          mockGoalViewModel,
          Stream.value(const GoalOperationSuccess(message: 'Goal saved!')),
          initialState: GoalInitial(),
        );

        // Act
        await pumpWidget(tester);
        await tester.pump(); // Process the stream emission

        // Assert
        expect(find.byType(SnackBar), findsOneWidget);
        expect(find.text('Goal saved!'), findsOneWidget);
      });

      testWidgets('shows error SnackBar for GoalError', (tester) async {
        // Arrange
        whenListen(
          mockGoalViewModel,
          Stream.value(const GoalError(message: 'Failed to save')),
          initialState: GoalInitial(),
        );

        // Act
        await pumpWidget(tester);
        await tester.pump();

        // Assert
        expect(find.byType(SnackBar), findsOneWidget);
        expect(find.text('Error: Failed to save'), findsOneWidget);
      });

      testWidgets('shows loading SnackBar for GoalLoading', (tester) async {
        // Arrange
        whenListen(
          mockGoalViewModel,
          Stream.value(GoalLoading()),
          initialState: GoalInitial(),
        );

        // Act
        await pumpWidget(tester);
        await tester.pump();

        // Assert
        expect(find.byType(SnackBar), findsOneWidget);
        expect(find.text('Processing goal...'), findsOneWidget);
      });
      testWidgets(
        'shows previous goals when operation is loading (covers edge case)',
        (tester) async {
          // Arrange:
          final initialLoadedState = GoalLoaded(goals: [testGoal]);
          final loadingStream = Stream.value(GoalLoading()).asBroadcastStream();
          final customMock = _CustomMockGoalViewModel(
            initialLoadedState,
            loadingStream,
          );

          // Act:
          await tester.pumpWidget(
            MaterialApp(
              home: BlocProvider<GoalViewModel>.value(
                value: customMock,
                child: const GoalView(),
              ),
            ),
          );
          // Process the GoalLoading state from the stream
          await tester.pump();

          // Assert:
          // 1. The goal card is still visible, proving the main logic works.
          expect(find.byType(Card), findsOneWidget);

          // 2. Assert the button is disabled using the bulletproof key finder.
          final saveButtonFinder = find.byKey(const Key('save_goal_button'));

          // First, ensure our key finder locates the button.
          expect(saveButtonFinder, findsOneWidget);

          // Then, get the widget instance and check its property.
          final saveButton = tester.widget<ElevatedButton>(saveButtonFinder);
          expect(
            saveButton.onPressed,
            isNull,
            reason: "Button should be disabled in loading state",
          );
        },
      );
    });
  });
}
