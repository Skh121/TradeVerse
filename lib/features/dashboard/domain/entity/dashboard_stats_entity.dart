import 'package:equatable/equatable.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:tradeverse/features/dashboard/domain/entity/recent_trade_entity.dart';
import 'package:tradeverse/features/dashboard/domain/entity/this_week_summary_entity.dart';

class DashboardStatsEntity extends Equatable {
  final double totalPL;
  final List<FlSpot> equityCurve;
  final List<ThisWeekSummaryEntity> thisWeeksSummaries;
  final List<RecentTradeEntity> recentTrades; 

  const DashboardStatsEntity({
    required this.totalPL,
    required this.equityCurve,
    required this.thisWeeksSummaries,
    required this.recentTrades,
  });

  @override
  List<Object?> get props => [
    totalPL,
    equityCurve,
    thisWeeksSummaries,
    recentTrades,
  ];
}
