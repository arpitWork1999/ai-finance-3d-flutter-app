import 'point_3d.dart';

/// One flat side of a 3D shape (4 corners).
///
/// [normal] is the direction the face looks at.
/// Example: the top of a box has normal (0, 1, 0) = up.
class Face3D {
  final List<Point3D> corners;
  final Point3D normal;

  const Face3D(this.corners, this.normal);

  Point3D get center {
    double x = 0, y = 0, z = 0;
    for (final corner in corners) {
      x += corner.x;
      y += corner.y;
      z += corner.z;
    }
    return Point3D(x / corners.length, y / corners.length, z / corners.length);
  }

  /// Builds the 5 visible faces of a box (top + 4 sides).
  /// The bottom is skipped because it sits on the floor.
  ///
  /// [base] is the center of the box bottom.
  static List<Face3D> box({
    required Point3D base,
    required double width,
    required double depth,
    required double height,
  }) {
    final left = base.x - width / 2;
    final right = base.x + width / 2;
    final back = base.z - depth / 2;
    final front = base.z + depth / 2;
    final bottom = base.y;
    final top = base.y + height;

    return [
      // Top
      Face3D([
        Point3D(left, top, back),
        Point3D(right, top, back),
        Point3D(right, top, front),
        Point3D(left, top, front),
      ], const Point3D(0, 1, 0)),
      // Front (South)
      Face3D([
        Point3D(left, bottom, front),
        Point3D(right, bottom, front),
        Point3D(right, top, front),
        Point3D(left, top, front),
      ], const Point3D(0, 0, 1)),
      // Back (North)
      Face3D([
        Point3D(left, bottom, back),
        Point3D(right, bottom, back),
        Point3D(right, top, back),
        Point3D(left, top, back),
      ], const Point3D(0, 0, -1)),
      // Right (East)
      Face3D([
        Point3D(right, bottom, back),
        Point3D(right, bottom, front),
        Point3D(right, top, front),
        Point3D(right, top, back),
      ], const Point3D(1, 0, 0)),
      // Left (West)
      Face3D([
        Point3D(left, bottom, back),
        Point3D(left, bottom, front),
        Point3D(left, top, front),
        Point3D(left, top, back),
      ], const Point3D(-1, 0, 0)),
    ];
  }
}
