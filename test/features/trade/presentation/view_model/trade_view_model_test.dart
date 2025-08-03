// test/features/trade/presentation/bloc/trade_view_model_test.dart
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tradeverse/core/error/failure.dart';
import 'package:tradeverse/features/trade/domain/entity/trade_entity.dart';
import 'package:tradeverse/features/trade/domain/use_case/create_trade_use_case.dart';
import 'package:tradeverse/features/trade/domain/use_case/delete_trade_use_case.dart';
import 'package:tradeverse/features/trade/domain/use_case/get_all_trades_use_case.dart';
import 'package:tradeverse/features/trade/domain/use_case/get_trade_by_id_use_case.dart';
import 'package:tradeverse/features/trade/domain/use_case/update_trade_use_case.dart';
import 'package:tradeverse/features/trade/presentation/view_model/trade_event.dart';
import 'package:tradeverse/features/trade/presentation/view_model/trade_state.dart';
import 'package:tradeverse/features/trade/presentation/view_model/trade_view_model.dart';

// Register fallback classes for mocktail any() calls
class CreateTradeUseCaseParamsFake extends Fake
    implements CreateTradeUseCaseParams {}

class UpdateTradeUseCaseParamsFake extends Fake
    implements UpdateTradeUseCaseParams {}

class DeleteTradeUseCaseParamsFake extends Fake
    implements DeleteTradeUseCaseParams {}

class GetAllTradesUseCaseParamsFake extends Fake
    implements GetAllTradesUseCaseParams {}

class GetTradeByIdUseCaseParamsFake extends Fake
    implements GetTradeByIdUseCaseParams {}

// Mocks for UseCases
class MockCreateTradeUseCase extends Mock implements CreateTradeUseCase {}

class MockGetAllTradesUseCase extends Mock implements GetAllTradesUseCase {}

class MockGetTradeByIdUseCase extends Mock implements GetTradeByIdUseCase {}

class MockUpdateTradeUseCase extends Mock implements UpdateTradeUseCase {}

class MockDeleteTradeUseCase extends Mock implements DeleteTradeUseCase {}

