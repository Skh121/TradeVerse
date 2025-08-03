// lib/features/goal/presentation/bloc/goal_event.dart

import 'package:equatable/equatable.dart';

/// Base class for all Goal events.
abstract class GoalEvent extends Equatable {
  const GoalEvent();

  @override
  List<Object> get props => [];
}

/// Event to trigger fetching all goals.
class FetchGoals extends GoalEvent {}

/// Event to trigger creating a new goal.
class CreateGoalEvent extends GoalEvent {
  final String type;
  final String period;
  final double targetValue;
  final DateTime startDate;
  final DateTime endDate;

  const CreateGoalEvent({
    required this.type,
    required this.period,
    required this.targetValue,
    required this.startDate,
    required this.endDate,
  });

  @override
  List<Object> get props => [type, period, targetValue, startDate, endDate];
}

/// Event to trigger deleting a goal.
class DeleteGoalEvent extends GoalEvent {
  final String id;

  const DeleteGoalEvent({required this.id});

  @override
  List<Object> get props => [id];
}
