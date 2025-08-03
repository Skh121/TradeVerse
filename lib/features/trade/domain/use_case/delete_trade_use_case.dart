import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:tradeverse/core/error/failure.dart';
import 'package:tradeverse/features/trade/domain/repository/trade_repository.dart';

/// Parameters for the [DeleteTradeUseCase] use case.
class DeleteTradeUseCaseParams extends Equatable {
  final String id;

  const DeleteTradeUseCaseParams({required this.id});

  @override
  List<Object> get props => [id];
}

/// Use case for deleting a trade.
class DeleteTradeUseCase {
  final ITradeRepository repository;

  DeleteTradeUseCase(this.repository);

  Future<Either<Failure, String>> call(DeleteTradeUseCaseParams params) async {
    return await repository.deleteTrade(params.id);
  }
}
