import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'market_controller.dart';
import 'widgets/market_status_chip.dart';
import 'widgets/stock_card.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';

class MarketView extends GetView<MarketController> {
  const MarketView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.marketTitle),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: MarketStatusChip(),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.stocks.isEmpty) {
          return _ErrorMessage(
            message: controller.errorMessage.value,
            onRetry: controller.loadStocks,
          );
        }

        return RefreshIndicator(
          onRefresh: controller.loadStocks,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              ...controller.stocks.map((stock) => StockCard(stock: stock)),
              const SizedBox(height: 8),
              // Attribution required by Finnhub's terms of use.
              const Text(
                AppStrings.finnhubAttribution,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: AppColors.textGrey),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class _ErrorMessage extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorMessage({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: AppColors.error),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: onRetry,
              child: const Text(AppStrings.retry),
            ),
          ],
        ),
      ),
    );
  }
}