void main() {
  late TradeViewModel bloc;
  late MockCreateTradeUseCase mockCreateTrade;
  late MockGetAllTradesUseCase mockGetAllTrades;
  late MockGetTradeByIdUseCase mockGetTradeById;
  late MockUpdateTradeUseCase mockUpdateTrade;
  late MockDeleteTradeUseCase mockDeleteTrade;

  final testFailure = ServerFailure(message: 'Failure message');

  // Dummy trade entity matching your model
  final dummyTrade = TradeEntity(
    id: '1',
    userId: 'user1',
    symbol: 'AAPL',
    status: 'open',
    assetClass: 'stock',
    tradeDirection: 'long',
    entryDate: DateTime.now(),
    entryPrice: 150.0,
    positionSize: 10,
    exitDate: null,
    exitPrice: null,
    stopLoss: null,
    takeProfit: null,
    fees: 1.0,
    tags: ['tag1'],
    notes: 'note',
    chartScreenshotUrl: null,
    rMultiple: null,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );

  final paginatedTrades = PaginatedTradesEntity(
    trades: [dummyTrade],
    currentPage: 1,
    totalPages: 1,
    totalTrades: 1,
  );

  setUpAll(() {
    registerFallbackValue(CreateTradeUseCaseParamsFake());
    registerFallbackValue(UpdateTradeUseCaseParamsFake());
    registerFallbackValue(DeleteTradeUseCaseParamsFake());
    registerFallbackValue(GetAllTradesUseCaseParamsFake());
    registerFallbackValue(GetTradeByIdUseCaseParamsFake());
  });

  setUp(() {
    mockCreateTrade = MockCreateTradeUseCase();
    mockGetAllTrades = MockGetAllTradesUseCase();
    mockGetTradeById = MockGetTradeByIdUseCase();
    mockUpdateTrade = MockUpdateTradeUseCase();
    mockDeleteTrade = MockDeleteTradeUseCase();

    bloc = TradeViewModel(
      createTrade: mockCreateTrade,
      getAllTrades: mockGetAllTrades,
      getTradeById: mockGetTradeById,
      updateTrade: mockUpdateTrade,
      deleteTrade: mockDeleteTrade,
    );
  });

  group('FetchAllTrades', () {
    blocTest<TradeViewModel, TradeState>(
      'emits [TradeLoading, TradesLoaded] on successful fetch',
      build: () {
        when(
          () => mockGetAllTrades(any()),
        ).thenAnswer((_) async => Right(paginatedTrades));
        return bloc;
      },
      act: (bloc) => bloc.add(const FetchAllTrades(page: 1, limit: 10)),
      expect:
          () => [
            TradeLoading(),
            TradesLoaded(paginatedTrades: paginatedTrades),
          ],
      verify: (_) {
        verify(() => mockGetAllTrades(any())).called(1);
      },
    );

    blocTest<TradeViewModel, TradeState>(
      'emits [TradeLoading, TradeError] on failed fetch',
      build: () {
        when(
          () => mockGetAllTrades(any()),
        ).thenAnswer((_) async => Left(testFailure));
        return bloc;
      },
      act: (bloc) => bloc.add(const FetchAllTrades(page: 1, limit: 10)),
      expect: () => [TradeLoading(), TradeError(message: testFailure.message)],
      verify: (_) {
        verify(() => mockGetAllTrades(any())).called(1);
      },
    );
  });

  group('FetchTradeById', () {
    blocTest<TradeViewModel, TradeState>(
      'emits [TradeLoading, SingleTradeLoaded] on success',
      build: () {
        when(
          () => mockGetTradeById(any()),
        ).thenAnswer((_) async => Right(dummyTrade));
        return bloc;
      },
      act: (bloc) => bloc.add(const FetchTradeById(id: '1')),
      expect: () => [TradeLoading(), SingleTradeLoaded(trade: dummyTrade)],
      verify: (_) {
        verify(() => mockGetTradeById(any())).called(1);
      },
    );

    blocTest<TradeViewModel, TradeState>(
      'emits [TradeLoading, TradeError] on failure',
      build: () {
        when(
          () => mockGetTradeById(any()),
        ).thenAnswer((_) async => Left(testFailure));
        return bloc;
      },
      act: (bloc) => bloc.add(const FetchTradeById(id: '1')),
      expect: () => [TradeLoading(), TradeError(message: testFailure.message)],
      verify: (_) {
        verify(() => mockGetTradeById(any())).called(1);
      },
    );
  });

  group('CreateTradeEvent', () {
    blocTest<TradeViewModel, TradeState>(
      'emits [TradeLoading, TradeOperationSuccess, TradesLoaded] on success',
      build: () {
        when(
          () => mockCreateTrade(any()),
        ).thenAnswer((_) async => Right(dummyTrade));
        when(
          () => mockGetAllTrades(any()),
        ).thenAnswer((_) async => Right(paginatedTrades));
        return bloc;
      },
      act:
          (bloc) => bloc.add(
            CreateTradeEvent(
              symbol: 'AAPL',
              assetClass: 'stock',
              tradeDirection: 'long',
              entryDate: DateTime.now(),
              entryPrice: 150.0,
              positionSize: 10,
              exitDate: null,
              exitPrice: null,
              stopLoss: null,
              takeProfit: null,
              fees: 1.0,
              tags: ['tag1'],
              notes: 'note',
              chartScreenshotFile: null,
            ),
          ),
      expect:
          () => [
            TradeLoading(),
            const TradeOperationSuccess(message: 'Trade created successfully!'),
            TradeLoading(), // add this line to match actual emitted states
            TradesLoaded(paginatedTrades: paginatedTrades),
          ],
      verify: (_) {
        verify(() => mockCreateTrade(any())).called(1);
        verify(() => mockGetAllTrades(any())).called(1);
      },
    );

    blocTest<TradeViewModel, TradeState>(
      'emits [TradeLoading, TradeError] on failure',
      build: () {
        when(
          () => mockCreateTrade(any()),
        ).thenAnswer((_) async => Left(testFailure));
        return bloc;
      },
      act:
          (bloc) => bloc.add(
            CreateTradeEvent(
              symbol: 'AAPL',
              assetClass: 'stock',
              tradeDirection: 'long',
              entryDate: DateTime.now(),
              entryPrice: 150.0,
              positionSize: 10,
              exitDate: null,
              exitPrice: null,
              stopLoss: null,
              takeProfit: null,
              fees: 1.0,
              tags: ['tag1'],
              notes: 'note',
              chartScreenshotFile: null,
            ),
          ),
      expect: () => [TradeLoading(), TradeError(message: testFailure.message)],
      verify: (_) {
        verify(() => mockCreateTrade(any())).called(1);
      },
    );
  });

  group('UpdateTradeEvent', () {
    blocTest<TradeViewModel, TradeState>(
      'emits [TradeLoading, TradeOperationSuccess, TradesLoaded] on success',
      build: () {
        when(
          () => mockUpdateTrade(any()),
        ).thenAnswer((_) async => Right(dummyTrade));
        when(
          () => mockGetAllTrades(any()),
        ).thenAnswer((_) async => Right(paginatedTrades));
        return bloc;
      },
      act:
          (bloc) => bloc.add(
            UpdateTradeEvent(
              id: '1',
              symbol: 'AAPL',
              status: 'closed',
              assetClass: 'stock',
              tradeDirection: 'long',
              entryDate: DateTime.now(),
              entryPrice: 150.0,
              positionSize: 10,
              exitDate: DateTime.now(),
              exitPrice: 160.0,
              stopLoss: 140.0,
              takeProfit: 170.0,
              fees: 1.0,
              tags: ['tag1'],
              notes: 'note',
              chartScreenshotFile: null,
              clearChartScreenshot: false,
            ),
          ),
      expect:
          () => [
            TradeLoading(),
            const TradeOperationSuccess(message: 'Trade updated successfully!'),
            TradeLoading(), // <-- add this line
            TradesLoaded(paginatedTrades: paginatedTrades),
          ],

      verify: (_) {
        verify(() => mockUpdateTrade(any())).called(1);
        verify(() => mockGetAllTrades(any())).called(1);
      },
    );

    blocTest<TradeViewModel, TradeState>(
      'emits [TradeLoading, TradeError] on failure',
      build: () {
        when(
          () => mockUpdateTrade(any()),
        ).thenAnswer((_) async => Left(testFailure));
        return bloc;
      },
      act:
          (bloc) => bloc.add(
            UpdateTradeEvent(
              id: '1',
              symbol: 'AAPL',
              status: 'closed',
              assetClass: 'stock',
              tradeDirection: 'long',
              entryDate: DateTime.now(),
              entryPrice: 150.0,
              positionSize: 10,
              exitDate: DateTime.now(),
              exitPrice: 160.0,
              stopLoss: 140.0,
              takeProfit: 170.0,
              fees: 1.0,
              tags: ['tag1'],
              notes: 'note',
              chartScreenshotFile: null,
              clearChartScreenshot: false,
            ),
          ),
      expect: () => [TradeLoading(), TradeError(message: testFailure.message)],
      verify: (_) {
        verify(() => mockUpdateTrade(any())).called(1);
      },
    );
  });

  group('DeleteTradeEvent', () {
    blocTest<TradeViewModel, TradeState>(
      'emits [TradeLoading, TradeOperationSuccess, TradeLoading, TradesLoaded] on success',
      build: () {
        when(
          () => mockDeleteTrade(any()),
        ).thenAnswer((_) async => Right('Deleted successfully'));
        when(
          () => mockGetAllTrades(any()),
        ).thenAnswer((_) async => Right(paginatedTrades));
        return bloc;
      },
      act: (bloc) => bloc.add(const DeleteTradeEvent(id: '1')),
      expect:
          () => [
            TradeLoading(),
            const TradeOperationSuccess(message: 'Deleted successfully'),
            TradeLoading(), // <-- added this line
            TradesLoaded(paginatedTrades: paginatedTrades),
          ],
      verify: (_) {
        verify(() => mockDeleteTrade(any())).called(1);
        verify(() => mockGetAllTrades(any())).called(1);
      },
    );

    blocTest<TradeViewModel, TradeState>(
      'emits [TradeLoading, TradeError] on failure',
      build: () {
        when(
          () => mockDeleteTrade(any()),
        ).thenAnswer((_) async => Left(testFailure));
        return bloc;
      },
      act: (bloc) => bloc.add(const DeleteTradeEvent(id: '1')),
      expect: () => [TradeLoading(), TradeError(message: testFailure.message)],
      verify: (_) {
        verify(() => mockDeleteTrade(any())).called(1);
      },
    );
  });
}
