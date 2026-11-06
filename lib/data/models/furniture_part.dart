import 'package:flutter/material.dart';

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
