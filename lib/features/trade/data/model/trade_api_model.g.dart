// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trade_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TradeModel _$TradeModelFromJson(Map<String, dynamic> json) => TradeModel(
      idModel: json['_id'] as String,
      userIdModel: json['user'] as String,
      symbolModel: json['symbol'] as String,
      statusModel: json['status'] as String,
      assetClassModel: json['assetClass'] as String,
      tradeDirectionModel: json['tradeDirection'] as String,
      entryDateModel: DateTime.parse(json['entryDate'] as String),
      entryPriceModel: (json['entryPrice'] as num).toDouble(),
      positionSizeModel: (json['positionSize'] as num).toInt(),
      exitDateModel: json['exitDate'] == null
          ? null
          : DateTime.parse(json['exitDate'] as String),
      exitPriceModel: (json['exitPrice'] as num?)?.toDouble(),
      stopLossModel: (json['stopLoss'] as num?)?.toDouble(),
      takeProfitModel: (json['takeProfit'] as num?)?.toDouble(),
      feesModel: (json['fees'] as num).toDouble(),
      tagsModel:
          (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
      notesModel: json['notes'] as String?,
      chartScreenshotUrlModel: json['chartScreenshotUrl'] as String?,
      rMultipleModel: (json['rMultiple'] as num?)?.toDouble(),
      createdAtModel: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAtModel: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$TradeModelToJson(TradeModel instance) =>
    <String, dynamic>{
      '_id': instance.idModel,
      'user': instance.userIdModel,
      'symbol': instance.symbolModel,
      'status': instance.statusModel,
      'assetClass': instance.assetClassModel,
      'tradeDirection': instance.tradeDirectionModel,
      'entryDate': instance.entryDateModel.toIso8601String(),
      'entryPrice': instance.entryPriceModel,
      'positionSize': instance.positionSizeModel,
      'exitDate': instance.exitDateModel?.toIso8601String(),
      'exitPrice': instance.exitPriceModel,
      'stopLoss': instance.stopLossModel,
      'takeProfit': instance.takeProfitModel,
      'fees': instance.feesModel,
      'tags': instance.tagsModel,
      'notes': instance.notesModel,
      'chartScreenshotUrl': instance.chartScreenshotUrlModel,
      'rMultiple': instance.rMultipleModel,
      'createdAt': instance.createdAtModel?.toIso8601String(),
      'updatedAt': instance.updatedAtModel?.toIso8601String(),
    };

PaginatedTradesModel _$PaginatedTradesModelFromJson(
        Map<String, dynamic> json) =>
    PaginatedTradesModel(
      tradesModel: (json['trades'] as List<dynamic>)
          .map((e) => TradeModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      currentPageModel: (json['currentPage'] as num).toInt(),
      totalPagesModel: (json['totalPages'] as num).toInt(),
      totalTradesModel: (json['totalTrades'] as num).toInt(),
    );

Map<String, dynamic> _$PaginatedTradesModelToJson(
        PaginatedTradesModel instance) =>
    <String, dynamic>{
      'trades': instance.tradesModel,
      'currentPage': instance.currentPageModel,
      'totalPages': instance.totalPagesModel,
      'totalTrades': instance.totalTradesModel,
    };
