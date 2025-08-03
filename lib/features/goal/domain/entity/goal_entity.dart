// lib/features/goal/domain/entity/goal_entity.dart

import 'package:equatable/equatable.dart';

/// Represents a goal in the domain layer.
class GoalEntity extends Equatable {
  final String id;
  final String type; // e.g., "pnl", "win_rate"
  final String period; // e.g., "daily", "weekly", "monthly", "yearly"
  final double targetValue;
  final double progress; // Already a percentage (e.g., 32.0 for 32%)
  final DateTime startDate;
  final DateTime endDate;
  final bool achieved;
  final DateTime? createdAt; // Added based on backend response
  final DateTime? updatedAt; // Added based on backend response

  const GoalEntity({
    required this.id,
    required this.type,
    required this.period,
    required this.targetValue,
    required this.progress,
    required this.startDate,
    required this.endDate,
    required this.achieved,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    type,
    period,
    targetValue,
    progress,
    startDate,
    endDate,
    achieved,
    createdAt,
    updatedAt,
  ];

  // Helper method to create a copy with updated values
  GoalEntity copyWith({
    String? id,
    String? type,
    String? period,
    double? targetValue,
    double? progress,
    DateTime? startDate,
    DateTime? endDate,
    bool? achieved,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return GoalEntity(
      id: id ?? this.id,
      type: type ?? this.type,
      period: period ?? this.period,
      targetValue: targetValue ?? this.targetValue,
      progress: progress ?? this.progress,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      achieved: achieved ?? this.achieved,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
