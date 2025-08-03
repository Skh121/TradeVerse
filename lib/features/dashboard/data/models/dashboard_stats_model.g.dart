// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_stats_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DashboardStatsModel _$DashboardStatsModelFromJson(Map<String, dynamic> json) =>
    DashboardStatsModel(
      totalPlModel: (json['totalPL'] as num).toDouble(),
      equityCurveModel: (json['equityCurve'] as List<dynamic>)
          .map((e) => EquityCurveSpotModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      thisWeeksTradesRaw: (json['thisWeeksTrades'] as List<dynamic>)
          .map((e) => RecentTradeApiModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      recentTradesModel: (json['recentTrades'] as List<dynamic>)
          .map((e) => RecentTradeApiModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DashboardStatsModelToJson(
        DashboardStatsModel instance) =>
    <String, dynamic>{
      'totalPL': instance.totalPlModel,
      'equityCurve': instance.equityCurveModel,
      'thisWeeksTrades': instance.thisWeeksTradesRaw,
      'recentTrades': instance.recentTradesModel,
    };
