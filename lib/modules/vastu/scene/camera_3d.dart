import 'dart:math';
import 'dart:ui';

import 'point_3d.dart';

/// A camera that circles around a [target] point.
///
/// [target]   -> the point the camera looks at.
/// [yaw]      -> turn left / right (radians).
/// [pitch]    -> how much the camera looks down (radians).
/// [distance] -> how far the camera is from the target.
///
/// Top view:    distance is large, so we circle around the home.
/// Inside view: distance is 0, so the camera stands at the target
///              and only turns its head (first-person view).
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

  /// Anything closer than this (in meters) is not drawn.
  static const double nearPlane = 0.1;

  /// Bigger value = more zoomed in picture.
  /// The lens gets wider as the camera comes closer (like a phone's wide
  /// camera), so small rooms still fit on screen when we are inside.
  double get focalLength {
    final closeness = (distance / 13).clamp(0.0, 1.0);
    return screenSize.shortestSide * (0.5 + 0.3 * closeness);
  }

  /// Where the camera is in the home.
  Point3D get position =>
      target +
      Point3D(
        distance * cos(pitch) * sin(yaw),
        distance * sin(pitch),
        distance * cos(pitch) * cos(yaw),
      );

  /// Converts a world point into camera space.
  /// In camera space the camera is at (0, 0, 0) and looks along -z.
  Point3D toCameraSpace(Point3D worldPoint) {
    final point = worldPoint - position;

    // Rotate around the up (Y) axis.
    final x1 = point.x * cos(yaw) - point.z * sin(yaw);
    final z1 = point.x * sin(yaw) + point.z * cos(yaw);

    // Tilt around the side (X) axis.
    final y2 = point.y * cos(pitch) - z1 * sin(pitch);
    final z2 = point.y * sin(pitch) + z1 * cos(pitch);

    return Point3D(x1, y2, z2);
  }

  /// Camera space -> screen. Dividing by depth makes far things smaller.
  Offset toScreen(Point3D cameraPoint) {
    final depth = -cameraPoint.z;
    final scale = focalLength / depth;
    return Offset(
      screenSize.width / 2 + cameraPoint.x * scale,
      screenSize.height / 2 - cameraPoint.y * scale,
    );
  }

  /// Screen position of one point, or null if it is behind the camera.
  Offset? projectPoint(Point3D worldPoint) {
    final cameraPoint = toCameraSpace(worldPoint);
    if (cameraPoint.z > -nearPlane) return null;
    return toScreen(cameraPoint);
  }

  /// Screen polygon of a face. Returns an empty list if it is behind us.
  List<Offset> projectPolygon(List<Point3D> corners) {
    final cameraPoints = corners.map(toCameraSpace).toList();
    return _clipBehindCamera(cameraPoints).map(toScreen).toList();
  }

  /// Near-plane clipping: cuts off the part of a face that is behind
  /// the camera (needed in inside view, where walls go past us).
  ///
  /// We walk around the polygon edges. Points in front are kept.
  /// When an edge crosses the near plane, we add the crossing point.
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

  /// Distance from the camera, used to draw far things first.
  double distanceTo(Point3D point) {
    final diff = point - position;
    return sqrt(diff.dot(diff));
  }

  /// A face is visible only when it points towards the camera.
  bool canSee(Point3D faceCenter, Point3D faceNormal) {
    return faceNormal.dot(position - faceCenter) > 0;
  }
}
