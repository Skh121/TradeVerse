import 'package:equatable/equatable.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tradeverse/app/constant/hive/hive_table_constant.dart';
import 'package:tradeverse/features/dashboard/domain/entity/dashboard_stats_entity.dart';
import 'package:tradeverse/features/dashboard/domain/entity/recent_trade_entity.dart';
import 'package:tradeverse/features/dashboard/domain/entity/this_week_summary_entity.dart';

part 'dashboard_hive_models.g.dart';

class FlSpotAdapter extends TypeAdapter<FlSpot> {
  @override
  final int typeId = 100;

  @override
  FlSpot read(BinaryReader reader) {
    final x = reader.readDouble();
    final y = reader.readDouble();
    return FlSpot(x, y);
  }

  @override
  void write(BinaryWriter writer, FlSpot obj) {
    writer.writeDouble(obj.x);
    writer.writeDouble(obj.y);
  }
}


@HiveType(typeId: HiveTableConstant.recentTradeTableId)
class RecentTradeHiveModel extends Equatable {
  @HiveField(0)
  final String ticker;
  @HiveField(1)
  final String type;
  @HiveField(2)
  final String status;
  @HiveField(3)
  final double pnl;
  @HiveField(4)
  final DateTime date;

  const RecentTradeHiveModel({
    required this.ticker,
    required this.type,
    required this.status,
    required this.pnl,
    required this.date,
  });

  factory RecentTradeHiveModel.fromEntity(RecentTradeEntity entity) {
    return RecentTradeHiveModel(
      ticker: entity.ticker,
      type: entity.type,
      status: entity.status,
      pnl: entity.pnl,
      date: entity.date,
    );
  }

  RecentTradeEntity toEntity() {
    return RecentTradeEntity(
      ticker: ticker,
      type: type,
      status: status,
      pnl: pnl,
      date: date,
    );
  }

  @override
  List<Object?> get props => [ticker, type, status, pnl, date];
}

@HiveType(typeId: HiveTableConstant.thisWeekSummaryTableId)
class ThisWeekSummaryHiveModel extends Equatable {
  @HiveField(0)
  final int dayIndex;
  @HiveField(1)
  final double pnl;
  @HiveField(2)
  final bool isProfit;

  const ThisWeekSummaryHiveModel({
    required this.dayIndex,
    required this.pnl,
    required this.isProfit,
  });

  factory ThisWeekSummaryHiveModel.fromEntity(ThisWeekSummaryEntity entity) {
    return ThisWeekSummaryHiveModel(
      dayIndex: entity.dayIndex,
      pnl: entity.pnl,
      isProfit: entity.isProfit,
    );
  }

  ThisWeekSummaryEntity toEntity() {
    return ThisWeekSummaryEntity(
      dayIndex: dayIndex,
      pnl: pnl,
      isProfit: isProfit,
    );
  }

  @override
  List<Object?> get props => [dayIndex, pnl, isProfit];
}

@HiveType(typeId: HiveTableConstant.dashboardStatsTableId)
class DashboardStatsHiveModel extends Equatable {
  @HiveField(0)
  final double totalPL;
  @HiveField(1)
  final List<FlSpot> equityCurve;
  @HiveField(2)
  final List<ThisWeekSummaryHiveModel> thisWeeksSummaries;
  @HiveField(3)
  final List<RecentTradeHiveModel> recentTrades;

  const DashboardStatsHiveModel({
    required this.totalPL,
    required this.equityCurve,
    required this.thisWeeksSummaries,
    required this.recentTrades,
  });

  factory DashboardStatsHiveModel.fromEntity(DashboardStatsEntity entity) {
    return DashboardStatsHiveModel(
      totalPL: entity.totalPL,
      equityCurve: entity.equityCurve,
      thisWeeksSummaries: entity.thisWeeksSummaries
          .map((e) => ThisWeekSummaryHiveModel.fromEntity(e))
          .toList(),
      recentTrades: entity.recentTrades
          .map((e) => RecentTradeHiveModel.fromEntity(e))
          .toList(),
    );
  }

  DashboardStatsEntity toEntity() {
    return DashboardStatsEntity(
      totalPL: totalPL,
      equityCurve: equityCurve,
      thisWeeksSummaries: thisWeeksSummaries.map((e) => e.toEntity()).toList(),
      recentTrades: recentTrades.map((e) => e.toEntity()).toList(),
    );
  }

  @override
  List<Object?> get props => [totalPL, equityCurve, thisWeeksSummaries, recentTrades];
}
