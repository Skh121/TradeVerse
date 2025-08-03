import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradeverse/core/network/hive_service.dart';
import 'package:tradeverse/features/dashboard/domain/use_case/get_dashboard_stats_use_case.dart';
import 'package:tradeverse/features/dashboard/presentation/view_model/dashboard_event.dart';
import 'package:tradeverse/features/dashboard/presentation/view_model/dashboard_state.dart';

class DashboardViewModel extends Bloc<DashboardEvent, DashboardState> {
  final GetDashboardStatsUseCase getStatsUseCase;
  final HiveService hiveService;

  DashboardViewModel(this.getStatsUseCase, this.hiveService)
    : super(DashboardState.initial()) {
    on<FetchDashboardStats>(_onFetchDashboardStats);
  }

  Future<void> _onFetchDashboardStats(
    FetchDashboardStats event,
    Emitter<DashboardState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: ''));

    final result = await getStatsUseCase();
    final profile = hiveService.profileBox.values.firstOrNull;
    final fullName =
        profile != null ? '${profile.firstName} ${profile.lastName}' : 'User';

    result.fold(
      (failure) => emit(
        state.copyWith(
          isLoading: false,
          error: failure.message,
          fullName: fullName,
        ),
      ),
      (stats) => emit(
        state.copyWith(stats: stats, isLoading: false, fullName: fullName),
      ),
    );
  }
}
