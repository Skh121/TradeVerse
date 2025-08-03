import 'package:dartz/dartz.dart'; // For Either
import 'package:tradeverse/core/error/failure.dart'; // For Failure types
import 'package:tradeverse/app/use_case/use_case.dart'; // Your UseCaseWithoutParams interface
import 'package:tradeverse/features/dashboard/domain/entity/dashboard_stats_entity.dart'; // The entity this use case returns
import 'package:tradeverse/features/dashboard/domain/repository/dashboard_stats_repository.dart'; // The repository interface it depends on

class GetDashboardStatsUseCase
    implements UseCaseWithoutParams<DashboardStatsEntity> {
  final IDashboardStatsRepository
  _repository; // Private field for the repository dependency

  // Constructor to inject the repository dependency
  GetDashboardStatsUseCase({required IDashboardStatsRepository repository})
    : _repository = repository;

  @override
  // The 'call' method defines the core business logic: fetching dashboard stats.
  // It implements UseCaseWithoutParams, so it takes no arguments.
  Future<Either<Failure, DashboardStatsEntity>> call() {
    // Delegates the actual data fetching to the repository.
    return _repository.getDashboardStats();
  }
}
