import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'vastu_controller.dart';
import 'widgets/furniture_list.dart';
import 'widgets/house_3d_view.dart';
import 'widgets/item_info_card.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';

class VastuView extends GetView<VastuController> {
  const VastuView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.vastuTitle),
        actions: [
          IconButton(
            tooltip: AppStrings.resetView,
            icon: const Icon(Icons.center_focus_strong),
            onPressed: controller.resetCamera,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  const Positioned.fill(child: House3DView()),
                  Positioned.fill(child: _fadeOverlay()),
                  Positioned(
                    top: 12,
                    left: 12,
                    right: 12,
                    child: Row(
                      children: [
                        _placementBadge(),
                        const Spacer(),
                        _cameraModeSwitch(),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 8,
                    left: 0,
                    right: 0,
                    child: _gestureHint(),
                  ),
                ],
              ),
            ),
            const ItemInfoCard(),
            const SizedBox(height: 4),
            const FurnitureList(),
            _actionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _fadeOverlay() {
    return IgnorePointer(
      child: Obx(
        () => AnimatedOpacity(
          opacity: controller.isFading.value ? 1 : 0,
          duration: VastuController.fadeDuration,
          child: const ColoredBox(color: AppColors.black),
        ),
      ),
    );
  }

  Widget _placementBadge() {
    return Obx(() {
      final isApplied = controller.isVastuApplied;
      return Chip(
        avatar: Icon(
          isApplied ? Icons.check_circle : Icons.warning_amber,
          size: 18,
          color: isApplied ? AppColors.positive : AppColors.warning,
        ),
        label: Text(
          isApplied ? AppStrings.vastuApplied : AppStrings.beforeVastu,
        ),
      );
    });
  }

  Widget _cameraModeSwitch() {
    return Obx(
      () => SegmentedButton<CameraMode>(
        showSelectedIcon: false,
        style: const ButtonStyle(visualDensity: VisualDensity.compact),
        segments: const [
          ButtonSegment(
            value: CameraMode.topView,
            icon: Icon(Icons.map_outlined, size: 18),
            label: Text(AppStrings.topView),
          ),
          ButtonSegment(
            value: CameraMode.insideView,
            icon: Icon(Icons.directions_walk, size: 18),
            label: Text(AppStrings.insideView),
          ),
        ],
        selected: {controller.cameraMode.value},
        onSelectionChanged: controller.isWalkthroughRunning.value
            ? null
            : (selected) => controller.changeCameraMode(selected.first),
      ),
    );
  }

  Widget _gestureHint() {
    return Obx(
      () => Text(
        controller.isInsideView
            ? AppStrings.insideViewHint
            : AppStrings.topViewHint,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 11, color: AppColors.textMedium),
      ),
    );
  }

  Widget _actionButtons() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
      child: Obx(() {
        final isRunning = controller.isWalkthroughRunning.value;
        return Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: isRunning ? null : controller.togglePlacement,
                icon: const Icon(Icons.swap_horiz),
                label: Text(
                  controller.isVastuApplied
                      ? AppStrings.showBefore
                      : AppStrings.applyVastu,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: FilledButton.icon(
                onPressed: isRunning
                    ? controller.stopWalkthrough
                    : controller.startWalkthrough,
                icon: Icon(isRunning ? Icons.stop : Icons.play_arrow),
                label: Text(
                  isRunning ? AppStrings.stop : AppStrings.walkthrough,
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
