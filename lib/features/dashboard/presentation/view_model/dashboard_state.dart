import 'package:equatable/equatable.dart';
import 'package:tradeverse/features/dashboard/domain/entity/dashboard_stats_entity.dart';

class DashboardState extends Equatable {
  final DashboardStatsEntity? stats;
  final bool isLoading;
  final String error;
  final String? fullName;

  const DashboardState({
    required this.stats,
    required this.isLoading,
    required this.error,
    required this.fullName,
  });

  factory DashboardState.initial() {
    return const DashboardState(stats: null, isLoading: false, error: '',fullName: null);
  }

  DashboardState copyWith({
    DashboardStatsEntity? stats,
    bool? isLoading,
    String? error,
    String? fullName,
  }) {
    return DashboardState(
      stats: stats ?? this.stats,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      fullName: fullName ?? this.fullName,
       
    );
  }

  @override
  List<Object?> get props => [stats, isLoading, error,fullName];
}
