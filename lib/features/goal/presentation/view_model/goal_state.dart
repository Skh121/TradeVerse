// lib/features/goal/presentation/bloc/goal_state.dart

import 'package:equatable/equatable.dart';
import '../../domain/entity/goal_entity.dart'; // Import GoalEntity

/// Base class for all Goal states.
abstract class GoalState extends Equatable {
  const GoalState();

  @override
  List<Object> get props => [];
}

/// Initial state for the Goal Bloc.
class GoalInitial extends GoalState {}

/// State indicating that goals are currently loading.
class GoalLoading extends GoalState {}

/// State indicating that goals have been successfully loaded.
class GoalLoaded extends GoalState {
  final List<GoalEntity> goals;

  const GoalLoaded({required this.goals});

  @override
  List<Object> get props => [goals];
}

/// State indicating that a goal operation (create, update, delete) was successful.
class GoalOperationSuccess extends GoalState {
  final String message;

  const GoalOperationSuccess({required this.message});

  @override
  List<Object> get props => [message];
}

/// State indicating that an error occurred during goal operations.
class GoalError extends GoalState {
  final String message;

  const GoalError({required this.message});

  @override
  List<Object> get props => [message];
}
