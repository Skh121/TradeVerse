import 'package:flutter/material.dart';
import 'package:tradeverse/features/dashboard/domain/entity/this_week_summary_entity.dart';

class ThisWeekSummarySection extends StatelessWidget {
  final List<ThisWeekSummaryEntity> daySummaries;
  final Color cardBackgroundColor;

  const ThisWeekSummarySection({
    super.key,
    required this.daySummaries,
    required this.cardBackgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    if (daySummaries.isEmpty) {
      return Container(
        decoration: BoxDecoration(color: cardBackgroundColor),
        padding: const EdgeInsets.all(12),
        child: const Center(child: Text('No trade summaries for this week.')),
      );
    }

    return Container(
      decoration: BoxDecoration(color: cardBackgroundColor),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "This Week",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 65,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: daySummaries.length,
              itemBuilder: (context, index) {
                final summary = daySummaries[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: _buildWeeklySummaryButton(summary),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklySummaryButton(ThisWeekSummaryEntity summary) {
    final Color backgroundColor = summary.isProfit ? Colors.green : Colors.red;
    final String pnlText = summary.isProfit ? "\$+" : "\$-";
    final int dayNumber = summary.dayIndex; // e.g., 1, 2, 3...

    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "$dayNumber", // Display the day index
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "$pnlText${summary.pnl.abs().toStringAsFixed(2)}",
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
