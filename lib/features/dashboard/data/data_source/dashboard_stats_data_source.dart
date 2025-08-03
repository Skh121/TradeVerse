import 'package:tradeverse/features/dashboard/domain/entity/dashboard_stats_entity.dart';

abstract class IDashboardStatsDataSource {
  Future<DashboardStatsEntity> getDashboardStats();
  Future<void> cacheDashboardStats(DashboardStatsEntity stats);
}
