import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:tradeverse/core/error/failure.dart';
import 'package:tradeverse/features/trade/domain/entity/trade_entity.dart';
import 'package:tradeverse/features/trade/domain/use_case/get_all_trades_use_case.dart';
import 'package:tradeverse/features/trade/domain/repository/trade_repository.dart';

class MockTradeRepository extends Mock implements ITradeRepository {}

void main() {
  late MockTradeRepository mockRepository;
  late GetAllTradesUseCase useCase;

  const tPage = 1;
  const tLimit = 10;

  final tParams = GetAllTradesUseCaseParams(page: tPage, limit: tLimit);

  final tTrade = TradeEntity(
    id: 'trade1',
    userId: 'user1',
    symbol: 'AAPL',
    status: 'open',
    assetClass: 'Equity',
    tradeDirection: 'long',
    entryDate: DateTime.parse('2023-01-01'),
    entryPrice: 150.0,
    positionSize: 10,
    fees: 1.0,
    tags: ['tag1', 'tag2'],
  );

  final tPaginatedTrades = PaginatedTradesEntity(
    trades: [tTrade],
    currentPage: tPage,
    totalPages: 5,
    totalTrades: 50,
  );

  setUp(() {
    mockRepository = MockTradeRepository();
    useCase = GetAllTradesUseCase(mockRepository);
  });

  group('GetAllTradesUseCaseParams', () {
    test('props contains page and limit', () {
      expect(tParams.props, [tPage, tLimit]);
    });

    test('default values are set correctly', () {
      final defaultParams = GetAllTradesUseCaseParams();
      expect(defaultParams.page, 1);
      expect(defaultParams.limit, 10);
    });
  });

  group('GetAllTradesUseCase', () {
    test('should return PaginatedTradesEntity on success', () async {
      // Arrange
      when(
        () => mockRepository.getAllTrades(page: tPage, limit: tLimit),
      ).thenAnswer((_) async => Right(tPaginatedTrades));

      // Act
      final result = await useCase.call(tParams);

      // Assert
      expect(result, Right(tPaginatedTrades));
      verify(
        () => mockRepository.getAllTrades(page: tPage, limit: tLimit),
      ).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return Failure on error', () async {
      // Arrange
      final failure = ServerFailure(message: 'Unable to fetch trades');
      when(
        () => mockRepository.getAllTrades(page: tPage, limit: tLimit),
      ).thenAnswer((_) async => Left(failure));

      // Act
      final result = await useCase.call(tParams);

      // Assert
      expect(result, Left(failure));
      verify(
        () => mockRepository.getAllTrades(page: tPage, limit: tLimit),
      ).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
