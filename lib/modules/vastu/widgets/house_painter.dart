import 'package:flutter/material.dart';

import '../../../data/models/furniture_item.dart';
import '../../../data/models/vastu_zone.dart';
import '../scene/camera_3d.dart';
import '../scene/face_3d.dart';
import '../scene/house_layout.dart';
import '../scene/point_3d.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';

class HousePainter extends CustomPainter {
  final Point3D cameraTarget;
  final double yaw;
  final double pitch;
  final double distance;
  final bool isInsideView;
  final double wallHeight;
  final List<FurnitureItem> items;
  final List<Point3D> itemPositions;
  final FurnitureItem? selectedItem;

  HousePainter({
    required this.cameraTarget,
    required this.yaw,
    required this.pitch,
    required this.distance,
    required this.isInsideView,
    required this.wallHeight,
    required this.items,
    required this.itemPositions,
    required this.selectedItem,
  });

  static const double insideLabelDistance = 4;

  @override
  void paint(Canvas canvas, Size size) {
    final camera = Camera3D(
      target: cameraTarget,
      yaw: yaw,
      pitch: pitch,
      distance: distance,
      screenSize: size,
    );

    canvas.drawRect(Offset.zero & size, Paint()..color = AppColors.sky);
    _drawGround(canvas, camera);
    _drawPolygon(
      canvas,
      camera,
      HouseLayout.pathCorners,
      Paint()..color = AppColors.stonePath,
    );
    _drawFloor(canvas, camera);
    if (!isInsideView) _drawCompass(canvas, camera);
    _drawWallsAndFurniture(canvas, camera);
    _drawLabels(canvas, camera);
  }

  void _drawGround(Canvas canvas, Camera3D camera) {
    const size = 20.0;
    _drawPolygon(canvas, camera, const [
      Point3D(-size, 0, -size),
      Point3D(size, 0, -size),
      Point3D(size, 0, size),
      Point3D(-size, 0, size),
    ], Paint()..color = AppColors.ground);
  }

  void _drawFloor(Canvas canvas, Camera3D camera) {
    const halfZone = HouseLayout.zoneSize / 2;

    for (final zone in VastuZone.values) {
      final center = HouseLayout.zoneCenter(zone);
      final tile = [
        Point3D(center.x - halfZone, 0, center.z - halfZone),
        Point3D(center.x + halfZone, 0, center.z - halfZone),
        Point3D(center.x + halfZone, 0, center.z + halfZone),
        Point3D(center.x - halfZone, 0, center.z + halfZone),
      ];
      _drawPolygon(canvas, camera, tile, Paint()..color = zone.floorColor);

      final labelPosition = camera.projectPoint(
        Point3D(center.x, 0, center.z - 0.9),
      );
      if (labelPosition != null) {
        _drawText(
          canvas,
          zone.shortLabel,
          labelPosition,
          fontSize: 13,
          color: AppColors.textFaint,
        );
      }
    }
  }

  void _drawCompass(Canvas canvas, Camera3D camera) {
    const gap = 0.9;
    const directions = {
      AppStrings.north: Point3D(-3, 0, HouseLayout.plotNorth - gap),
      AppStrings.east: Point3D(HouseLayout.plotEast + gap, 0, 0),
      AppStrings.south: Point3D(0, 0, HouseLayout.plotSouth + gap),
      AppStrings.west: Point3D(HouseLayout.plotWest - gap, 0, 0),
    };

    directions.forEach((letter, point) {
      final position = camera.projectPoint(point);
      if (position == null) return;
      _drawText(
        canvas,
        letter,
        position,
        fontSize: 16,
        color: letter == AppStrings.north
            ? AppColors.compassNorth
            : AppColors.textMedium,
        isBold: true,
      );
    });
  }

