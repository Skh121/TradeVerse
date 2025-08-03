import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';

import 'package:tradeverse/core/network/hive_service.dart';
import 'package:tradeverse/features/dashboard/domain/entity/dashboard_stats_entity.dart';
import 'package:tradeverse/features/dashboard/domain/entity/recent_trade_entity.dart';
import 'package:tradeverse/features/dashboard/domain/entity/this_week_summary_entity.dart';
import 'package:tradeverse/features/dashboard/domain/use_case/get_dashboard_stats_use_case.dart';
import 'package:tradeverse/features/dashboard/presentation/view_model/dashboard_event.dart';
import 'package:tradeverse/features/dashboard/presentation/view_model/dashboard_state.dart';
import 'package:tradeverse/features/dashboard/presentation/view_model/dashboard_view_model.dart';

import 'package:tradeverse/core/error/failure.dart';
import 'package:tradeverse/features/profile/data/model/profile_hive_model.dart';

// Mocks
class MockGetDashboardStatsUseCase extends Mock
    implements GetDashboardStatsUseCase {}

class MockHiveService extends Mock implements HiveService {}

// MockBox must implement Box<ProfileHiveModel>
class MockProfileBox extends Mock implements Box<ProfileHiveModel> {}

// Dummy UserDetailHiveModel for ProfileHiveModel.user
final dummyUserDetail = UserDetailHiveModel(
  fullName: 'John Doe',
  email: 'john.doe@example.com',
);

// Dummy ProfileHiveModel with all required fields
final dummyProfile = ProfileHiveModel(
  id: '123',
  user: dummyUserDetail,
  subscription: null,
  firstName: 'John',
  lastName: 'Doe',
  bio: 'Bio of John Doe',
  avatar: null,
);

// Dummy ThisWeekSummaryEntity instance
final dummyThisWeekSummary = ThisWeekSummaryEntity(
  dayIndex: 1,
  pnl: 100.0,
  isProfit: true,
);

// Dummy RecentTradeEntity instance
final dummyRecentTrade = RecentTradeEntity(
  ticker: 'AAPL',
  type: 'stock',
  status: 'closed',
  pnl: 150.0,
  date: DateTime.now(),
);

// Dummy DashboardStatsEntity instance
final dummyStats = DashboardStatsEntity(
  totalPL: 1234.56,
  equityCurve: [],
  thisWeeksSummaries: [dummyThisWeekSummary],
  recentTrades: [dummyRecentTrade],
);

void main() {
  late DashboardViewModel bloc;
  late MockGetDashboardStatsUseCase mockGetStatsUseCase;
  late MockHiveService mockHiveService;
  late MockProfileBox mockProfileBox;

  setUp(() {
    mockGetStatsUseCase = MockGetDashboardStatsUseCase();
    mockHiveService = MockHiveService();
    mockProfileBox = MockProfileBox();

    when(() => mockHiveService.profileBox).thenReturn(mockProfileBox);

    bloc = DashboardViewModel(mockGetStatsUseCase, mockHiveService);
  });

  test('initial state is DashboardState.initial()', () {
    expect(bloc.state, DashboardState.initial());
  });

  blocTest<DashboardViewModel, DashboardState>(
    'emits loading then loaded with stats and fullName when success and profile exists',
    build: () {
      when(
        () => mockGetStatsUseCase(),
      ).thenAnswer((_) async => Right(dummyStats));
      when(() => mockProfileBox.values).thenReturn([dummyProfile]);
      return bloc;
    },
    act: (bloc) => bloc.add(FetchDashboardStats()),
    expect:
        () => [
          DashboardState.initial().copyWith(isLoading: true, error: ''),
          DashboardState.initial().copyWith(
            stats: dummyStats,
            isLoading: false,
            fullName: 'John Doe',
          ),
        ],
  );

  blocTest<DashboardViewModel, DashboardState>(
    'emits loading then error with message and fullName when failure and profile exists',
    build: () {
      when(
        () => mockGetStatsUseCase(),
      ).thenAnswer((_) async => Left(ServerFailure(message: 'Failed')));
      when(() => mockProfileBox.values).thenReturn([dummyProfile]);
      return bloc;
    },
    act: (bloc) => bloc.add(FetchDashboardStats()),
    expect:
        () => [
          DashboardState.initial().copyWith(isLoading: true, error: ''),
          DashboardState.initial().copyWith(
            isLoading: false,
            error: 'Failed',
            fullName: 'John Doe',
          ),
        ],
  );

  blocTest<DashboardViewModel, DashboardState>(
    'emits loading then loaded with stats and default fullName when profile is empty',
    build: () {
      when(
        () => mockGetStatsUseCase(),
      ).thenAnswer((_) async => Right(dummyStats));
      when(() => mockProfileBox.values).thenReturn([]);
      return bloc;
    },
    act: (bloc) => bloc.add(FetchDashboardStats()),
    expect:
        () => [
          DashboardState.initial().copyWith(isLoading: true, error: ''),
          DashboardState.initial().copyWith(
            stats: dummyStats,
            isLoading: false,
            fullName: 'User',
          ),
        ],
  );

  blocTest<DashboardViewModel, DashboardState>(
    'emits loading then error with message and default fullName when failure and profile is empty',
    build: () {
      when(
        () => mockGetStatsUseCase(),
      ).thenAnswer((_) async => Left(ServerFailure(message: 'Failed')));
      when(() => mockProfileBox.values).thenReturn([]);
      return bloc;
    },
    act: (bloc) => bloc.add(FetchDashboardStats()),
    expect:
        () => [
          DashboardState.initial().copyWith(isLoading: true, error: ''),
          DashboardState.initial().copyWith(
            isLoading: false,
            error: 'Failed',
            fullName: 'User',
          ),
        ],
  );
}
