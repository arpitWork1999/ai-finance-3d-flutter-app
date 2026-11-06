import 'dart:math';

import 'package:flutter/material.dart';

import 'furniture_part.dart';
import 'vastu_zone.dart';

class FurnitureItem {
  final String name;
  final String roomName;
  final IconData icon;
  final Color color;
  final List<FurniturePart> parts;

  final VastuZone vastuZone;

  final VastuZone wrongZone;

  final String reason;

  final bool isInFrontGarden;

  const FurnitureItem({
    required this.name,
    required this.roomName,
    required this.icon,
    required this.color,
    required this.parts,
    required this.vastuZone,
    required this.wrongZone,
    required this.reason,
    this.isInFrontGarden = false,
  });

  double get height =>
      parts.map((part) => part.bottom + part.height).reduce(max);
}
