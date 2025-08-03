import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:tradeverse/core/error/failure.dart';
import 'package:tradeverse/features/trade/domain/entity/trade_entity.dart';
import 'package:tradeverse/features/trade/domain/repository/trade_repository.dart';

/// Parameters for the [GetTradeByIdUseCase] use case.
class GetTradeByIdUseCaseParams extends Equatable {
  final String id;

  const GetTradeByIdUseCaseParams({required this.id});

  @override
  List<Object> get props => [id];
}

/// Use case for fetching a single trade by ID.
class GetTradeByIdUseCase {
  final ITradeRepository repository;

  GetTradeByIdUseCase(this.repository);

  Future<Either<Failure, TradeEntity>> call(GetTradeByIdUseCaseParams params) async {
    return await repository.getTradeById(params.id);
  }
}
