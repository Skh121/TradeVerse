import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:tradeverse/core/error/failure.dart';
import 'package:tradeverse/features/trade/domain/entity/trade_entity.dart';
import 'package:tradeverse/features/trade/domain/use_case/update_trade_use_case.dart';
import 'package:tradeverse/features/trade/domain/repository/trade_repository.dart';

class MockTradeRepository extends Mock implements ITradeRepository {}

void main() {
  late MockTradeRepository mockRepository;
  late UpdateTradeUseCase useCase;

  const tId = 'trade123';
  final tFile = File('test/resources/sample_chart.png');

  final tParams = UpdateTradeUseCaseParams(
    id: tId,
    symbol: 'AAPL',
    status: 'closed',
    assetClass: 'Equity',
    tradeDirection: 'long',
    entryDate: DateTime.parse('2023-01-01'),
    entryPrice: 150.0,
    positionSize: 10,
    exitDate: DateTime.parse('2023-01-10'),
    exitPrice: 160.0,
    stopLoss: 145.0,
    takeProfit: 170.0,
    fees: 5.0,
    tags: ['tech', 'apple'],
    notes: 'Updated trade notes',
    chartScreenshotFile: tFile,
    clearChartScreenshot: true,
  );

  final tTrade = TradeEntity(
    id: tId,
    userId: 'user1',
    symbol: 'AAPL',
    status: 'closed',
    assetClass: 'Equity',
    tradeDirection: 'long',
    entryDate: DateTime.parse('2023-01-01'),
    entryPrice: 150.0,
    positionSize: 10,
    exitDate: DateTime.parse('2023-01-10'),
    exitPrice: 160.0,
    stopLoss: 145.0,
    takeProfit: 170.0,
    fees: 5.0,
    tags: ['tech', 'apple'],
  );

  setUp(() {
    mockRepository = MockTradeRepository();
    useCase = UpdateTradeUseCase(mockRepository);
  });

  group('UpdateTradeUseCaseParams', () {
    test('props contains all fields', () {
      expect(tParams.props, [
        tId,
        'AAPL',
        'closed',
        'Equity',
        'long',
        DateTime.parse('2023-01-01'),
        150.0,
        10,
        DateTime.parse('2023-01-10'),
        160.0,
        145.0,
        170.0,
        5.0,
        ['tech', 'apple'],
        'Updated trade notes',
        tFile,
        true,
      ]);
    });
  });

  group('UpdateTradeUseCase', () {
    test('should return updated TradeEntity when update succeeds', () async {
      // Arrange
      when(
        () => mockRepository.updateTrade(
          id: tParams.id,
          symbol: tParams.symbol,
          status: tParams.status,
          assetClass: tParams.assetClass,
          tradeDirection: tParams.tradeDirection,
          entryDate: tParams.entryDate,
          entryPrice: tParams.entryPrice,
          positionSize: tParams.positionSize,
          exitDate: tParams.exitDate,
          exitPrice: tParams.exitPrice,
          stopLoss: tParams.stopLoss,
          takeProfit: tParams.takeProfit,
          fees: tParams.fees,
          tags: tParams.tags,
          notes: tParams.notes,
          chartScreenshotFile: tParams.chartScreenshotFile,
          clearChartScreenshot: tParams.clearChartScreenshot,
        ),
      ).thenAnswer((_) async => Right(tTrade));

      // Act
      final result = await useCase.call(tParams);

      // Assert
      expect(result, Right(tTrade));
      verify(
        () => mockRepository.updateTrade(
          id: tParams.id,
          symbol: tParams.symbol,
          status: tParams.status,
          assetClass: tParams.assetClass,
          tradeDirection: tParams.tradeDirection,
          entryDate: tParams.entryDate,
          entryPrice: tParams.entryPrice,
          positionSize: tParams.positionSize,
          exitDate: tParams.exitDate,
          exitPrice: tParams.exitPrice,
          stopLoss: tParams.stopLoss,
          takeProfit: tParams.takeProfit,
          fees: tParams.fees,
          tags: tParams.tags,
          notes: tParams.notes,
          chartScreenshotFile: tParams.chartScreenshotFile,
          clearChartScreenshot: tParams.clearChartScreenshot,
        ),
      ).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return Failure when update fails', () async {
      // Arrange
      final failure = ServerFailure(message: 'Update failed');
      when(
        () => mockRepository.updateTrade(
          id: tParams.id,
          symbol: tParams.symbol,
          status: tParams.status,
          assetClass: tParams.assetClass,
          tradeDirection: tParams.tradeDirection,
          entryDate: tParams.entryDate,
          entryPrice: tParams.entryPrice,
          positionSize: tParams.positionSize,
          exitDate: tParams.exitDate,
          exitPrice: tParams.exitPrice,
          stopLoss: tParams.stopLoss,
          takeProfit: tParams.takeProfit,
          fees: tParams.fees,
          tags: tParams.tags,
          notes: tParams.notes,
          chartScreenshotFile: tParams.chartScreenshotFile,
          clearChartScreenshot: tParams.clearChartScreenshot,
        ),
      ).thenAnswer((_) async => Left(failure));

      // Act
      final result = await useCase.call(tParams);

      // Assert
      expect(result, Left(failure));
      verify(
        () => mockRepository.updateTrade(
          id: tParams.id,
          symbol: tParams.symbol,
          status: tParams.status,
          assetClass: tParams.assetClass,
          tradeDirection: tParams.tradeDirection,
          entryDate: tParams.entryDate,
          entryPrice: tParams.entryPrice,
          positionSize: tParams.positionSize,
          exitDate: tParams.exitDate,
          exitPrice: tParams.exitPrice,
          stopLoss: tParams.stopLoss,
          takeProfit: tParams.takeProfit,
          fees: tParams.fees,
          tags: tParams.tags,
          notes: tParams.notes,
          chartScreenshotFile: tParams.chartScreenshotFile,
          clearChartScreenshot: tParams.clearChartScreenshot,
        ),
      ).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
