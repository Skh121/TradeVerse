// test/features/goal/presentation/bloc/goal_bloc_test.dart

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tradeverse/core/error/failure.dart';
import 'package:tradeverse/features/goal/domain/entity/goal_entity.dart';
import 'package:tradeverse/features/goal/domain/use_case/create_goal_use_case.dart';
import 'package:tradeverse/features/goal/domain/use_case/delete_goal_use_case.dart';
import 'package:tradeverse/features/goal/domain/use_case/get_goal_use_case.dart';
import 'package:tradeverse/features/goal/presentation/view_model/goal_event.dart';
import 'package:tradeverse/features/goal/presentation/view_model/goal_state.dart';
import 'package:tradeverse/features/goal/presentation/view_model/goal_view_model.dart';

// Mocks
class MockCreateGoalUseCase extends Mock implements CreateGoalUseCase {}

class MockGetGoalsUseCase extends Mock implements GetGoalsUseCase {}

class MockDeleteGoalUseCase extends Mock implements DeleteGoalUseCase {}

// Fake params to avoid errors from mocktail any()
class CreateGoalUseCaseParamsFake extends Fake
    implements CreateGoalUseCaseParams {}

class DeleteGoalUseCaseParamsFake extends Fake
    implements DeleteGoalUseCaseParams {}

void main() {
  late GoalViewModel bloc;
  late MockCreateGoalUseCase mockCreateGoal;
  late MockGetGoalsUseCase mockGetGoals;
  late MockDeleteGoalUseCase mockDeleteGoal;

  final testFailure = ServerFailure(message: 'Failure occurred');

  final dummyGoal = GoalEntity(
    id: 'goal1',
    type: 'pnl',
    period: 'monthly',
    targetValue: 100.0,
    progress: 32.0,
    startDate: DateTime(2025, 1, 1),
    endDate: DateTime(2025, 12, 31),
    achieved: false,
    createdAt: DateTime(2025, 1, 1),
    updatedAt: DateTime(2025, 6, 1),
  );

  final dummyGoalsList = [dummyGoal];

  setUpAll(() {
    registerFallbackValue(CreateGoalUseCaseParamsFake());
    registerFallbackValue(DeleteGoalUseCaseParamsFake());
  });

  setUp(() {
    mockCreateGoal = MockCreateGoalUseCase();
    mockGetGoals = MockGetGoalsUseCase();
    mockDeleteGoal = MockDeleteGoalUseCase();

    bloc = GoalViewModel(
      createGoal: mockCreateGoal,
      getGoals: mockGetGoals,
      deleteGoal: mockDeleteGoal,
    );
  });

  test('initial state should be GoalInitial', () {
    expect(bloc.state, GoalInitial());
  });

  group('FetchGoals', () {
    blocTest<GoalViewModel, GoalState>(
      'emits [GoalLoading, GoalLoaded] when fetch succeeds',
      build: () {
        when(
          () => mockGetGoals(),
        ).thenAnswer((_) async => Right(dummyGoalsList));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchGoals()),
      expect: () => [GoalLoading(), GoalLoaded(goals: dummyGoalsList)],
      verify: (_) => verify(() => mockGetGoals()).called(1),
    );

    blocTest<GoalViewModel, GoalState>(
      'emits [GoalLoading, GoalError] when fetch fails',
      build: () {
        when(() => mockGetGoals()).thenAnswer((_) async => Left(testFailure));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchGoals()),
      expect: () => [GoalLoading(), GoalError(message: testFailure.message)],
      verify: (_) => verify(() => mockGetGoals()).called(1),
    );
  });

  group('CreateGoalEvent', () {
    blocTest<GoalViewModel, GoalState>(
      'emits [GoalLoading, GoalOperationSuccess, GoalLoading, GoalLoaded] on success',
      build: () {
        when(
          () => mockCreateGoal(any()),
        ).thenAnswer((_) async => Right(dummyGoal));
        when(
          () => mockGetGoals(),
        ).thenAnswer((_) async => Right(dummyGoalsList));
        return bloc;
      },
      act:
          (bloc) => bloc.add(
            CreateGoalEvent(
              type: dummyGoal.type,
              period: dummyGoal.period,
              targetValue: dummyGoal.targetValue,
              startDate: dummyGoal.startDate,
              endDate: dummyGoal.endDate,
            ),
          ),
      expect:
          () => [
            GoalLoading(),
            const GoalOperationSuccess(message: 'Goal created successfully!'),
            GoalLoading(), // Because FetchGoals() is triggered internally after create success
            GoalLoaded(goals: dummyGoalsList),
          ],
      verify: (_) {
        verify(() => mockCreateGoal(any())).called(1);
        verify(() => mockGetGoals()).called(1);
      },
    );

    blocTest<GoalViewModel, GoalState>(
      'emits [GoalLoading, GoalError] on create failure',
      build: () {
        when(
          () => mockCreateGoal(any()),
        ).thenAnswer((_) async => Left(testFailure));
        return bloc;
      },
      act:
          (bloc) => bloc.add(
            CreateGoalEvent(
              type: dummyGoal.type,
              period: dummyGoal.period,
              targetValue: dummyGoal.targetValue,
              startDate: dummyGoal.startDate,
              endDate: dummyGoal.endDate,
            ),
          ),
      expect: () => [GoalLoading(), GoalError(message: testFailure.message)],
      verify: (_) => verify(() => mockCreateGoal(any())).called(1),
    );
  });

  group('DeleteGoalEvent', () {
    blocTest<GoalViewModel, GoalState>(
      'emits [GoalLoading, GoalOperationSuccess, GoalLoading, GoalLoaded] on success',
      build: () {
        when(
          () => mockDeleteGoal(any()),
        ).thenAnswer((_) async => Right('Goal deleted successfully'));
        when(
          () => mockGetGoals(),
        ).thenAnswer((_) async => Right(dummyGoalsList));
        return bloc;
      },
      act: (bloc) => bloc.add(const DeleteGoalEvent(id: 'goal1')),
      expect:
          () => [
            GoalLoading(),
            const GoalOperationSuccess(message: 'Goal deleted successfully'),
            GoalLoading(),
            GoalLoaded(goals: dummyGoalsList),
          ],
      verify: (_) {
        verify(() => mockDeleteGoal(any())).called(1);
        verify(() => mockGetGoals()).called(1);
      },
    );

    blocTest<GoalViewModel, GoalState>(
      'emits [GoalLoading, GoalError] on delete failure',
      build: () {
        when(
          () => mockDeleteGoal(any()),
        ).thenAnswer((_) async => Left(testFailure));
        return bloc;
      },
      act: (bloc) => bloc.add(const DeleteGoalEvent(id: 'goal1')),
      expect: () => [GoalLoading(), GoalError(message: testFailure.message)],
      verify: (_) => verify(() => mockDeleteGoal(any())).called(1),
    );
  });
}
