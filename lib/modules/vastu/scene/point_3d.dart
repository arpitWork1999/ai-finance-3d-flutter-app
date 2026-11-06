// x = East, y = Up, z = South
class Point3D {
  final double x;
  final double y;
  final double z;

  const Point3D(this.x, this.y, this.z);

  Point3D operator +(Point3D other) =>
      Point3D(x + other.x, y + other.y, z + other.z);

  Point3D operator -(Point3D other) =>
      Point3D(x - other.x, y - other.y, z - other.z);

  Point3D operator *(double factor) =>
      Point3D(x * factor, y * factor, z * factor);

  double dot(Point3D other) => x * other.x + y * other.y + z * other.z;

  Point3D lerp(Point3D other, double t) => Point3D(
    x + (other.x - x) * t,
    y + (other.y - y) * t,
    z + (other.z - z) * t,
  );
}
