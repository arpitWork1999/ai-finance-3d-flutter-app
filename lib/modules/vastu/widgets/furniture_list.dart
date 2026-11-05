import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../vastu_controller.dart';

/// Horizontal list of furniture. Tap one to focus the camera on it.
class FurnitureList extends GetView<VastuController> {
  const FurnitureList({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: Obx(() {
        // Read the values here so Obx knows when to rebuild.
        final selectedItem = controller.selectedItem.value;
        final isRunning = controller.isWalkthroughRunning.value;

        return ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          itemCount: controller.items.length,
          separatorBuilder: (_, _) => const SizedBox(width: 8),
          itemBuilder: (context, index) {
            final item = controller.items[index];
            return ChoiceChip(
              avatar: Icon(item.icon, size: 18, color: item.color),
              label: Text(item.name),
              selected: selectedItem == item,
              // Keep the item icon; don't draw a checkmark over it.
              showCheckmark: false,
              onSelected: isRunning ? null : (_) => controller.selectItem(item),
            );
          },
        );
      }),
    );
  }
}
