// lib/features/trade/presentation/bloc/trade_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradeverse/features/trade/domain/use_case/create_trade_use_case.dart';
import 'package:tradeverse/features/trade/domain/use_case/delete_trade_use_case.dart';
import 'package:tradeverse/features/trade/domain/use_case/get_all_trades_use_case.dart';
import 'package:tradeverse/features/trade/domain/use_case/get_trade_by_id_use_case.dart';
import 'package:tradeverse/features/trade/domain/use_case/update_trade_use_case.dart';
import 'trade_event.dart';
import 'trade_state.dart';

class TradeViewModel extends Bloc<TradeEvent, TradeState> {
  final CreateTradeUseCase _createTrade;
  final GetAllTradesUseCase _getAllTrades;
  final GetTradeByIdUseCase _getTradeById;
  final UpdateTradeUseCase _updateTrade;
  final DeleteTradeUseCase _deleteTrade;

  TradeViewModel({
    required CreateTradeUseCase createTrade,
    required GetAllTradesUseCase getAllTrades,
    required GetTradeByIdUseCase getTradeById,
    required UpdateTradeUseCase updateTrade,
    required DeleteTradeUseCase deleteTrade,
  }) : _createTrade = createTrade,
       _getAllTrades = getAllTrades,
       _getTradeById = getTradeById,
       _updateTrade = updateTrade,
       _deleteTrade = deleteTrade,
       super(TradeInitial()) {
    on<FetchAllTrades>(_onFetchAllTrades);
    on<FetchTradeById>(_onFetchTradeById);
    on<CreateTradeEvent>(_onCreateTrade);
    on<UpdateTradeEvent>(_onUpdateTrade);
    on<DeleteTradeEvent>(_onDeleteTrade);
  }

  /// Handles [FetchAllTrades] event.
  Future<void> _onFetchAllTrades(
    FetchAllTrades event,
    Emitter<TradeState> emit,
  ) async {
    emit(TradeLoading());
    final params = GetAllTradesUseCaseParams(page: event.page, limit: event.limit);
    final result = await _getAllTrades(params);
    result.fold(
      (failure) => emit(TradeError(message: failure.message)),
      (paginatedTrades) => emit(TradesLoaded(paginatedTrades: paginatedTrades)),
    );
  }

  /// Handles [FetchTradeById] event.
  Future<void> _onFetchTradeById(
    FetchTradeById event,
    Emitter<TradeState> emit,
  ) async {
    emit(TradeLoading());
    final params = GetTradeByIdUseCaseParams(id: event.id);
    final result = await _getTradeById(params);
    result.fold(
      (failure) => emit(TradeError(message: failure.message)),
      (trade) => emit(SingleTradeLoaded(trade: trade)),
    );
  }

  /// Handles [CreateTradeEvent] event.
  Future<void> _onCreateTrade(
    CreateTradeEvent event,
    Emitter<TradeState> emit,
  ) async {
    emit(TradeLoading());
    final params = CreateTradeUseCaseParams(
      symbol: event.symbol,
      assetClass: event.assetClass,
      tradeDirection: event.tradeDirection,
      entryDate: event.entryDate,
      entryPrice: event.entryPrice,
      positionSize: event.positionSize,
      exitDate: event.exitDate,
      exitPrice: event.exitPrice,
      stopLoss: event.stopLoss,
      takeProfit: event.takeProfit,
      fees: event.fees,
      tags: event.tags,
      notes: event.notes,
      chartScreenshotFile: event.chartScreenshotFile,
    );
    final result = await _createTrade(params);
    result.fold((failure) => emit(TradeError(message: failure.message)), (
      trade,
    ) {
      emit(TradeOperationSuccess(message: 'Trade created successfully!'));
      add(const FetchAllTrades()); // Refresh the list of trades
    });
  }

  /// Handles [UpdateTradeEvent] event.
  Future<void> _onUpdateTrade(
    UpdateTradeEvent event,
    Emitter<TradeState> emit,
  ) async {
    emit(TradeLoading());
    final params = UpdateTradeUseCaseParams(
      id: event.id,
      symbol: event.symbol,
      status: event.status,
      assetClass: event.assetClass,
      tradeDirection: event.tradeDirection,
      entryDate: event.entryDate,
      entryPrice: event.entryPrice,
      positionSize: event.positionSize,
      exitDate: event.exitDate,
      exitPrice: event.exitPrice,
      stopLoss: event.stopLoss,
      takeProfit: event.takeProfit,
      fees: event.fees,
      tags: event.tags,
      notes: event.notes,
      chartScreenshotFile: event.chartScreenshotFile,
      clearChartScreenshot: event.clearChartScreenshot,
    );
    final result = await _updateTrade(params);
    result.fold((failure) => emit(TradeError(message: failure.message)), (
      trade,
    ) {
      emit(TradeOperationSuccess(message: 'Trade updated successfully!'));
      add(const FetchAllTrades()); // Refresh the list of trades
    });
  }

  /// Handles [DeleteTradeEvent] event.
  Future<void> _onDeleteTrade(
    DeleteTradeEvent event,
    Emitter<TradeState> emit,
  ) async {
    emit(TradeLoading());
    final params = DeleteTradeUseCaseParams(id: event.id);
    final result = await _deleteTrade(params);
    result.fold((failure) => emit(TradeError(message: failure.message)), (
      message,
    ) {
      emit(TradeOperationSuccess(message: message));
      add(const FetchAllTrades()); // Refresh the list of trades
    });
  }
}
