import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../vastu_controller.dart';
import 'house_painter.dart';

class House3DView extends GetView<VastuController> {
  const House3DView({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onScaleStart: (_) => controller.startZoom(),
      onScaleUpdate: (details) {
        controller.dragCamera(
          details.focalPointDelta.dx,
          details.focalPointDelta.dy,
        );
        if (details.pointerCount > 1) {
          controller.zoomCamera(details.scale);
        }
      },
      child: ClipRect(
        child: Obx(
          () => CustomPaint(
            size: Size.infinite,
            painter: HousePainter(
              cameraTarget: controller.cameraTarget.value,
              yaw: controller.cameraYaw.value,
              pitch: controller.cameraPitch.value,
              distance: controller.cameraDistance.value,
              isInsideView: controller.isInsideView,
              wallHeight: controller.wallHeight.value,
              items: controller.items,
              itemPositions: controller.items
                  .map(controller.positionOf)
                  .toList(),
              selectedItem: controller.selectedItem.value,
            ),
          ),
        ),
      ),
    );
  }
}
