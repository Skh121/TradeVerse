import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:tradeverse/core/error/failure.dart';
import 'package:tradeverse/features/trade/domain/entity/trade_entity.dart';
import 'package:tradeverse/features/trade/domain/repository/trade_repository.dart';

/// Parameters for the [GetAllTradesUseCase] use case.
class GetAllTradesUseCaseParams extends Equatable {
  final int page;
  final int limit;

  const GetAllTradesUseCaseParams({this.page = 1, this.limit = 10});

  @override
  List<Object> get props => [page, limit];
}

/// Use case for fetching all trades with pagination.
class GetAllTradesUseCase {
  final ITradeRepository repository;

  GetAllTradesUseCase(this.repository);

  Future<Either<Failure, PaginatedTradesEntity>> call(
    GetAllTradesUseCaseParams params,
  ) async {
    return await repository.getAllTrades(
      page: params.page,
      limit: params.limit,
    );
  }
}
