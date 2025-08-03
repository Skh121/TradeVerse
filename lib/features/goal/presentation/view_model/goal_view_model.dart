// lib/features/goal/presentation/bloc/goal_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradeverse/features/goal/domain/use_case/create_goal_use_case.dart';
import 'package:tradeverse/features/goal/domain/use_case/delete_goal_use_case.dart';
import 'package:tradeverse/features/goal/domain/use_case/get_goal_use_case.dart';
import 'goal_event.dart';
import 'goal_state.dart';

class GoalViewModel extends Bloc<GoalEvent, GoalState> {
  final CreateGoalUseCase _createGoal;
  final GetGoalsUseCase _getGoals;
  // Removed UpdateGoal field
  // final UpdateGoal _updateGoal;
  final DeleteGoalUseCase _deleteGoal;

  GoalViewModel({
    required CreateGoalUseCase createGoal,
    required GetGoalsUseCase getGoals,
    // Removed UpdateGoal from constructor
    // required UpdateGoal updateGoal,
    required DeleteGoalUseCase deleteGoal,
  }) : _createGoal = createGoal,
       _getGoals = getGoals,
       // _updateGoal = updateGoal,
       _deleteGoal = deleteGoal,
       super(GoalInitial()) {
    on<FetchGoals>(_onFetchGoals);
    on<CreateGoalEvent>(_onCreateGoal);
    on<DeleteGoalEvent>(_onDeleteGoal);
  }

  /// Handles [FetchGoals] event.
  Future<void> _onFetchGoals(FetchGoals event, Emitter<GoalState> emit) async {
    emit(GoalLoading());
    final result = await _getGoals();
    result.fold(
      (failure) => emit(GoalError(message: failure.message)),
      (goals) => emit(GoalLoaded(goals: goals)),
    );
  }

  /// Handles [CreateGoalEvent] event.
  Future<void> _onCreateGoal(
    CreateGoalEvent event,
    Emitter<GoalState> emit,
  ) async {
    emit(GoalLoading()); // Indicate loading during creation
    final params = CreateGoalUseCaseParams(
      type: event.type,
      period: event.period,
      targetValue: event.targetValue,
      startDate: event.startDate,
      endDate: event.endDate,
    );
    final result = await _createGoal(params);
    result.fold((failure) => emit(GoalError(message: failure.message)), (goal) {
      // After successful creation, refetch all goals to update the list
      add(FetchGoals()); // Trigger a re-fetch
      emit(GoalOperationSuccess(message: 'Goal created successfully!'));
    });
  }

  Future<void> _onDeleteGoal(
    DeleteGoalEvent event,
    Emitter<GoalState> emit,
  ) async {
    emit(GoalLoading()); // Indicate loading during deletion
    final params = DeleteGoalUseCaseParams(id: event.id);
    final result = await _deleteGoal(params);
    result.fold((failure) => emit(GoalError(message: failure.message)), (
      message,
    ) {
      // After successful deletion, refetch all goals to update the list
      add(FetchGoals()); // Trigger a re-fetch
      emit(GoalOperationSuccess(message: message));
    });
  }
}
