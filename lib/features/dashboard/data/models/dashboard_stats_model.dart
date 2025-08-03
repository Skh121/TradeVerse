import 'package:json_annotation/json_annotation.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:tradeverse/features/dashboard/domain/entity/dashboard_stats_entity.dart';
import 'package:tradeverse/features/dashboard/data/models/recent_trade_api_model.dart';
import 'package:tradeverse/features/dashboard/data/models/equity_curve_spot_model.dart';
import 'package:tradeverse/features/dashboard/domain/entity/this_week_summary_entity.dart';

part 'dashboard_stats_model.g.dart';

@JsonSerializable()
class DashboardStatsModel extends DashboardStatsEntity {
  @JsonKey(name: 'totalPL')
  final double totalPlModel;

  @JsonKey(name: 'equityCurve')
  final List<EquityCurveSpotModel> equityCurveModel;

  @JsonKey(name: 'thisWeeksTrades')
  final List<RecentTradeApiModel> thisWeeksTradesRaw;

  @JsonKey(name: 'recentTrades') // <<< Re-added recentTradesModel
  final List<RecentTradeApiModel> recentTradesModel;

  DashboardStatsModel({
    required this.totalPlModel,
    required this.equityCurveModel,
    required this.thisWeeksTradesRaw,
    required this.recentTradesModel, // <<< Updated constructor
  }) : super(
         totalPL: totalPlModel,
         equityCurve:
             equityCurveModel.asMap().entries.map((entry) {
               return FlSpot(entry.key.toDouble(), entry.value.value);
             }).toList(),
         thisWeeksSummaries: _processThisWeeksTrades(thisWeeksTradesRaw),
         recentTrades: recentTradesModel, // <<< Pass recentTradesModel to super
       );

  factory DashboardStatsModel.fromJson(Map<String, dynamic> json) =>
      _$DashboardStatsModelFromJson(json);

  Map<String, dynamic> toJson() => _$DashboardStatsModelToJson(this);

  // Helper method to process raw trades into daily summaries
  static List<ThisWeekSummaryEntity> _processThisWeeksTrades(
    List<RecentTradeApiModel> trades,
  ) {
    final Map<int, double> dailyPnlMap = {};

    final now = DateTime.now();
    DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    startOfWeek = DateTime(
      startOfWeek.year,
      startOfWeek.month,
      startOfWeek.day,
    );

    for (int i = 0; i < 7; i++) {
      dailyPnlMap[i + 1] = 0.0;
    }

    for (var trade in trades) {
      final tradeDate = trade.date;
      dailyPnlMap[tradeDate.weekday] =
          (dailyPnlMap[tradeDate.weekday] ?? 0.0) + trade.pnl;
    }

    final List<ThisWeekSummaryEntity> summaries = [];
    for (int i = 0; i < 7; i++) {
      final currentDay = startOfWeek.add(Duration(days: i));
      final dayOfWeekIndex = currentDay.weekday;
      final pnl = dailyPnlMap[dayOfWeekIndex] ?? 0.0;
      summaries.add(
        ThisWeekSummaryEntity(dayIndex: i + 1, pnl: pnl, isProfit: pnl >= 0),
      );
    }
    return summaries;
  }
}
