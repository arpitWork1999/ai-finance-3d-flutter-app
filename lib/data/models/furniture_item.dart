import 'dart:math';

import 'package:flutter/material.dart';

import 'furniture_part.dart';
import 'vastu_zone.dart';

/// One piece of furniture in the 3D home.
///
/// The item is built from small boxes ([parts]).
class FurnitureItem {
  final String name;
  final String roomName;
  final IconData icon;
  final Color color;
  final List<FurniturePart> parts;

  /// Where Vastu says this item should be placed.
  final VastuZone vastuZone;

  /// A common wrong place, used for the "Before Vastu" layout.
  final VastuZone wrongZone;

  /// Why this zone is right for the item.
  final String reason;

  /// True for items placed outside the home, in the front garden
  /// (in their Vastu direction), instead of inside a room.
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

  /// Height of the tallest part, used to place the name label above it.
  double get height =>
      parts.map((part) => part.bottom + part.height).reduce(max);
}
