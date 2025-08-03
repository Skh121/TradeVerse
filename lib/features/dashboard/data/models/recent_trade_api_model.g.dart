// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recent_trade_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecentTradeApiModel _$RecentTradeApiModelFromJson(Map<String, dynamic> json) =>
    RecentTradeApiModel(
      ticker: json['ticker'] as String,
      type: json['type'] as String,
      statusModel: json['status'] as String?,
      pnl: (json['pnl'] as num).toDouble(),
      date: DateTime.parse(json['date'] as String),
    );

Map<String, dynamic> _$RecentTradeApiModelToJson(
        RecentTradeApiModel instance) =>
    <String, dynamic>{
      'ticker': instance.ticker,
      'type': instance.type,
      'pnl': instance.pnl,
      'date': instance.date.toIso8601String(),
      'status': instance.statusModel,
    };
