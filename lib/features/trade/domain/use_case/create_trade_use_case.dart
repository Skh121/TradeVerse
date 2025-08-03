import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:tradeverse/core/error/failure.dart';
import 'package:tradeverse/features/trade/domain/entity/trade_entity.dart';
import 'package:tradeverse/features/trade/domain/repository/trade_repository.dart';

class CreateTradeUseCaseParams extends Equatable {
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

  const CreateTradeUseCaseParams({
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
  List<Object?> get props => [
    symbol,
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
  ];
}

/// Use case for creating a new trade.
class CreateTradeUseCase {
  final ITradeRepository repository;

  CreateTradeUseCase(this.repository);

  Future<Either<Failure, TradeEntity>> call(CreateTradeUseCaseParams params) async {
    return await repository.createTrade(
      symbol: params.symbol,
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
    );
  }
}
