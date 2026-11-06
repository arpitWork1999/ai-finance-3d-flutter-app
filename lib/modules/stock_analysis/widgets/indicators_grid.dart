import 'package:flutter/material.dart';

import '../../../data/models/stock_analysis.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';

class IndicatorsGrid extends StatelessWidget {
  final StockIndicators indicators;

  const IndicatorsGrid({super.key, required this.indicators});

  @override
  Widget build(BuildContext context) {
    final items = {
      AppStrings.average20Days: _price(indicators.sma20),
      AppStrings.average50Days: _price(indicators.sma50),
      AppStrings.rsi14: indicators.rsi14?.toStringAsFixed(1) ?? '-',
      AppStrings.oneWeek: _percent(indicators.change1Week),
      AppStrings.oneMonth: _percent(indicators.change1Month),
      AppStrings.threeMonths: _percent(indicators.change3Months),
      AppStrings.volatility: '${indicators.volatility.toStringAsFixed(1)}%',
      AppStrings.high100Days: _price(indicators.periodHigh),
      AppStrings.low100Days: _price(indicators.periodLow),
    };

    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.6,
      children: items.entries
          .map(
            (item) => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  item.key,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textGrey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.value,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          )
          .toList(),
    );
  }

  String _price(double? value) =>
      value == null ? '-' : '\$${value.toStringAsFixed(2)}';

  String _percent(double? value) {
    if (value == null) return '-';
    final sign = value >= 0 ? '+' : '';
    return '$sign${value.toStringAsFixed(2)}%';
  }
}
