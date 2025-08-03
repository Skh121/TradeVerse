// trade_repository_impl.dart

import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:tradeverse/core/error/failure.dart';
import 'package:tradeverse/core/network/network_info.dart';
import 'package:tradeverse/features/trade/data/data_source/trade_data_source.dart';
import 'package:tradeverse/features/trade/domain/entity/trade_entity.dart';
import 'package:tradeverse/features/trade/domain/repository/trade_repository.dart';

class TradeRepositoryImpl implements ITradeRepository {
  final ITradeDataSource remoteDataSource;
  final ITradeDataSource localDataSource;
  final INetworkInfo networkInfo;

  TradeRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, TradeEntity>> createTrade({
    required String symbol,
    required String assetClass,
    required String tradeDirection,
    required DateTime entryDate,
    required double entryPrice,
    required int positionSize,
    DateTime? exitDate,
    double? exitPrice,
    double? stopLoss,
    double? takeProfit,
    required double fees,
    required List<String> tags,
    String? notes,
    File? chartScreenshotFile,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final trade = await remoteDataSource.createTrade(
          symbol: symbol,
          assetClass: assetClass,
          tradeDirection: tradeDirection,
          entryDate: entryDate,
          entryPrice: entryPrice,
          positionSize: positionSize,
          exitDate: exitDate,
          exitPrice: exitPrice,
          stopLoss: stopLoss,
          takeProfit: takeProfit,
          fees: fees,
          tags: tags,
          notes: notes,
          chartScreenshotFile: chartScreenshotFile,
        );
        return Right(trade);
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection.'));
    }
  }

  @override
  Future<Either<Failure, PaginatedTradesEntity>> getAllTrades({
    int page = 1,
    int limit = 10,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteData = await remoteDataSource.getAllTrades(
          page: page,
          limit: limit,
        );
        await localDataSource.cacheTradeList(remoteData);
        return Right(remoteData);
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      try {
        final localData = await localDataSource.getCachedTradeList();
        return Right(localData);
      } catch (e) {
        return Left(CacheFailure(message: "No offline trade data available."));
      }
    }
  }

  @override
  Future<Either<Failure, TradeEntity>> getTradeById(String id) async {
    if (await networkInfo.isConnected) {
      try {
        final trade = await remoteDataSource.getTradeById(id);
        return Right(trade);
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection.'));
    }
  }

  @override
  Future<Either<Failure, TradeEntity>> updateTrade({
    required String id,
    String? symbol,
    String? status,
    String? assetClass,
    String? tradeDirection,
    DateTime? entryDate,
    double? entryPrice,
    int? positionSize,
    DateTime? exitDate,
    double? exitPrice,
    double? stopLoss,
    double? takeProfit,
    double? fees,
    List<String>? tags,
    String? notes,
    File? chartScreenshotFile,
    bool clearChartScreenshot = false,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final updatedTrade = await remoteDataSource.updateTrade(
          id: id,
          symbol: symbol,
          status: status,
          assetClass: assetClass,
          tradeDirection: tradeDirection,
          entryDate: entryDate,
          entryPrice: entryPrice,
          positionSize: positionSize,
          exitDate: exitDate,
          exitPrice: exitPrice,
          stopLoss: stopLoss,
          takeProfit: takeProfit,
          fees: fees,
          tags: tags,
          notes: notes,
          chartScreenshotFile: chartScreenshotFile,
          clearChartScreenshot: clearChartScreenshot,
        );
        return Right(updatedTrade);
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection.'));
    }
  }

  @override
  Future<Either<Failure, String>> deleteTrade(String id) async {
    if (await networkInfo.isConnected) {
      try {
        final message = await remoteDataSource.deleteTrade(id);
        return Right(message);
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection.'));
    }
  }
}
