import 'package:dartz/dartz.dart';
import 'package:tradeverse/core/error/failure.dart';
import 'package:tradeverse/core/network/network_info.dart';
import 'package:tradeverse/features/dashboard/data/data_source/dashboard_stats_data_source.dart';
import 'package:tradeverse/features/dashboard/domain/entity/dashboard_stats_entity.dart';
import 'package:tradeverse/features/dashboard/domain/repository/dashboard_stats_repository.dart';

class DashboardStatsRepositoryImpl implements IDashboardStatsRepository {
  final IDashboardStatsDataSource remoteDataSource;
  final IDashboardStatsDataSource localDataSource;
  final INetworkInfo networkInfo;

  DashboardStatsRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, DashboardStatsEntity>> getDashboardStats() async {
    if (await networkInfo.isConnected) {
      // --- ONLINE ---
      try {
        // 1. Fetch fresh data from the API
        final remoteStats = await remoteDataSource.getDashboardStats();
        // 2. Cache the fresh data locally for future offline use
        await localDataSource.cacheDashboardStats(remoteStats);
        // 3. Return the fresh data
        return Right(remoteStats);
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      // --- OFFLINE ---
      try {
        // Fetch the last saved data from the local cache
        final localStats = await localDataSource.getDashboardStats();
        return Right(localStats);
      } catch (e) {
        return Left(
          CacheFailure(
            message:
                "No offline data available. Please connect to the internet.",
          ),
        );
      }
    }
  }
}
