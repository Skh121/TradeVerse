// lib/features/trade/domain/entities/trade_entity.dart

import 'package:equatable/equatable.dart';

/// Represents a single trade entry in the domain layer.
class TradeEntity extends Equatable {
  final String id;
  final String userId; // Mapped from 'user' in backend
  final String symbol;
  final String status; // "open" or "closed"
  final String assetClass;
  final String tradeDirection; // "long" or "short"
  final DateTime entryDate;
  final double entryPrice;
  final int positionSize;
  final DateTime? exitDate;
  final double? exitPrice;
  final double? stopLoss; // Optional
  final double? takeProfit; // Optional
  final double fees;
  final List<String> tags;
  final String? notes;
  final String? chartScreenshotUrl; // URL of the screenshot
  final double? rMultiple; // Calculated on backend
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const TradeEntity({
    required this.id,
    required this.userId,
    required this.symbol,
    required this.status,
    required this.assetClass,
    required this.tradeDirection,
    required this.entryDate,
    required this.entryPrice,
    required this.positionSize,
    this.exitDate,
    this.exitPrice,
    this.stopLoss,
    this.takeProfit,
    required this.fees,
    required this.tags,
    this.notes,
    this.chartScreenshotUrl,
    this.rMultiple,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    symbol,
    status,
    assetClass,
    tradeDirection,
    entryDate,
    entryPrice,
    positionSize,
    exitDate,
    exitPrice,
    stopLoss,
    takeProfit,
    fees,
    tags,
    notes,
    chartScreenshotUrl,
    rMultiple,
    createdAt,
    updatedAt,
  ];

  // Helper for PnL calculation (if needed on frontend, otherwise backend provides it implicitly)
  double get pnl {
    if (status == 'closed' && exitPrice != null) {
      double grossPnl = 0.0;
      if (tradeDirection == 'long') {
        grossPnl = (exitPrice! - entryPrice) * positionSize;
      } else if (tradeDirection == 'short') {
        grossPnl = (entryPrice - exitPrice!) * positionSize;
      }
      return grossPnl - fees;
    }
    return 0.0; // PnL is 0 for open trades or if exit details are missing
  }

  // Helper to create a copy for updates
  TradeEntity copyWith({
    String? id,
    String? userId,
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
    String? chartScreenshotUrl,
    double? rMultiple,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TradeEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      symbol: symbol ?? this.symbol,
      status: status ?? this.status,
      assetClass: assetClass ?? this.assetClass,
      tradeDirection: tradeDirection ?? this.tradeDirection,
      entryDate: entryDate ?? this.entryDate,
      entryPrice: entryPrice ?? this.entryPrice,
      positionSize: positionSize ?? this.positionSize,
      exitDate: exitDate ?? this.exitDate,
      exitPrice: exitPrice ?? this.exitPrice,
      stopLoss: stopLoss ?? this.stopLoss,
      takeProfit: takeProfit ?? this.takeProfit,
      fees: fees ?? this.fees,
      tags: tags ?? this.tags,
      notes: notes ?? this.notes,
      chartScreenshotUrl: chartScreenshotUrl ?? this.chartScreenshotUrl,
      rMultiple: rMultiple ?? this.rMultiple,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

/// Represents a paginated list of trades.
class PaginatedTradesEntity extends Equatable {
  final List<TradeEntity> trades;
  final int currentPage;
  final int totalPages;
  final int totalTrades;

  const PaginatedTradesEntity({
    required this.trades,
    required this.currentPage,
    required this.totalPages,
    required this.totalTrades,
  });

  @override
  List<Object> get props => [trades, currentPage, totalPages, totalTrades];
}
