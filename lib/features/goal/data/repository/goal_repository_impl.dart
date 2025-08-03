import 'package:dartz/dartz.dart';
import 'package:tradeverse/core/error/failure.dart';
import 'package:tradeverse/core/network/network_info.dart';
import 'package:tradeverse/features/goal/data/data_source/goal_data_source.dart';
import 'package:tradeverse/features/goal/domain/entity/goal_entity.dart';
import 'package:tradeverse/features/goal/domain/repository/goal_repository.dart';

class GoalRepositoryImpl implements IGoalRepository {
  final IGoalDataSource remoteDataSource;
  final IGoalDataSource localDataSource;
  final INetworkInfo networkInfo;

  GoalRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<GoalEntity>>> getGoals() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteGoals = await remoteDataSource.getGoals();
        await localDataSource.cacheGoals(remoteGoals);
        return Right(remoteGoals);
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      try {
        final localGoals = await localDataSource.getGoals();
        return Right(localGoals);
      } catch (e) {
        return Left(CacheFailure(message: "No offline goals available."));
      }
    }
  }

  @override
  Future<Either<Failure, GoalEntity>> createGoal({
    required String type,
    required String period,
    required double targetValue,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final newGoal = await remoteDataSource.createGoal(
          type: type,
          period: period,
          targetValue: targetValue,
          startDate: startDate,
          endDate: endDate,
        );
        // After creating, refetch all goals to update the cache
        final goals = await remoteDataSource.getGoals();
        await localDataSource.cacheGoals(goals);
        return Right(newGoal);
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return Left(
        NetworkFailure(message: "Cannot create goals while offline."),
      );
    }
  }

  @override
  Future<Either<Failure, String>> deleteGoal(String id) async {
    if (await networkInfo.isConnected) {
      try {
        final message = await remoteDataSource.deleteGoal(id);
        // After deleting, update the local cache
        await localDataSource.deleteGoal(id);
        return Right(message);
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return Left(
        NetworkFailure(message: "Cannot delete goals while offline."),
      );
    }
  }
}
