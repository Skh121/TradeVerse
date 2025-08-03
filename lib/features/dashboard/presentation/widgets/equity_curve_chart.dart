import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class EquityCurveChart extends StatelessWidget {
  final List<FlSpot> spots; // Data points for the chart
  final Color lineColor; // Color of the chart line
  final Color areaColor; // Color of the area below the line
  final Color gridColor; // Color of the grid lines

  const EquityCurveChart({
    super.key,
    required this.spots,
    this.lineColor = Colors.red, // Default to red as in the original Dashboard
    this.areaColor = Colors.red, // Default to red as in the original Dashboard
    this.gridColor = Colors.grey, // Default to grey for grid lines
  });

  @override
  Widget build(BuildContext context) {
    if (spots.isEmpty) {
      return const SizedBox(
        height: 220,
        child: Center(
          child: Text(
            'No equity data available.',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    // Ensure spots are sorted by X (timestamp) for accurate charting
    final List<FlSpot> sortedSpots = List.from(
      spots,
    ); // Create a mutable copy to sort
    sortedSpots.sort((a, b) => a.x.compareTo(b.x));

    final double minX = sortedSpots.first.x;
    final double maxX = sortedSpots.last.x;
    final double minY = _getMinY(sortedSpots);
    final double maxY = _getMaxY(sortedSpots);

    return SizedBox(
      height: 220,
      child: LineChart(
        LineChartData(
          minX: minX,
          maxX: maxX,
          minY: minY,
          maxY: maxY,
          titlesData: FlTitlesData(
            show: true,
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40, // Give more space to Y-axis labels
                interval: _getLeftTitlesInterval(sortedSpots),
                getTitlesWidget: (value, meta) {
                  return SideTitleWidget(
                    space: 8.0,
                    meta: meta,
                    child: Text(
                      '\$${value.toInt()}',
                      style: const TextStyle(color: Colors.black, fontSize: 12),
                    ),
                  );
                },
              ),
            ),
            // *** CRITICAL CHANGE: Centered "Over the time" label ***
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                // Set interval to half the range to get a point near the middle
                interval: (maxX - minX) > 0 ? (maxX - minX) / 2 : 1.0,
                getTitlesWidget: (value, meta) {
                  // Only show the label if it's approximately in the middle of the axis.
                  // This is a common way to put a single label in the center.
                  final double midPoint = minX + (maxX - minX) / 2;
                  // Allow a small tolerance for floating point comparisons
                  if ((value - midPoint).abs() < 1.0) {
                    // Tolerance of 1 unit
                    return SideTitleWidget(
                      space: 8.0,
                      meta: meta,
                      fitInside: SideTitleFitInsideData(
                        enabled: true,
                        axisPosition: meta.axisPosition,
                        parentAxisSize: meta.parentAxisSize,
                        distanceFromEdge: 0,
                      ),
                      child: const Text(
                        'Over the time', // Static label
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink(); // Hide other potential labels
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          gridData: FlGridData(
            show: true,
            drawHorizontalLine: true,
            drawVerticalLine: true,
            getDrawingHorizontalLine:
                (value) =>
                    FlLine(color: gridColor.withOpacity(0.3), strokeWidth: 1),
            getDrawingVerticalLine:
                (value) =>
                    FlLine(color: gridColor.withOpacity(0.3), strokeWidth: 1),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: sortedSpots, // Use the sorted copy
              barWidth: 3, // Retained original barWidth
              isCurved: true,
              curveSmoothness: 0.4, // Retained original curveSmoothness (0.4)
              color: lineColor,
              dotData: FlDotData(
                show: true,
                getDotPainter:
                    (spot, percent, bar, index) => FlDotCirclePainter(
                      radius: 3,
                      color: Colors.white,
                      strokeWidth: 2,
                      strokeColor: lineColor,
                    ),
              ),
              belowBarData: BarAreaData(
                show: true,
                color: areaColor.withOpacity(0.2),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper to dynamically set minY based on data
  double _getMinY(List<FlSpot> spots) {
    if (spots.isEmpty) return 0;
    double minY = spots.map((spot) => spot.y).reduce((a, b) => a < b ? a : b);
    if (minY >= 0) return 0;
    return (minY - (minY.abs() * 0.1)).floorToDouble();
  }

  // Helper to dynamically set maxY based on data
  double _getMaxY(List<FlSpot> spots) {
    if (spots.isEmpty) return 0;
    double maxY = spots.map((spot) => spot.y).reduce((a, b) => a > b ? a : b);
    if (maxY == 0) return 10;
    return (maxY + (maxY.abs() * 0.1)).ceilToDouble();
  }

  // Helper to dynamically set Y-axis interval
  double _getLeftTitlesInterval(List<FlSpot> spots) {
    if (spots.isEmpty) return 1;
    double range = _getMaxY(spots) - _getMinY(spots);
    if (range <= 0) return 1;
    if (range < 50) return (range / 5).clamp(1.0, 10.0).ceilToDouble();
    if (range < 200) return (range / 4).ceilToDouble();
    return (range / 5).ceilToDouble();
  }
}