  void _drawWallsAndFurniture(Canvas canvas, Camera3D camera) {
    final faces = <_ColoredFace>[];

    // Home walls
    for (final wall in HouseLayout.wallPieces) {
      final wallColor = wall.isOuterWall
          ? AppColors.outerWall
          : AppColors.innerWall;

      // doorway: when the walls are tall, only draw the beam above it
      var bottom = 0.0;
      if (wall.isDoorway) {
        if (wallHeight <= HouseLayout.doorHeight) continue;
        bottom = HouseLayout.doorHeight;
      }

      final boxFaces = Face3D.box(
        base: wall.base + Point3D(0, bottom, 0),
        width: wall.width,
        depth: wall.depth,
        height: wallHeight - bottom,
      );
      for (final face in boxFaces) {
        final isTop = face.normal.y > 0;
        faces.add(
          _ColoredFace(
            face,
            isTop ? AppColors.wallTop : _shade(wallColor, face),
          ),
        );
      }
    }

    // Compound wall and entry gate
    for (final block in HouseLayout.outdoorBlocks) {
      final boxFaces = Face3D.box(
        base: block.base,
        width: block.width,
        depth: block.depth,
        height: block.height,
      );
      for (final face in boxFaces) {
        faces.add(_ColoredFace(face, _shade(block.color, face)));
      }
    }

    // Furniture
    for (var index = 0; index < items.length; index++) {
      final item = items[index];
      final isSelected = item == selectedItem;
      final isFaded = !isInsideView && selectedItem != null && !isSelected;

      for (final part in item.parts) {
        final boxFaces = Face3D.box(
          base: itemPositions[index] + Point3D(part.dx, part.bottom, part.dz),
          width: part.width,
          depth: part.depth,
          height: part.height,
        );
        for (final face in boxFaces) {
          final color = _shade(part.color, face);
          faces.add(
            _ColoredFace(
              face,
              isFaded ? color.withValues(alpha: 0.35) : color,
              isHighlighted: isSelected,
            ),
          );
        }
      }
    }

    // Hide faces that look away from us, then draw far to near.
    final visibleFaces = faces
        .where((item) => camera.canSee(item.face.center, item.face.normal))
        .toList();
    for (final item in visibleFaces) {
      item.distance = camera.distanceTo(item.face.center);
    }
    visibleFaces.sort((a, b) => b.distance.compareTo(a.distance));

    for (final item in visibleFaces) {
      _drawPolygon(
        canvas,
        camera,
        item.face.corners,
        Paint()..color = item.color,
      );
      if (item.isHighlighted) {
        _drawPolygon(
          canvas,
          camera,
          item.face.corners,
          Paint()
            ..color = AppColors.highlight
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2,
        );
      }
    }
  }

  // darker sides so the boxes read as 3D
  Color _shade(Color color, Face3D face) {
    double darkness = 0;
    if (face.normal.x != 0) darkness = 0.12;
    if (face.normal.z != 0) darkness = 0.25;
    return Color.lerp(color, AppColors.black, darkness)!;
  }

  void _drawLabels(Canvas canvas, Camera3D camera) {
    for (var index = 0; index < items.length; index++) {
      final item = items[index];
      final isSelected = item == selectedItem;
      final base = itemPositions[index];

      if (isInsideView) {
        final isNear = camera.distanceTo(base) < insideLabelDistance;
        if (!isSelected && !isNear) continue;
      } else if (selectedItem != null && !isSelected) {
        continue;
      }

      final position = camera.projectPoint(
        Point3D(base.x, item.height + 0.35, base.z),
      );
      if (position == null) continue;

      _drawText(
        canvas,
        item.name,
        position,
        fontSize: isSelected ? 14 : 11,
        color: AppColors.white,
        background: isSelected
            ? AppColors.highlight
            : AppColors.labelBackground,
      );
    }
  }

  void _drawPolygon(
    Canvas canvas,
    Camera3D camera,
    List<Point3D> corners,
    Paint paint,
  ) {
    final points = camera.projectPolygon(corners);
    if (points.length < 3) return;
    canvas.drawPath(Path()..addPolygon(points, true), paint);
  }

  void _drawText(
    Canvas canvas,
    String text,
    Offset position, {
    required double fontSize,
    required Color color,
    Color? background,
    bool isBold = false,
  }) {
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: color,
          fontSize: fontSize,
          fontWeight: isBold || background != null
              ? FontWeight.bold
              : FontWeight.normal,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    final topLeft = position - Offset(painter.width / 2, painter.height / 2);

    if (background != null) {
      final box = RRect.fromRectAndRadius(
        (topLeft & painter.size).inflate(5),
        const Radius.circular(6),
      );
      canvas.drawRRect(box, Paint()..color = background);
    }

    painter.paint(canvas, topLeft);
  }

  @override
  bool shouldRepaint(covariant HousePainter oldDelegate) => true;
}

class _ColoredFace {
  final Face3D face;
  final Color color;
  final bool isHighlighted;
  double distance = 0;

  _ColoredFace(this.face, this.color, {this.isHighlighted = false});
}
