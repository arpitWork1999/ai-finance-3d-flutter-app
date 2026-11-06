import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../data/models/stock_analysis.dart';
import '../../../core/constants/app_colors.dart';

class PriceHistoryChart extends StatelessWidget {
  final List<PricePoint> priceHistory;
  final String trend;

  const PriceHistoryChart({
    super.key,
    required this.priceHistory,
    required this.trend,
  });

  @override
  Widget build(BuildContext context) {
    final lineColor = trend == 'Bearish'
        ? AppColors.negative
        : AppColors.positive;

    final spots = [
      for (int i = 0; i < priceHistory.length; i++)
        FlSpot(i.toDouble(), priceHistory[i].close),
    ];

    return SizedBox(
      height: 200,
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  // Skip the exact min/max labels, they overlap the others.
                  if (value == meta.min || value == meta.max) {
                    return const SizedBox.shrink();
                  }
                  return Text(
                    value.toStringAsFixed(0),
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textGrey,
                    ),
                  );
                },
              ),
            ),
          ),
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipItems: (touchedSpots) => touchedSpots.map((spot) {
                final point = priceHistory[spot.x.toInt()];
                return LineTooltipItem(
                  '${point.date}\n\$${point.close.toStringAsFixed(2)}',
                  const TextStyle(color: AppColors.white, fontSize: 12),
                );
              }).toList(),
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              color: lineColor,
              barWidth: 2,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                color: lineColor.withValues(alpha: 0.1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
