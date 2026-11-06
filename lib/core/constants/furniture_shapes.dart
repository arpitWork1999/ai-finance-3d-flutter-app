import '../../data/models/furniture_part.dart';
import 'app_colors.dart';

/// The 3D shape of every furniture item, built from simple boxes.
///
// sizes in meters, -dz is North and +dx is East
class FurnitureShapes {
  static const List<FurniturePart> poojaMandir = [
    // Base cabinet
    FurniturePart(
      width: 1.0,
      depth: 0.6,
      height: 0.8,
      color: AppColors.darkWood,
    ),
    // Shrine
    FurniturePart(
      bottom: 0.8,
      width: 0.8,
      depth: 0.5,
      height: 0.6,
      color: AppColors.gold,
    ),
    // Top
    FurniturePart(
      bottom: 1.4,
      width: 0.5,
      depth: 0.35,
      height: 0.3,
      color: AppColors.darkGold,
    ),
  ];

  static const List<FurniturePart> waterFountain = [
    // Basin
    FurniturePart(width: 1.0, depth: 1.0, height: 0.35, color: AppColors.stone),
    // Water
    FurniturePart(
      bottom: 0.35,
      width: 0.8,
      depth: 0.8,
      height: 0.05,
      color: AppColors.water,
    ),
    // Pillar
    FurniturePart(
      bottom: 0.35,
      width: 0.2,
      depth: 0.2,
      height: 0.6,
      color: AppColors.stone,
    ),
    // Top bowl
    FurniturePart(
      bottom: 0.95,
      width: 0.45,
      depth: 0.45,
      height: 0.1,
      color: AppColors.water,
    ),
  ];

  // chair on the West side so you face East while studying
  static const List<FurniturePart> studyTable = [
    // Table top
    FurniturePart(
      bottom: 0.72,
      width: 0.7,
      depth: 1.4,
      height: 0.05,
      color: AppColors.wood,
    ),
    // Legs
    FurniturePart(
      dx: -0.3,
      dz: -0.65,
      width: 0.06,
      depth: 0.06,
      height: 0.72,
      color: AppColors.darkWood,
    ),
    FurniturePart(
      dx: 0.3,
      dz: -0.65,
      width: 0.06,
      depth: 0.06,
      height: 0.72,
      color: AppColors.darkWood,
    ),
    FurniturePart(
      dx: -0.3,
      dz: 0.65,
      width: 0.06,
      depth: 0.06,
      height: 0.72,
      color: AppColors.darkWood,
    ),
    FurniturePart(
      dx: 0.3,
      dz: 0.65,
      width: 0.06,
      depth: 0.06,
      height: 0.72,
      color: AppColors.darkWood,
    ),
    // Book
    FurniturePart(
      bottom: 0.77,
      width: 0.22,
      depth: 0.3,
      height: 0.05,
      color: AppColors.teal,
    ),
    // Chair seat and back
    FurniturePart(
      dx: -0.6,
      bottom: 0.45,
      width: 0.45,
      depth: 0.45,
      height: 0.05,
      color: AppColors.teal,
    ),
    FurniturePart(
      dx: -0.8,
      bottom: 0.5,
      width: 0.06,
      depth: 0.45,
      height: 0.5,
      color: AppColors.teal,
    ),
  ];

  static const List<FurniturePart> kitchenStove = [
    // Cabinet
    FurniturePart(
      width: 1.8,
      depth: 0.65,
      height: 0.85,
      color: AppColors.darkSteel,
    ),
    // Granite counter top
    FurniturePart(
      bottom: 0.85,
      width: 1.8,
      depth: 0.65,
      height: 0.05,
      color: AppColors.granite,
    ),
    // Stove
    FurniturePart(
      bottom: 0.9,
      width: 0.7,
      depth: 0.45,
      height: 0.06,
      color: AppColors.stoveRed,
    ),
    // Burners
    FurniturePart(
      dx: -0.17,
      bottom: 0.96,
      width: 0.15,
      depth: 0.15,
      height: 0.02,
      color: AppColors.black,
    ),
    FurniturePart(
      dx: 0.17,
      bottom: 0.96,
      width: 0.15,
      depth: 0.15,
      height: 0.02,
      color: AppColors.black,
    ),
  ];

