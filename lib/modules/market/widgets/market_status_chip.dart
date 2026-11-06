import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../market_controller.dart';
import '../../../data/services/connectivity_service.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';

class MarketStatusChip extends GetView<MarketController> {
  const MarketStatusChip({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.stocks.isEmpty) return const SizedBox.shrink();

      final String label;
      final Color color;

      // no internet means nothing is live, whatever the market says
      if (!Get.find<ConnectivityService>().isOnline.value) {
        label = AppStrings.offline;
        color = AppColors.negative;
      } else if (!controller.isMarketOpen.value) {
        label = AppStrings.marketClosed;
        color = AppColors.textGrey;
      } else if (controller.isLiveConnected.value) {
        label = AppStrings.live;
        color = AppColors.positive;
      } else {
        label = AppStrings.connecting;
        color = AppColors.warning;
      }

      return Chip(
        avatar: CircleAvatar(radius: 4, backgroundColor: color),
        label: Text(label, style: const TextStyle(fontSize: 12)),
        visualDensity: VisualDensity.compact,
      );
    });
  }
}
