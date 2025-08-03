import 'dart:io'; // For File
import 'package:dartz/dartz.dart'; // For Either
import 'package:tradeverse/core/error/failure.dart';
import 'package:tradeverse/features/trade/domain/entity/trade_entity.dart';

/// Abstract interface for the Trade Repository.
/// Defines the contract for trade-related operations.
abstract class ITradeRepository {
  /// Creates a new trade.
  Future<Either<Failure, TradeEntity>> createTrade({
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
    File? chartScreenshotFile, // Optional file for upload
  });

  /// Fetches all trades for the logged-in user with pagination.
  Future<Either<Failure, PaginatedTradesEntity>> getAllTrades({
    int page = 1,
    int limit = 10,
  });

  /// Fetches a single trade by its ID.
  Future<Either<Failure, TradeEntity>> getTradeById(String id);

  /// Updates an existing trade.
  Future<Either<Failure, TradeEntity>> updateTrade({
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
    File? chartScreenshotFile, // Optional new file for upload
    bool clearChartScreenshot =
        false, // To explicitly clear the existing screenshot
  });

  /// Deletes a trade by its ID.
  Future<Either<Failure, String>> deleteTrade(
    String id,
  ); // Returns a message string on success
}