  // door on the North side so the locker opens to the North
  static const List<FurniturePart> cashLocker = [
    // Body
    FurniturePart(width: 0.8, depth: 0.7, height: 1.3, color: AppColors.steel),
    // Door
    FurniturePart(
      dz: -0.37,
      bottom: 0.1,
      width: 0.65,
      depth: 0.04,
      height: 1.1,
      color: AppColors.darkSteel,
    ),
    // Handle
    FurniturePart(
      dx: 0.2,
      dz: -0.4,
      bottom: 0.6,
      width: 0.08,
      depth: 0.05,
      height: 0.2,
      color: AppColors.gold,
    ),
  ];

  // headboard on the South side, head to the South while sleeping
  static const List<FurniturePart> masterBed = [
    // Frame
    FurniturePart(width: 1.9, depth: 2.1, height: 0.35, color: AppColors.wood),
    // Mattress
    FurniturePart(
      bottom: 0.35,
      width: 1.8,
      depth: 1.95,
      height: 0.2,
      color: AppColors.mattress,
    ),
    // Headboard
    FurniturePart(
      dz: 1.0,
      width: 1.9,
      depth: 0.1,
      height: 1.0,
      color: AppColors.wood,
    ),
    // Pillows
    FurniturePart(
      dx: -0.45,
      dz: 0.75,
      bottom: 0.55,
      width: 0.6,
      depth: 0.35,
      height: 0.12,
      color: AppColors.pillow,
    ),
    FurniturePart(
      dx: 0.45,
      dz: 0.75,
      bottom: 0.55,
      width: 0.6,
      depth: 0.35,
      height: 0.12,
      color: AppColors.pillow,
    ),
    // Blanket
    FurniturePart(
      dz: -0.4,
      bottom: 0.55,
      width: 1.8,
      depth: 1.1,
      height: 0.04,
      color: AppColors.blanketRed,
    ),
  ];

  static const List<FurniturePart> diningTable = [
    // Table top
    FurniturePart(
      bottom: 0.72,
      width: 1.6,
      depth: 0.9,
      height: 0.05,
      color: AppColors.lightWood,
    ),
    // Legs
    FurniturePart(
      dx: -0.7,
      dz: -0.38,
      width: 0.07,
      depth: 0.07,
      height: 0.72,
      color: AppColors.darkWood,
    ),
    FurniturePart(
      dx: 0.7,
      dz: -0.38,
      width: 0.07,
      depth: 0.07,
      height: 0.72,
      color: AppColors.darkWood,
    ),
    FurniturePart(
      dx: -0.7,
      dz: 0.38,
      width: 0.07,
      depth: 0.07,
      height: 0.72,
      color: AppColors.darkWood,
    ),
    FurniturePart(
      dx: 0.7,
      dz: 0.38,
      width: 0.07,
      depth: 0.07,
      height: 0.72,
      color: AppColors.darkWood,
    ),
    // Chairs (2 on each long side)
    FurniturePart(
      dx: -0.4,
      dz: -0.7,
      bottom: 0.45,
      width: 0.42,
      depth: 0.42,
      height: 0.05,
      color: AppColors.darkWood,
    ),
    FurniturePart(
      dx: 0.4,
      dz: -0.7,
      bottom: 0.45,
      width: 0.42,
      depth: 0.42,
      height: 0.05,
      color: AppColors.darkWood,
    ),
    FurniturePart(
      dx: -0.4,
      dz: 0.7,
      bottom: 0.45,
      width: 0.42,
      depth: 0.42,
      height: 0.05,
      color: AppColors.darkWood,
    ),
    FurniturePart(
      dx: 0.4,
      dz: 0.7,
      bottom: 0.45,
      width: 0.42,
      depth: 0.42,
      height: 0.05,
      color: AppColors.darkWood,
    ),
  ];

  static const List<FurniturePart> guestBed = [
    // Frame
    FurniturePart(
      width: 1.2,
      depth: 2.0,
      height: 0.32,
      color: AppColors.greyWood,
    ),
    // Mattress
    FurniturePart(
      bottom: 0.32,
      width: 1.1,
      depth: 1.9,
      height: 0.18,
      color: AppColors.mattress,
    ),
    // Headboard
    FurniturePart(
      dz: 0.96,
      width: 1.2,
      depth: 0.08,
      height: 0.8,
      color: AppColors.greyWood,
    ),
    // Pillow
    FurniturePart(
      dz: 0.7,
      bottom: 0.5,
      width: 0.7,
      depth: 0.35,
      height: 0.12,
      color: AppColors.pillow,
    ),
    // Blanket
    FurniturePart(
      dz: -0.35,
      bottom: 0.5,
      width: 1.1,
      depth: 1.0,
      height: 0.04,
      color: AppColors.indigo,
    ),
  ];
}
