// lib/features/trade/presentation/bloc/trade_event.dart

import 'dart:io';
import 'package:equatable/equatable.dart';

/// Base class for all Trade events.
abstract class TradeEvent extends Equatable {
  const TradeEvent();

  @override
  List<Object> get props => [];
}

/// Event to trigger fetching all trades.
class FetchAllTrades extends TradeEvent {
  final int page;
  final int limit;

  const FetchAllTrades({this.page = 1, this.limit = 10});

  @override
  List<Object> get props => [page, limit];
}

/// Event to trigger fetching a single trade by ID.
class FetchTradeById extends TradeEvent {
  final String id;

  const FetchTradeById({required this.id});

  @override
  List<Object> get props => [id];
}

/// Event to trigger creating a new trade.
class CreateTradeEvent extends TradeEvent {
  final String symbol;
  final String assetClass;
  final String tradeDirection;
  final DateTime entryDate;
  final double entryPrice;
  final int positionSize;
  final DateTime? exitDate;
  final double? exitPrice;
  final double? stopLoss;
  final double? takeProfit;
  final double fees;
  final List<String> tags;
  final String? notes;
  final File? chartScreenshotFile;

  const CreateTradeEvent({
    required this.symbol,
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
    this.chartScreenshotFile,
  });

  @override
  List<Object> get props => [
    symbol,
    assetClass,
    tradeDirection,
    entryDate,
    entryPrice,
    positionSize,
    exitDate ?? '',
    exitPrice ?? 0.0,
    stopLoss ?? 0.0,
    takeProfit ?? 0.0,
    fees,
    tags,
    notes ?? '',
    chartScreenshotFile ?? '',
  ];
}

/// Event to trigger updating an existing trade.
class UpdateTradeEvent extends TradeEvent {
  final String id;
  final String? symbol;
  final String? status;
  final String? assetClass;
  final String? tradeDirection;
  final DateTime? entryDate;
  final double? entryPrice;
  final int? positionSize;
  final DateTime? exitDate;
  final double? exitPrice;
  final double? stopLoss;
  final double? takeProfit;
  final double? fees;
  final List<String>? tags;
  final String? notes;
  final File? chartScreenshotFile;
  final bool clearChartScreenshot;

  const UpdateTradeEvent({
    required this.id,
    this.symbol,
    this.status,
    this.assetClass,
    this.tradeDirection,
    this.entryDate,
    this.entryPrice,
    this.positionSize,
    this.exitDate,
    this.exitPrice,
    this.stopLoss,
    this.takeProfit,
    this.fees,
    this.tags,
    this.notes,
    this.chartScreenshotFile,
    this.clearChartScreenshot = false,
  });

  @override
  List<Object> get props => [
    id,
    symbol ?? '',
    status ?? '',
    assetClass ?? '',
    tradeDirection ?? '',
    entryDate ?? '',
    entryPrice ?? 0.0,
    positionSize ?? 0,
    exitDate ?? '',
    exitPrice ?? 0.0,
    stopLoss ?? 0.0,
    takeProfit ?? 0.0,
    fees ?? 0.0,
    tags ?? [],
    notes ?? '',
    chartScreenshotFile ?? '',
    clearChartScreenshot,
  ];
}

/// Event to trigger deleting a trade.
class DeleteTradeEvent extends TradeEvent {
  final String id;

  const DeleteTradeEvent({required this.id});

  @override
  List<Object> get props => [id];
}
