import 'dart:math';

import '../../../data/models/vastu_zone.dart';
import 'point_3d.dart';

class TourStop {
  final VastuZone zone;
  final List<Point3D> walkPath;

  const TourStop({required this.zone, required this.walkPath});

  Point3D get standPoint => walkPath.last;
}

// points are on the floor, the camera adds eye height
class HouseTour {
  static const Point3D startPoint = Point3D(0, 0, -11.5);
  static const double startYaw = pi; // facing South

  static const List<TourStop> stops = [
    // Through the gate to the fountain in the front garden.
    TourStop(
      zone: VastuZone.north,
      walkPath: [Point3D(0, 0, -9.5), Point3D(0, 0, -7.4)],
    ),
    // In through the main door, then to the Pooja room door.
    TourStop(
      zone: VastuZone.northEast,
      walkPath: [
        Point3D(0, 0, -5.5),
        Point3D(0, 0, -3.8),
        Point3D(0.9, 0, -3.0),
        Point3D(1.5, 0, -3.0),
      ],
    ),
    // Back through the entrance, into the central hall, to the study door.
    TourStop(
      zone: VastuZone.east,
      walkPath: [
        Point3D(0.7, 0, -3.0),
        Point3D(0, 0, -2.2),
        Point3D(0, 0, -1.0),
        Point3D(0.8, 0, -0.4),
        Point3D(1.3, 0, 0),
      ],
    ),
    // Past the study table, to the kitchen door.
    TourStop(
      zone: VastuZone.southEast,
      walkPath: [Point3D(2.0, 0, 0.9), Point3D(3.0, 0, 1.6)],
    ),
    // Into the store room, facing the locker door (it opens to North).
    TourStop(
      zone: VastuZone.south,
      walkPath: [
        Point3D(2.1, 0, 2.2),
        Point3D(1.5, 0, 3.0),
        Point3D(0.9, 0, 2.4),
        Point3D(0, 0, 1.7),
      ],
    ),
    // Look into the master bedroom through its door.
    TourStop(
      zone: VastuZone.southWest,
      walkPath: [Point3D(-0.7, 0, 2.4), Point3D(-0.7, 0, 3.0)],
    ),
    // Through the central hall to the dining room door.
    TourStop(
      zone: VastuZone.west,
      walkPath: [
        Point3D(-0.6, 0, 2.2),
        Point3D(0, 0, 1.5),
        Point3D(-0.7, 0, 0.6),
        Point3D(-1.3, 0, 0),
      ],
    ),
    // Past the dining table to the guest room door.
    TourStop(
      zone: VastuZone.northWest,
      walkPath: [Point3D(-2.0, 0, -0.9), Point3D(-3.0, 0, -1.3)],
    ),
  ];

  static const List<Point3D> endPath = [
    Point3D(-2.0, 0, -0.8),
    Point3D(-1.3, 0, 0),
    Point3D(0, 0, 0),
  ];
}
