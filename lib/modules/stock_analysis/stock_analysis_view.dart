import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/models/stock_analysis.dart';
import 'stock_analysis_controller.dart';
import 'widgets/analysis_section.dart';
import 'widgets/indicators_grid.dart';
import 'widgets/price_history_chart.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';

class StockAnalysisView extends GetView<StockAnalysisController> {
  const StockAnalysisView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.analysisTitle(controller.stock.companyName)),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text(AppStrings.analysing),
              ],
            ),
          );
        }

        final analysis = controller.analysis.value;
        if (analysis == null) {
          return _ErrorMessage(
            message: controller.errorMessage.value,
            onRetry: controller.loadAnalysis,
          );
        }

        return _AnalysisContent(analysis: analysis);
      }),
    );
  }
}

class _AnalysisContent extends StatelessWidget {
  final StockAnalysis analysis;

  const _AnalysisContent({required this.analysis});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          AppStrings.last100Days,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        PriceHistoryChart(
          priceHistory: analysis.priceHistory,
          trend: analysis.trend,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            _LabelChip(label: analysis.trend, color: _trendColor()),
            const SizedBox(width: 8),
            _LabelChip(
              label: AppStrings.riskLabel(analysis.riskLevel),
              color: _riskColor(),
            ),
          ],
        ),
        const SizedBox(height: 16),
        AnalysisSection(
          title: AppStrings.aiSummary,
          icon: Icons.auto_awesome,
          child: Text(analysis.summary),
        ),
        AnalysisSection(
          title: AppStrings.keyPoints,
          icon: Icons.checklist,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: analysis.keyPoints
                .map(
                  (point) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Text(AppStrings.bulletPoint(point)),
                  ),
                )
                .toList(),
          ),
        ),
        AnalysisSection(
          title: AppStrings.outlook,
          icon: Icons.visibility_outlined,
          child: Text(analysis.outlook),
        ),
        AnalysisSection(
          title: AppStrings.indicators,
          icon: Icons.analytics_outlined,
          child: IndicatorsGrid(indicators: analysis.indicators),
        ),
        const SizedBox(height: 8),
        Text(
          AppStrings.dataSources(analysis.disclaimer, analysis.dataAsOf),
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 12, color: AppColors.textGrey),
        ),
      ],
    );
  }

  Color _trendColor() {
    switch (analysis.trend) {
      case 'Bullish':
        return AppColors.positive;
      case 'Bearish':
        return AppColors.negative;
      default:
        return AppColors.neutral;
    }
  }

  Color _riskColor() {
    switch (analysis.riskLevel) {
      case 'Low':
        return AppColors.positive;
      case 'High':
        return AppColors.negative;
      default:
        return AppColors.warning;
    }
  }
}

class _LabelChip extends StatelessWidget {
  final String label;
  final Color color;

  const _LabelChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontWeight: FontWeight.w600),
      ),
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
