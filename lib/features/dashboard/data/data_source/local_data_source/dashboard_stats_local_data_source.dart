import 'package:tradeverse/core/network/hive_service.dart';
import 'package:tradeverse/features/dashboard/data/data_source/dashboard_stats_data_source.dart';
import 'package:tradeverse/features/dashboard/data/models/dashboard_hive_models.dart';
import 'package:tradeverse/features/dashboard/domain/entity/dashboard_stats_entity.dart';

class DashboardStatsLocalDataSource implements IDashboardStatsDataSource {
  final HiveService _hiveService;
  // Use a constant key to save and retrieve the dashboard data, ensuring there's only one entry.
  static const String _dashboardCacheKey = 'DASHBOARD_STATS';

  DashboardStatsLocalDataSource(this._hiveService);

  @override
  Future<DashboardStatsEntity> getDashboardStats() async {
    final hiveModel = _hiveService.dashboardStatsBox.get(_dashboardCacheKey);
    if (hiveModel != null) {
      return hiveModel.toEntity();
    } else {
      throw Exception("No dashboard data found in local cache.");
    }
  }

  @override
  Future<void> cacheDashboardStats(DashboardStatsEntity stats) async {
    final hiveModel = DashboardStatsHiveModel.fromEntity(stats);
    await _hiveService.dashboardStatsBox.put(_dashboardCacheKey, hiveModel);
  }
}
