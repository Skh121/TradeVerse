import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:tradeverse/core/error/failure.dart';
import 'package:tradeverse/features/trade/domain/entity/trade_entity.dart';
import 'package:tradeverse/features/trade/domain/use_case/get_trade_by_id_use_case.dart';
import 'package:tradeverse/features/trade/domain/repository/trade_repository.dart';

class MockTradeRepository extends Mock implements ITradeRepository {}

void main() {
  late MockTradeRepository mockRepository;
  late GetTradeByIdUseCase useCase;

  const tId = 'trade123';
  final tParams = GetTradeByIdUseCaseParams(id: tId);

  final tTrade = TradeEntity(
    id: tId,
    userId: 'user1',
    symbol: 'GOOG',
    status: 'closed',
    assetClass: 'Equity',
    tradeDirection: 'long',
    entryDate: DateTime.parse('2023-01-01'),
    entryPrice: 100.0,
    positionSize: 5,
    exitDate: DateTime.parse('2023-01-10'),
    exitPrice: 110.0,
    fees: 2.0,
    tags: ['tech', 'growth'],
  );

  setUp(() {
    mockRepository = MockTradeRepository();
    useCase = GetTradeByIdUseCase(mockRepository);
  });

  group('GetTradeByIdUseCaseParams', () {
    test('props contains id', () {
      expect(tParams.props, [tId]);
    });
  });

  group('GetTradeByIdUseCase', () {
    test('should return TradeEntity when successful', () async {
      // Arrange
      when(
        () => mockRepository.getTradeById(tId),
      ).thenAnswer((_) async => Right(tTrade));

      // Act
      final result = await useCase.call(tParams);

      // Assert
      expect(result, Right(tTrade));
      verify(() => mockRepository.getTradeById(tId)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return Failure when error occurs', () async {
      // Arrange
      final failure = ServerFailure(message: 'Trade not found');
      when(
        () => mockRepository.getTradeById(tId),
      ).thenAnswer((_) async => Left(failure));

      // Act
      final result = await useCase.call(tParams);

      // Assert
      expect(result, Left(failure));
      verify(() => mockRepository.getTradeById(tId)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
