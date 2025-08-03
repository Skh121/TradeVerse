import 'package:dartz/dartz.dart'; // For Either
import 'package:tradeverse/core/error/failure.dart'; // For Failure types
import 'package:tradeverse/features/dashboard/domain/entity/dashboard_stats_entity.dart'; // The domain entity it works with

abstract class IDashboardStatsRepository {
  Future<Either<Failure, DashboardStatsEntity>> getDashboardStats();
}