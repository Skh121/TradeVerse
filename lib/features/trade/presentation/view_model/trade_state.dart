// lib/features/trade/presentation/bloc/trade_state.dart

import 'package:equatable/equatable.dart';
import 'package:tradeverse/features/trade/domain/entity/trade_entity.dart';

/// Base class for all Trade states.
abstract class TradeState extends Equatable {
  const TradeState();

  @override
  List<Object> get props => [];
}

/// Initial state for the Trade Bloc.
class TradeInitial extends TradeState {}

/// State indicating that trades are currently loading.
class TradeLoading extends TradeState {}

/// State indicating that a list of trades has been successfully loaded.
class TradesLoaded extends TradeState {
  final PaginatedTradesEntity paginatedTrades;

  const TradesLoaded({required this.paginatedTrades});

  @override
  List<Object> get props => [paginatedTrades];
}

/// State indicating that a single trade has been successfully loaded.
class SingleTradeLoaded extends TradeState {
  final TradeEntity trade;

  const SingleTradeLoaded({required this.trade});

  @override
  List<Object> get props => [trade];
}

/// State indicating that a trade operation (create, update, delete) was successful.
class TradeOperationSuccess extends TradeState {
  final String message;

  const TradeOperationSuccess({required this.message});

  @override
  List<Object> get props => [message];
}

/// State indicating that an error occurred during trade operations.
class TradeError extends TradeState {
  final String message;

  const TradeError({required this.message});

  @override
  List<Object> get props => [message];
}
