import 'dart:io';
import 'package:tradeverse/core/network/hive_service.dart';
import 'package:tradeverse/features/trade/data/data_source/trade_data_source.dart';
import 'package:tradeverse/features/trade/data/model/paginated_trade_hive_model.dart';
import 'package:tradeverse/features/trade/domain/entity/trade_entity.dart';

class TradeLocalDataSource implements ITradeDataSource {
  final HiveService _hiveService;

  static const String _tradeListCacheKey = 'TRADE_LIST_CACHE';

  TradeLocalDataSource(this._hiveService);

  @override
  Future<void> cacheTradeList(PaginatedTradesEntity data) async {
    final paginatedHiveModel = PaginatedTradeHiveModel.fromEntity(data);
    await _hiveService.paginatedTradeBox.put(
      _tradeListCacheKey,
      paginatedHiveModel,
    );
  }

  @override
  Future<PaginatedTradesEntity> getCachedTradeList() async {
    final cachedData = _hiveService.paginatedTradeBox.get(_tradeListCacheKey);
    if (cachedData == null) {
      throw Exception("No cached trade list found");
    }
    return cachedData.toEntity();
  }

  // The following methods are not supported by local data source
  @override
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
  }) {
    throw UnimplementedError('Local data source does not support createTrade');
  }

  @override
  Future<PaginatedTradesEntity> getAllTrades({int page = 1, int limit = 10}) {
    throw UnimplementedError('Local data source does not support getAllTrades');
  }

  @override
  Future<TradeEntity> getTradeById(String id) {
    throw UnimplementedError('Local data source does not support getTradeById');
  }

  @override
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
    bool clearChartScreenshot = false,
  }) {
    throw UnimplementedError('Local data source does not support updateTrade');
  }

  @override
  Future<String> deleteTrade(String id) {
    throw UnimplementedError('Local data source does not support deleteTrade');
  }
}
