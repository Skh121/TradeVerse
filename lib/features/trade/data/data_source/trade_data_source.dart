import 'dart:io';
import 'package:tradeverse/features/trade/domain/entity/trade_entity.dart';

/// Abstract interface for the remote data source for trade operations.
abstract class ITradeDataSource {
  Future<TradeEntity> createTrade({
    required String symbol,
    required String assetClass,
    required String tradeDirection,
    required DateTime entryDate,
    required double entryPrice,
    required int positionSize,
    DateTime? exitDate,
    double? exitPrice,
    double? stopLoss,
    double? takeProfit,
    required double fees,
    required List<String> tags,
    String? notes,
    File? chartScreenshotFile,
  });

  Future<PaginatedTradesEntity> getAllTrades({int page = 1, int limit = 10});

  Future<TradeEntity> getTradeById(String id);

  Future<TradeEntity> updateTrade({
    required String id,
    String? symbol,
    String? status,
    String? assetClass,
    String? tradeDirection,
    DateTime? entryDate,
    double? entryPrice,
    int? positionSize,
    DateTime? exitDate,
    double? exitPrice,
    double? stopLoss,
    double? takeProfit,
    double? fees,
    List<String>? tags,
    String? notes,
    File? chartScreenshotFile,
    bool clearChartScreenshot,
  });

  Future<String> deleteTrade(String id);

  Future<void> cacheTradeList(PaginatedTradesEntity data);
  Future<PaginatedTradesEntity> getCachedTradeList();
}
