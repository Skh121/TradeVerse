import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:tradeverse/core/error/failure.dart';
import 'package:tradeverse/features/trade/domain/entity/trade_entity.dart';
import 'package:tradeverse/features/trade/domain/repository/trade_repository.dart';

/// Parameters for the [UpdateTradeUseCase] use case.
class UpdateTradeUseCaseParams extends Equatable {
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

  const UpdateTradeUseCaseParams({
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
  List<Object?> get props => [
    id,
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
    chartScreenshotFile,
    clearChartScreenshot,
  ];
}

/// Use case for updating an existing trade.
class UpdateTradeUseCase {
  final ITradeRepository repository;

  UpdateTradeUseCase(this.repository);

  Future<Either<Failure, TradeEntity>> call(
    UpdateTradeUseCaseParams params,
  ) async {
    return await repository.updateTrade(
      id: params.id,
      symbol: params.symbol,
      status: params.status,
      assetClass: params.assetClass,
      tradeDirection: params.tradeDirection,
      entryDate: params.entryDate,
      entryPrice: params.entryPrice,
      positionSize: params.positionSize,
      exitDate: params.exitDate,
      exitPrice: params.exitPrice,
      stopLoss: params.stopLoss,
      takeProfit: params.takeProfit,
      fees: params.fees,
      tags: params.tags,
      notes: params.notes,
      chartScreenshotFile: params.chartScreenshotFile,
      clearChartScreenshot: params.clearChartScreenshot,
    );
  }
}
