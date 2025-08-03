import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:tradeverse/core/error/failure.dart';
import 'package:tradeverse/features/trade/domain/use_case/delete_trade_use_case.dart';
import 'package:tradeverse/features/trade/domain/repository/trade_repository.dart';

class MockTradeRepository extends Mock implements ITradeRepository {}

void main() {
  late MockTradeRepository mockRepository;
  late DeleteTradeUseCase useCase;

  const tId = 'trade123';
  const tParams = DeleteTradeUseCaseParams(id: tId);
  const tSuccessMessage = 'Trade deleted successfully';

  setUp(() {
    mockRepository = MockTradeRepository();
    useCase = DeleteTradeUseCase(mockRepository);
  });

  group('DeleteTradeUseCaseParams', () {
    test('props contains id', () {
      expect(tParams.props, [tId]);
    });
  });

  group('DeleteTradeUseCase', () {
    test('should return success message when deletion succeeds', () async {
      when(
        () => mockRepository.deleteTrade(tId),
      ).thenAnswer((_) async => const Right(tSuccessMessage));

      final result = await useCase.call(tParams);

      expect(result, const Right(tSuccessMessage));
      verify(() => mockRepository.deleteTrade(tId)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return Failure when deletion fails', () async {
      final failure = ServerFailure(message: 'Deletion failed');
      when(
        () => mockRepository.deleteTrade(tId),
      ).thenAnswer((_) async => Left(failure));

      final result = await useCase.call(tParams);

      expect(result, Left(failure));
      verify(() => mockRepository.deleteTrade(tId)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
