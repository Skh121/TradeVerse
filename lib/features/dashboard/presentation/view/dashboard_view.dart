import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:tradeverse/features/dashboard/presentation/view_model/dashboard_event.dart';
import 'package:tradeverse/features/dashboard/presentation/view_model/dashboard_state.dart';
import 'package:tradeverse/features/dashboard/presentation/widgets/equity_curve_chart.dart';
import 'package:tradeverse/features/dashboard/presentation/widgets/recent_trades_section.dart';
import 'package:tradeverse/features/dashboard/presentation/widgets/this_week_summary_section.dart';
import 'package:tradeverse/features/dashboard/presentation/view_model/dashboard_view_model.dart';
import 'package:tradeverse/features/goal/presentation/widgets/goal_section.dart';
import 'package:tradeverse/features/notification/presentation/widgets/notification_icon_widget.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    const profitColor = Color(0xff00A10B);
    const lossColor = Colors.red;
    const cardBackgroundColor = Color(0xFFf9f9f8);
    const mainTextColor = Colors.black;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BlocBuilder<DashboardViewModel, DashboardState>(
                        builder: (context, state) {
                          final name = state.fullName ?? 'User';
                          return Text(
                            "Welcome Back, $name 👋",
                            style: const TextStyle(fontSize: 18),
                          );
                        },
                      ),
                      const Text(
                        "Dashboard",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  // The Notification Icon is placed here
                  const NotificationIcon(),
                ],
              ),
              const SizedBox(height: 12),

              BlocBuilder<DashboardViewModel, DashboardState>(
                builder: (context, state) {
                  if (state.isLoading && state.stats == null) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state.error.isNotEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Error: ${state.error}'),
                          ElevatedButton(
                            onPressed:
                                () => context.read<DashboardViewModel>().add(
                                  FetchDashboardStats(),
                                ),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  } else if (state.stats == null) {
                    return const Center(
                      child: Text('No dashboard data available.'),
                    );
                  }

                  final stats = state.stats!;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(color: cardBackgroundColor),
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Today - ${DateFormat('EEEE, dd MMM').format(DateTime.now())}",
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              "\$${stats.totalPL.toStringAsFixed(2)}",
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color:
                                    stats.totalPL >= 0
                                        ? profitColor
                                        : lossColor,
                              ),
                            ),
                            const SizedBox(height: 10),
                            const GoalSection(),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),

                      const SizedBox(height: 10),

                      const Text(
                        "Overview",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),

                      ThisWeekSummarySection(
                        daySummaries: stats.thisWeeksSummaries,
                        cardBackgroundColor: cardBackgroundColor,
                      ),

                      const SizedBox(height: 27),

                      EquityCurveChart(
                        spots: stats.equityCurve,
                        lineColor: Colors.red,
                        areaColor: Colors.red,
                        gridColor: Colors.grey,
                      ),

                      const SizedBox(height: 20),

                      const Text(
                        "Recent Trades",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        "Your latest trading activity",
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 10),

                      RecentTradesSection(
                        recentTrades: stats.recentTrades,
                        recentTradesSectionBackground: cardBackgroundColor,
                        lightTextColor: mainTextColor,
                        profitColor: profitColor,
                        lossColor: lossColor,
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTagButton({required String text, required Color color}) {
    return SizedBox(
      height: 30,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          backgroundColor: color,
        ),
        child: Text(text),
      ),
    );
  }
}
