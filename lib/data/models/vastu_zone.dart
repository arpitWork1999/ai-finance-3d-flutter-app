import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';

// North at the top, East on the right:
//   NW | N | NE
//   W  | C | E
//   SW | S | SE
enum VastuZone {
  northWest(
    'North-West',
    'NW',
    'Air (Vayu) - movement, guests',
    0,
    0,
    AppColors.floorNorthWest,
  ),
  north(
    'North',
    'N',
    'Wealth (Kubera) - money, growth',
    1,
    0,
    AppColors.floorNorth,
  ),
  northEast(
    'North-East',
    'NE',
    'Divine & Water - peace, prayer',
    2,
    0,
    AppColors.floorNorthEast,
  ),
  west('West', 'W', 'Gains - food, family time', 0, 1, AppColors.floorWest),
  center(
    'Center',
    'C',
    'Brahmasthan - keep open and empty',
    1,
    1,
    AppColors.floorCenter,
  ),
  east(
    'East',
    'E',
    'Sunrise - health, focus, learning',
    2,
    1,
    AppColors.floorEast,
  ),
  southWest(
    'South-West',
    'SW',
    'Earth - stability, strength',
    0,
    2,
    AppColors.floorSouthWest,
  ),
  south(
    'South',
    'S',
    'Strength - heavy and safe things',
    1,
    2,
    AppColors.floorSouth,
  ),
  southEast(
    'South-East',
    'SE',
    'Fire (Agni) - cooking, energy',
    2,
    2,
    AppColors.floorSouthEast,
  );

  const VastuZone(
    this.label,
    this.shortLabel,
    this.meaning,
    this.column,
    this.row,
    this.floorColor,
  );

  final String label;
  final String shortLabel;
  final String meaning;
  final int column;
  final int row;
  final Color floorColor;
}
