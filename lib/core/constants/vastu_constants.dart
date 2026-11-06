import 'package:flutter/material.dart';

import '../../data/models/furniture_item.dart';
import '../../data/models/vastu_zone.dart';
import 'furniture_shapes.dart';
import 'app_colors.dart';

class VastuConstants {
  static const double houseSize = 9;
  static const double zoneSize = 3;

  static const double cutawayWallHeight = 1.0;
  static const double fullWallHeight = 2.6;
  static const double wallThickness = 0.15;

  static const double eyeHeight = 1.6;

  static const List<FurnitureItem> furnitureItems = [
    FurnitureItem(
      name: 'Water Fountain',
      roomName: 'Front Garden',
      icon: Icons.water_drop,
      color: AppColors.water,
      parts: FurnitureShapes.waterFountain,
      vastuZone: VastuZone.north,
      wrongZone: VastuZone.southEast,
      isInFrontGarden: true,
      reason:
          'North is the zone of Kubera (wealth). Flowing water at the North '
          'entrance is believed to welcome money and growth into the home.',
    ),
    FurnitureItem(
      name: 'Pooja Mandir',
      roomName: 'Pooja Room',
      icon: Icons.temple_hindu,
      color: AppColors.gold,
      parts: FurnitureShapes.poojaMandir,
      vastuZone: VastuZone.northEast,
      wrongZone: VastuZone.southWest,
      reason:
          'North-East (Ishan corner) gets the first morning sunlight and is '
          'the most peaceful zone, so it is best for prayer.',
    ),
    FurnitureItem(
      name: 'Study Table',
      roomName: 'Study Room',
      icon: Icons.menu_book,
      color: AppColors.teal,
      parts: FurnitureShapes.studyTable,
      vastuZone: VastuZone.east,
      wrongZone: VastuZone.west,
      reason:
          'Facing East while studying gives morning light and is said to '
          'improve focus and memory.',
    ),
    FurnitureItem(
      name: 'Kitchen Stove',
      roomName: 'Kitchen',
      icon: Icons.local_fire_department,
      color: AppColors.stoveRed,
      parts: FurnitureShapes.kitchenStove,
      vastuZone: VastuZone.southEast,
      wrongZone: VastuZone.north,
      reason:
          'South-East is the Agni (fire) corner. Fire should never be '
          'placed in the North or North-East water zones.',
    ),
    FurnitureItem(
      name: 'Cash Locker',
      roomName: 'Store Room',
      icon: Icons.lock,
      color: AppColors.steel,
      parts: FurnitureShapes.cashLocker,
      vastuZone: VastuZone.south,
      wrongZone: VastuZone.center,
      reason:
          'Heavy items like a locker go in the South. Its door should open '
          'towards the North, the direction of wealth.',
    ),
    FurnitureItem(
      name: 'Master Bed',
      roomName: 'Master Bedroom',
      icon: Icons.bed,
      color: AppColors.wood,
      parts: FurnitureShapes.masterBed,
      vastuZone: VastuZone.southWest,
      wrongZone: VastuZone.northEast,
      reason:
          'South-West is the Earth zone and gives stability. The head of '
          'the family sleeps here, with the head towards South.',
    ),
    FurnitureItem(
      name: 'Dining Table',
      roomName: 'Dining Room',
      icon: Icons.restaurant,
      color: AppColors.lightWood,
      parts: FurnitureShapes.diningTable,
      vastuZone: VastuZone.west,
      wrongZone: VastuZone.east,
      reason:
          'West is the zone of gains and satisfaction, good for family '
          'meals together.',
    ),
    FurnitureItem(
      name: 'Guest Bed',
      roomName: 'Guest Room',
      icon: Icons.single_bed,
      color: AppColors.indigo,
      parts: FurnitureShapes.guestBed,
      vastuZone: VastuZone.northWest,
      wrongZone: VastuZone.south,
      reason:
          'North-West is the Air (Vayu) zone of movement, so guests stay '
          'comfortably but not for too long.',
    ),
  ];
}
