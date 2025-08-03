import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For DateFormat
import 'package:tradeverse/features/dashboard/domain/entity/recent_trade_entity.dart'; // Import RecentTradeEntity

class RecentTradesSection extends StatelessWidget {
  final List<RecentTradeEntity> recentTrades;
  final Color recentTradesSectionBackground;
  final Color lightTextColor;
  final Color profitColor;
  final Color lossColor;

  const RecentTradesSection({
    super.key,
    required this.recentTrades,
    required this.recentTradesSectionBackground,
    required this.lightTextColor,
    required this.profitColor,
    required this.lossColor,
  });

  @override
  Widget build(BuildContext context) {
    if (recentTrades.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: recentTradesSectionBackground,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            'No recent trades available.',
            style: TextStyle(color: lightTextColor.withOpacity(0.7)),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: recentTradesSectionBackground,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: recentTrades.length,
        itemBuilder: (context, index) {
          final trade = recentTrades[index];
          final isProfit = trade.pnl >= 0;
          final pnlColor = isProfit ? profitColor : lossColor;

          final Color typeTagBgColor =
              trade.type == "long"
                  ? Colors.blue.withOpacity(0.1)
                  : Colors.purple.withOpacity(0.1);
          final Color statusTagBgColor = Colors.grey.withOpacity(0.1);
          const Color tagTextColor = Colors.black;

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        trade.ticker,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: lightTextColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            DateFormat('MM/dd/yyyy').format(trade.date),
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Pass trade.type directly, _buildTradeTag will handle capitalization and safety
                          _buildTradeTag(
                            trade.type,
                            typeTagBgColor,
                            tagTextColor,
                          ),
                          const SizedBox(width: 8),
                          // Pass trade.status directly
                          _buildTradeTag(
                            trade.status,
                            statusTagBgColor,
                            tagTextColor,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    "${isProfit ? "+" : "-"}\$${trade.pnl.abs().toStringAsFixed(0)}",
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: pnlColor,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Helper method for building the small trade tags (Long/Short, closed)
  // --- CRITICAL FIX START ---
  Widget _buildTradeTag(String text, Color bgColor, Color textColor) {
    String displayText = text;
    // Check if the text is not empty before attempting substring operations
    if (displayText.isNotEmpty) {
      // Capitalize the first letter for display
      displayText =
          displayText.substring(0, 1).toUpperCase() + displayText.substring(1);
    }
    // If text is empty, displayText remains an empty string, avoiding the error.

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        displayText, // Use the safely processed text
        style: TextStyle(fontSize: 12, color: textColor),
      ),
    );
  }

  // --- CRITICAL FIX END ---
}
