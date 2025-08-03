import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:tradeverse/core/error/failure.dart';
import 'package:tradeverse/features/trade/domain/entity/trade_entity.dart';
import 'package:tradeverse/features/trade/domain/repository/trade_repository.dart';
import 'package:tradeverse/features/trade/domain/use_case/create_trade_use_case.dart';

class MockTradeRepository extends Mock implements ITradeRepository {}

void main() {
  late MockTradeRepository mockRepository;
  late CreateTradeUseCase useCase;

  final tFile = File('path/to/file.png');
  final tParams = CreateTradeUseCaseParams(
    symbol: 'AAPL',
    assetClass: 'Equity',
    tradeDirection: 'long',
    entryDate: DateTime(2024, 1, 1),
    entryPrice: 100.0,
    positionSize: 5,
    exitDate: DateTime(2024, 1, 10),
    exitPrice: 110.0,
    stopLoss: 90.0,
    takeProfit: 120.0,
    fees: 5.0,
    tags: ['tag1', 'tag2'],
    notes: 'note',
    chartScreenshotFile: tFile,
  );

  final tTrade = TradeEntity(
    id: 'trade1',
    userId: 'user1',
    symbol: 'AAPL',
    status: 'closed',
    assetClass: 'Equity',
    tradeDirection: 'long',
    entryDate: DateTime(2024, 1, 1),
    entryPrice: 100.0,
    positionSize: 5,
    exitDate: DateTime(2024, 1, 10),
    exitPrice: 110.0,
    stopLoss: 90.0,
    takeProfit: 120.0,
    fees: 5.0,
    tags: ['tag1', 'tag2'],
    notes: 'note',
    chartScreenshotUrl: 'url',
    rMultiple: 2.0,
    createdAt: DateTime(2024, 1, 1),
    updatedAt: DateTime(2024, 1, 10),
  );

  setUp(() {
    mockRepository = MockTradeRepository();
    useCase = CreateTradeUseCase(mockRepository);
  });

  group('CreateTradeUseCaseParams', () {
    test('props contains all fields', () {
      expect(tParams.props, [
        'AAPL',
        'Equity',
        'long',
        DateTime(2024, 1, 1),
        100.0,
        5,
        DateTime(2024, 1, 10),
        110.0,
        90.0,
        120.0,
        5.0,
        ['tag1', 'tag2'],
        'note',
        tFile,
      ]);
    });
  });

  group('CreateTradeUseCase', () {
    test(
      'should forward call to repository and return TradeEntity on success',
      () async {
        when(
          () => mockRepository.createTrade(
            symbol: tParams.symbol,
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
          ),
        ).thenAnswer((_) async => Right(tTrade));

        final result = await useCase.call(tParams);

        expect(result, Right(tTrade));
        verify(
          () => mockRepository.createTrade(
            symbol: tParams.symbol,
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
          ),
        ).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );

    test('should return Failure when repository fails', () async {
      final failure = ServerFailure(message: 'Failed to create trade');
      when(
        () => mockRepository.createTrade(
          symbol: any(named: 'symbol'),
          assetClass: any(named: 'assetClass'),
          tradeDirection: any(named: 'tradeDirection'),
          entryDate: any(named: 'entryDate'),
          entryPrice: any(named: 'entryPrice'),
          positionSize: any(named: 'positionSize'),
          exitDate: any(named: 'exitDate'),
          exitPrice: any(named: 'exitPrice'),
          stopLoss: any(named: 'stopLoss'),
          takeProfit: any(named: 'takeProfit'),
          fees: any(named: 'fees'),
          tags: any(named: 'tags'),
          notes: any(named: 'notes'),
          chartScreenshotFile: any(named: 'chartScreenshotFile'),
        ),
      ).thenAnswer((_) async => Left(failure));

      final result = await useCase.call(tParams);

      expect(result, Left(failure));
      verify(
        () => mockRepository.createTrade(
          symbol: any(named: 'symbol'),
          assetClass: any(named: 'assetClass'),
          tradeDirection: any(named: 'tradeDirection'),
          entryDate: any(named: 'entryDate'),
          entryPrice: any(named: 'entryPrice'),
          positionSize: any(named: 'positionSize'),
          exitDate: any(named: 'exitDate'),
          exitPrice: any(named: 'exitPrice'),
          stopLoss: any(named: 'stopLoss'),
          takeProfit: any(named: 'takeProfit'),
          fees: any(named: 'fees'),
          tags: any(named: 'tags'),
          notes: any(named: 'notes'),
          chartScreenshotFile: any(named: 'chartScreenshotFile'),
        ),
      ).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });

  group('TradeEntity', () {
    test('props contains all fields', () {
      expect(tTrade.props, [
        'trade1',
        'user1',
        'AAPL',
        'closed',
        'Equity',
        'long',
        DateTime(2024, 1, 1),
        100.0,
        5,
        DateTime(2024, 1, 10),
        110.0,
        90.0,
        120.0,
        5.0,
        ['tag1', 'tag2'],
        'note',
        'url',
        2.0,
        DateTime(2024, 1, 1),
        DateTime(2024, 1, 10),
      ]);
    });

    test('pnl calculates correctly for long closed trade', () {
      expect(tTrade.pnl, (110.0 - 100.0) * 5 - 5.0);
    });

    test('pnl calculates correctly for short closed trade', () {
      final shortTrade = tTrade.copyWith(
        tradeDirection: 'short',
        entryPrice: 100,
        exitPrice: 90,
      );
      expect(shortTrade.pnl, (100 - 90) * 5 - 5.0);
    });

    test('pnl is 0 for open trade', () {
      final openTrade = tTrade.copyWith(status: 'open');
      expect(openTrade.pnl, 0.0);
    });

    test('copyWith creates updated copy', () {
      final copy = tTrade.copyWith(
        symbol: 'MSFT',
        exitPrice: 115.0,
        notes: 'updated note',
      );
      expect(copy.symbol, 'MSFT');
      expect(copy.exitPrice, 115.0);
      expect(copy.notes, 'updated note');
      expect(copy.id, tTrade.id); // unchanged
    });
  });
}
