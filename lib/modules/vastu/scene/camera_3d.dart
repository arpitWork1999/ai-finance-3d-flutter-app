import 'dart:math';
import 'dart:ui';

import 'point_3d.dart';

class Camera3D {
  final Point3D target;
  final double yaw;
  final double pitch;
  final double distance;
  final Size screenSize;

  const Camera3D({
    required this.target,
    required this.yaw,
    required this.pitch,
    required this.distance,
    required this.screenSize,
  });

  // anything closer than this (meters) isn't drawn
  static const double nearPlane = 0.1;

  // wider lens when close, otherwise the 3 m rooms don't fit on screen
  double get focalLength {
    final closeness = (distance / 13).clamp(0.0, 1.0);
    return screenSize.shortestSide * (0.5 + 0.3 * closeness);
  }

  Point3D get position =>
      target +
      Point3D(
        distance * cos(pitch) * sin(yaw),
        distance * sin(pitch),
        distance * cos(pitch) * cos(yaw),
      );

  // camera at the origin, looking down -z
  Point3D toCameraSpace(Point3D worldPoint) {
    final point = worldPoint - position;

    // yaw: rotate around Y
    final x1 = point.x * cos(yaw) - point.z * sin(yaw);
    final z1 = point.x * sin(yaw) + point.z * cos(yaw);

    // pitch: tilt around X
    final y2 = point.y * cos(pitch) - z1 * sin(pitch);
    final z2 = point.y * sin(pitch) + z1 * cos(pitch);

    return Point3D(x1, y2, z2);
  }

  // dividing by depth is what makes far things smaller
  Offset toScreen(Point3D cameraPoint) {
    final depth = -cameraPoint.z;
    final scale = focalLength / depth;
    return Offset(
      screenSize.width / 2 + cameraPoint.x * scale,
      screenSize.height / 2 - cameraPoint.y * scale,
    );
  }

  Offset? projectPoint(Point3D worldPoint) {
    final cameraPoint = toCameraSpace(worldPoint);
    if (cameraPoint.z > -nearPlane) return null;
    return toScreen(cameraPoint);
  }

  List<Offset> projectPolygon(List<Point3D> corners) {
    final cameraPoints = corners.map(toCameraSpace).toList();
    return _clipBehindCamera(cameraPoints).map(toScreen).toList();
  }

  // near-plane clipping, otherwise walls passing behind the camera
  // in inside view get projected into garbage
  List<Point3D> _clipBehindCamera(List<Point3D> points) {
    final result = <Point3D>[];

    for (var i = 0; i < points.length; i++) {
      final current = points[i];
      final next = points[(i + 1) % points.length];
      final isCurrentInFront = current.z < -nearPlane;
      final isNextInFront = next.z < -nearPlane;

      if (isCurrentInFront) result.add(current);

      if (isCurrentInFront != isNextInFront) {
        final t = (-nearPlane - current.z) / (next.z - current.z);
        result.add(current.lerp(next, t));
      }
    }
    return result;
  }

  double distanceTo(Point3D point) {
    final diff = point - position;
    return sqrt(diff.dot(diff));
  }

  bool canSee(Point3D faceCenter, Point3D faceNormal) {
    return faceNormal.dot(position - faceCenter) > 0;
  }
}
