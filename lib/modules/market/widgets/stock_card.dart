import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/stock_quote.dart';
import '../../../routes/app_routes.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';

/// Shows one stock: name, live price, today's change and day stats.
/// Tap it to open the AI analysis.
class StockCard extends StatelessWidget {
  final StockQuote stock;

  const StockCard({super.key, required this.stock});

  @override
  Widget build(BuildContext context) {
    final changeColor = stock.isPositive
        ? AppColors.positive
        : AppColors.negative;
    final sign = stock.isPositive ? '+' : '';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Get.toNamed(AppRoutes.stockAnalysis, arguments: stock),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    child: Text(
                      stock.symbol.substring(0, 1),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          stock.companyName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          stock.symbol,
                          style: const TextStyle(color: AppColors.textGrey),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '\$${stock.currentPrice.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '$sign${stock.change.toStringAsFixed(2)} '
                        '($sign${stock.changePercent.toStringAsFixed(2)}%)',
                        style: TextStyle(
                          color: changeColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const Divider(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _StatItem(label: AppStrings.open, value: stock.openPrice),
                  _StatItem(label: AppStrings.high, value: stock.highPrice),
                  _StatItem(label: AppStrings.low, value: stock.lowPrice),
                  _StatItem(
                    label: AppStrings.previousClose,
                    value: stock.previousClose,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppStrings.viewAiAnalysis,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  Text(
                    AppStrings.updatedAt(_formatTime(stock.lastUpdated)),
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textGrey,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final local = time.toLocal();
    String twoDigits(int value) => value.toString().padLeft(2, '0');
    return '${local.day}/${local.month} '
        '${twoDigits(local.hour)}:${twoDigits(local.minute)}:${twoDigits(local.second)}';
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final double value;

  const _StatItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: AppColors.textGrey),
        ),
        const SizedBox(height: 2),
        Text(
          value.toStringAsFixed(2),
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
