import 'package:flutter/material.dart';

import '../../../core/constants/vastu_constants.dart';
import '../../../data/models/vastu_zone.dart';
import 'point_3d.dart';
import '../../../core/constants/app_colors.dart';

/// One short piece of the home wall (drawn as a thin box).
///
/// A doorway piece is an opening: inside view only draws the
/// beam above it (the door frame), so we can walk through.
class WallPiece {
  final Point3D base;
  final double width;
  final double depth;
  final bool isOuterWall;
  final bool isDoorway;

  const WallPiece({
    required this.base,
    required this.width,
    required this.depth,
    required this.isOuterWall,
    required this.isDoorway,
  });
}

/// A simple box with a fixed size and color (gate, compound wall).
class Block {
  final Point3D base;
  final double width;
  final double depth;
  final double height;
  final Color color;

  const Block({
    required this.base,
    required this.width,
    required this.depth,
    required this.height,
    required this.color,
  });
}

/// The plan of the home and its plot.
///
/// The home center is (0, 0, 0). North is -z, East is +x.
/// Each of the 9 Vastu zones is one 3 x 3 m room.
/// Every inner wall has a door in the middle. The main entrance and the
/// entry gate are on the North side (a good entrance as per Vastu).
class HouseLayout {
  static const double halfSize = VastuConstants.houseSize / 2;
  static const double zoneSize = VastuConstants.zoneSize;
  static const double doorHeight = 2.1;

  /// Walls are split into 1 m pieces. Small pieces sort better when
  /// drawing far to near, and one piece in the middle becomes a door.
  static const double pieceLength = zoneSize / 3;

  // Plot (compound wall) around the home.
  static const double plotWest = -6.5;
  static const double plotEast = 6.5;
  static const double plotNorth = -8.5;
  static const double plotSouth = 6.5;
  static const double gateHalfWidth = 1.5;

  /// The fountain stands here, in the front garden next to the path.
  static const Point3D frontGardenSpot = Point3D(2.6, 0, -6.2);

  /// Stone path from the street, through the gate, to the main door.
  static const List<Point3D> pathCorners = [
    Point3D(-0.6, 0, -12),
    Point3D(0.6, 0, -12),
    Point3D(0.6, 0, -halfSize),
    Point3D(-0.6, 0, -halfSize),
  ];

  /// Center of a zone (room) on the floor.
  static Point3D zoneCenter(VastuZone zone) {
    return Point3D((zone.column - 1) * zoneSize, 0, (zone.row - 1) * zoneSize);
  }

  // ---------------- Home walls ----------------

  static final List<WallPiece> wallPieces = _buildWalls();

  static List<WallPiece> _buildWalls() {
    final pieces = <WallPiece>[];
    const wallLines = [
      -halfSize,
      -halfSize + zoneSize,
      halfSize - zoneSize,
      halfSize,
    ];

    for (final line in wallLines) {
      _addWall(pieces, line: line, runsEastWest: true);
      _addWall(pieces, line: line, runsEastWest: false);
    }
    return pieces;
  }

  /// Adds one full wall line (3 rooms long) made of 1 m pieces.
  static void _addWall(
    List<WallPiece> pieces, {
    required double line,
    required bool runsEastWest,
  }) {
    final isOuterWall = line.abs() == halfSize;
    final isNorthWall = runsEastWest && line == -halfSize;

    for (var room = 0; room < 3; room++) {
      for (var piece = 0; piece < 3; piece++) {
        final isMiddlePiece = piece == 1;
        final isInnerDoor = !isOuterWall && isMiddlePiece;
        final isMainDoor = isNorthWall && room == 1 && isMiddlePiece;

        final center =
            -halfSize + room * zoneSize + piece * pieceLength + pieceLength / 2;

        pieces.add(
          runsEastWest
              ? WallPiece(
                  base: Point3D(center, 0, line),
                  width: pieceLength,
                  depth: VastuConstants.wallThickness,
                  isOuterWall: isOuterWall,
                  isDoorway: isInnerDoor || isMainDoor,
                )
              : WallPiece(
                  base: Point3D(line, 0, center),
                  width: VastuConstants.wallThickness,
                  depth: pieceLength,
                  isOuterWall: isOuterWall,
                  isDoorway: isInnerDoor || isMainDoor,
                ),
        );
      }
    }
  }

  // ---------------- Compound wall and gate ----------------

  static const Color compoundColor = AppColors.compoundWall;
  static const Color gateColor = AppColors.gateDoor;
  static const double compoundHeight = 0.9;
  static const double compoundThickness = 0.2;

  static final List<Block> outdoorBlocks = [
    ..._buildCompoundWall(),
    ..._buildGate(),
  ];

  /// Low wall around the plot, in 1 m pieces, with a gap for the gate.
  static List<Block> _buildCompoundWall() {
    final blocks = <Block>[];

    // North and South sides (run East-West).
    for (var x = plotWest + 0.5; x < plotEast; x++) {
      final isGateGap = x.abs() < gateHalfWidth;
      if (!isGateGap) blocks.add(_compoundPiece(x, plotNorth, true));
      blocks.add(_compoundPiece(x, plotSouth, true));
    }

    // West and East sides (run North-South).
    for (var z = plotNorth + 0.5; z < plotSouth; z++) {
      blocks.add(_compoundPiece(plotWest, z, false));
      blocks.add(_compoundPiece(plotEast, z, false));
    }
    return blocks;
  }

  static Block _compoundPiece(double x, double z, bool runsEastWest) {
    return Block(
      base: Point3D(x, 0, z),
      width: runsEastWest ? 1 : compoundThickness,
      depth: runsEastWest ? compoundThickness : 1,
      height: compoundHeight,
      color: compoundColor,
    );
  }

  /// Two pillars, a beam on top, and two open gate doors.
  static List<Block> _buildGate() {
    const pillarX = gateHalfWidth + 0.1;
    return const [
      // Pillars
      Block(
        base: Point3D(-pillarX, 0, plotNorth),
        width: 0.4,
        depth: 0.4,
        height: 2.0,
        color: compoundColor,
      ),
      Block(
        base: Point3D(pillarX, 0, plotNorth),
        width: 0.4,
        depth: 0.4,
        height: 2.0,
        color: compoundColor,
      ),
      // Beam on top
      Block(
        base: Point3D(0, 2.0, plotNorth),
        width: pillarX * 2 + 0.4,
        depth: 0.3,
        height: 0.25,
        color: AppColors.gateBeam,
      ),
      // Gate doors, fully open and resting along the compound wall.
      Block(
        base: Point3D(-pillarX - 0.9, 0.1, plotNorth - 0.2),
        width: 1.4,
        depth: 0.06,
        height: 1.3,
        color: gateColor,
      ),
      Block(
        base: Point3D(pillarX + 0.9, 0.1, plotNorth - 0.2),
        width: 1.4,
        depth: 0.06,
        height: 1.3,
        color: gateColor,
      ),
    ];
  }
}
