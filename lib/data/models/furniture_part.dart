import 'package:flutter/material.dart';

/// One box of a furniture item, e.g. a table leg or a pillow.
///
/// [dx] and [dz] move the part from the item center (in meters).
/// [bottom] is how high above the floor the part starts.
class FurniturePart {
  final double dx;
  final double dz;
  final double bottom;
  final double width;
  final double depth;
  final double height;
  final Color color;

  const FurniturePart({
    this.dx = 0,
    this.dz = 0,
    this.bottom = 0,
    required this.width,
    required this.depth,
    required this.height,
    required this.color,
  });
}
