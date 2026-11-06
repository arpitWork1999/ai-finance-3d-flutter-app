import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../vastu_controller.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';

class ItemInfoCard extends GetView<VastuController> {
  const ItemInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final item = controller.selectedItem.value;

      return Card(
        margin: const EdgeInsets.fromLTRB(12, 8, 12, 4),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: item == null
              ? Text(
                  controller.isWalkthroughRunning.value &&
                          controller.isInsideView
                      ? AppStrings.walkingMessage
                      : controller.isVastuApplied
                      ? AppStrings.vastuAppliedMessage
                      : AppStrings.beforeVastuMessage,
                  style: const TextStyle(color: AppColors.textMedium),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Icon(item.icon, color: item.color),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            item.name,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        if (controller.isWalkthroughRunning.value)
                          Text(
                            AppStrings.stepCounter(
                              controller.walkthroughStep.value,
                              controller.items.length,
                            ),
                            style: const TextStyle(color: AppColors.textLight),
                          ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      AppStrings.roomAndZone(
                        item.roomName,
                        item.vastuZone.label,
                      ),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                    Text(
                      item.vastuZone.meaning,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textMedium,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(item.reason),
                  ],
                ),
        ),
      );
    });
  }
}
