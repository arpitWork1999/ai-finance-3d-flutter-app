import 'dart:math';

import 'package:flutter/animation.dart';
import 'package:get/get.dart';

import '../../core/constants/vastu_constants.dart';
import '../../data/models/furniture_item.dart';
import 'scene/house_layout.dart';
import 'scene/house_tour.dart';
import 'scene/point_3d.dart';

enum CameraMode { topView, insideView }

/// Handles the 3D home: camera, furniture placement and the walkthrough.
///
/// Placement uses one value [placementProgress]:
///   0 -> every item is in its wrong zone ("Before Vastu")
///   1 -> every item is in its Vastu zone ("Vastu Applied")
/// Animating it from 0 to 1 slides all furniture to the right place.
///
/// The camera has two modes:
///   Top view    -> circles around the home from above.
///   Inside view -> distance 0, so it stands at eye height like a person.
class VastuController extends GetxController with GetTickerProviderStateMixin {
  final List<FurnitureItem> items = VastuConstants.furnitureItems;

  // Top view camera
  // Looks a bit North of the home, so the gate and garden fit too.
  static const Point3D topViewTarget = Point3D(0, 0, -1.5);
  static const double topYaw = 0.5;
  static const double topPitch = 0.9;
  static const double topDistance = 18;
  static const double topFocusDistance = 8.5;

  // Inside view camera
  static const double eyeHeight = VastuConstants.eyeHeight;
  static const double insidePitch = 0.15;
  static const double lookAtItemPitch = 0.35;
  static const double standDistance = 1.4; // how far we stand from an item
  static const double walkSpeed = 1.8; // meters per second

  // Camera
  final Rx<CameraMode> cameraMode = CameraMode.topView.obs;
  final Rx<Point3D> cameraTarget = topViewTarget.obs;
  final RxDouble cameraYaw = topYaw.obs;
  final RxDouble cameraPitch = topPitch.obs;
  final RxDouble cameraDistance = topDistance.obs;

  /// Low "cut" walls from the top so we can see in, full walls inside.
  /// It is animated too, so walls grow while the camera flies down.
  final RxDouble wallHeight = VastuConstants.cutawayWallHeight.obs;

  /// Screen goes dark for a moment when the camera jumps to a new place.
  final RxBool isFading = false.obs;

  // Furniture
  final RxDouble placementProgress = 0.0.obs;
  final Rxn<FurnitureItem> selectedItem = Rxn<FurnitureItem>();

  // Walkthrough
  final RxBool isWalkthroughRunning = false.obs;
  final RxInt walkthroughStep = 0.obs;
  int _walkthroughId = 0;

  static const Duration placementDuration = Duration(milliseconds: 1600);
  static const Duration cameraDuration = Duration(milliseconds: 1200);
  static const Duration flyDuration = Duration(milliseconds: 2500);
  static const Duration turnDuration = Duration(milliseconds: 800);
  static const Duration fadeDuration = Duration(milliseconds: 300);
  static const Duration stopDuration = Duration(milliseconds: 3500);

  late final AnimationController _placementAnimation;
  late final AnimationController _cameraAnimation;

  // Start and end values of the current camera move.
  Point3D _startTarget = topViewTarget;
  Point3D _endTarget = topViewTarget;
  double _startYaw = topYaw;
  double _endYaw = topYaw;
  double _startPitch = topPitch;
  double _endPitch = topPitch;
  double _startDistance = topDistance;
  double _endDistance = topDistance;
  double _startWallHeight = VastuConstants.cutawayWallHeight;
  double _endWallHeight = VastuConstants.cutawayWallHeight;
  Curve _cameraCurve = Curves.easeInOut;
  double _distanceBeforeZoom = topDistance;

  bool get isVastuApplied => placementProgress.value > 0.5;
  bool get isInsideView => cameraMode.value == CameraMode.insideView;

  @override
  void onInit() {
    super.onInit();

    _placementAnimation = AnimationController(
      vsync: this,
      duration: placementDuration,
    )..addListener(_onPlacementTick);

    _cameraAnimation = AnimationController(
      vsync: this,
      duration: cameraDuration,
    )..addListener(_onCameraTick);
  }

  @override
  void onClose() {
    _placementAnimation.dispose();
    _cameraAnimation.dispose();
    super.onClose();
  }

  // ---------------- Furniture ----------------

  /// Current position of an item, between its wrong place and Vastu place.
  Point3D positionOf(FurnitureItem item) {
    final wrongPosition = HouseLayout.zoneCenter(item.wrongZone);
    final vastuPosition = item.isInFrontGarden
        ? HouseLayout.frontGardenSpot
        : HouseLayout.zoneCenter(item.vastuZone);
    return wrongPosition.lerp(vastuPosition, placementProgress.value);
  }

  void togglePlacement() {
    if (isVastuApplied) {
      _placementAnimation.reverse();
    } else {
      _placementAnimation.forward();
    }
  }

  void _onPlacementTick() {
    placementProgress.value = Curves.easeInOut.transform(
      _placementAnimation.value,
    );
  }

  /// Tapping the same item again removes the selection.
  void selectItem(FurnitureItem item) {
    if (selectedItem.value == item) {
      clearSelection();
      return;
    }
    selectedItem.value = item;
    if (isInsideView) {
      _lookAtItemFromInside(item);
    } else {
      _focusFromTop(item);
    }
  }

  void clearSelection() {
    selectedItem.value = null;
    if (!isInsideView) _showTopOverview();
  }

  // ---------------- Camera modes ----------------

  void changeCameraMode(CameraMode mode) {
    if (mode == cameraMode.value) return;
    selectedItem.value = null;
    if (mode == CameraMode.insideView) {
      _flyDownToStreet();
    } else {
      _showTopOverview();
    }
  }

  void resetCamera() {
    if (isInsideView) {
      _flyDownToStreet();
    } else {
      _showTopOverview();
    }
  }

  /// Inside view starts on the street in front of the entry gate.
  /// We fly down from the sky, so the camera never crosses a wall.
  void _flyDownToStreet() {
    final street = HouseTour.startPoint;
    _moveCamera(
      mode: CameraMode.insideView,
      target: Point3D(street.x, eyeHeight, street.z),
      yaw: HouseTour.startYaw,
      pitch: insidePitch,
      distance: 0,
      duration: flyDuration,
    );
  }

  /// Back to the full view from above (walls go low again).
  void _showTopOverview() {
    _moveCamera(
      mode: CameraMode.topView,
      target: topViewTarget,
      yaw: topYaw,
      pitch: topPitch,
      distance: topDistance,
      duration: isInsideView ? flyDuration : cameraDuration,
    );
  }

  // ---------------- Touch controls ----------------

  void dragCamera(double dragX, double dragY) {
    _cameraAnimation.stop();
    if (isInsideView) {
      // Left/right turns the head, up/down walks forward/back.
      cameraYaw.value -= dragX * 0.006;
      _walk(-dragY * 0.02);
    } else {
      // Left/right turns the home, up/down tilts it.
      cameraYaw.value -= dragX * 0.01;
      cameraPitch.value = (cameraPitch.value + dragY * 0.01).clamp(0.3, 1.4);
    }
  }

  /// Moves the camera in the direction it is looking,
  /// but only inside the plot (or on the street in front of it).
  void _walk(double step) {
    final forward = Point3D(-sin(cameraYaw.value), 0, -cos(cameraYaw.value));
    final next = cameraTarget.value + forward * step;
    const margin = 0.3;

    cameraTarget.value = Point3D(
      next.x.clamp(
        HouseLayout.plotWest + margin,
        HouseLayout.plotEast - margin,
      ),
      eyeHeight,
      next.z.clamp(HouseTour.startPoint.z, HouseLayout.plotSouth - margin),
    );
  }

  void startZoom() {
    _distanceBeforeZoom = cameraDistance.value;
  }

  /// Pinch out (scale > 1) moves the camera closer. Top view only.
  void zoomCamera(double scale) {
    if (isInsideView) return;
    cameraDistance.value = (_distanceBeforeZoom / scale).clamp(7.0, 22.0);
  }

  // ---------------- Camera moves ----------------

  /// Top view: fly closer and look at the item from the home center side.
  void _focusFromTop(FurnitureItem item) {
    final position = positionOf(item);
    final isAtCenter = position.x == 0 && position.z == 0;
    _moveCamera(
      mode: CameraMode.topView,
      target: position,
      yaw: isAtCenter ? cameraYaw.value : atan2(-position.x, -position.z),
      pitch: topPitch,
      distance: topFocusDistance,
    );
  }

  /// Inside view (tapping an item chip): stand a little away from the item,
  /// towards the home center, and look at it.
  void _lookAtItemFromInside(FurnitureItem item) {
    final position = positionOf(item);

    var direction = Point3D(-position.x, 0, -position.z);
    final length = sqrt(direction.dot(direction));
    direction = length == 0 ? const Point3D(0, 0, 1) : direction * (1 / length);

    final standPoint = position + direction * standDistance;

    _jumpCamera(
      target: Point3D(standPoint.x, eyeHeight, standPoint.z),
      yaw: atan2(direction.x, direction.z),
      pitch: lookAtItemPitch,
    );
  }

  /// Yaw needed to look from [from] towards [to].
  double _yawTowards(Point3D from, Point3D to) {
    final direction = to - from;
    return atan2(-direction.x, -direction.z);
  }

  /// Smooth camera move from the current values to the new ones.
  void _moveCamera({
    required CameraMode mode,
    required Point3D target,
    required double yaw,
    required double pitch,
    required double distance,
    Duration duration = cameraDuration,
    Curve curve = Curves.easeInOut,
  }) {
    cameraMode.value = mode;

    // Take the shortest way around (e.g. turn 20 degrees, not 340).
    final turn = yaw - cameraYaw.value;
    final shortestTurn = atan2(sin(turn), cos(turn));

    _startTarget = cameraTarget.value;
    _endTarget = target;
    _startYaw = cameraYaw.value;
    _endYaw = cameraYaw.value + shortestTurn;
    _startPitch = cameraPitch.value;
    _endPitch = pitch;
    _startDistance = cameraDistance.value;
    _endDistance = distance;
    _startWallHeight = wallHeight.value;
    _endWallHeight = mode == CameraMode.insideView
        ? VastuConstants.fullWallHeight
        : VastuConstants.cutawayWallHeight;
    _cameraCurve = curve;

    _cameraAnimation.duration = duration;
    _cameraAnimation.forward(from: 0);
  }

  void _onCameraTick() {
    final t = _cameraCurve.transform(_cameraAnimation.value);
    cameraTarget.value = _startTarget.lerp(_endTarget, t);
    cameraYaw.value = _startYaw + (_endYaw - _startYaw) * t;
    cameraPitch.value = _startPitch + (_endPitch - _startPitch) * t;
    cameraDistance.value = _startDistance + (_endDistance - _startDistance) * t;
    wallHeight.value =
        _startWallHeight + (_endWallHeight - _startWallHeight) * t;
  }

  /// Fade to dark, place the camera, fade back in.
  /// Used when tapping an item inside, so we never fly through walls.
  Future<void> _jumpCamera({
    required Point3D target,
    required double yaw,
    required double pitch,
  }) async {
    isFading.value = true;
    await Future.delayed(fadeDuration);

    _cameraAnimation.stop();
    cameraMode.value = CameraMode.insideView;
    wallHeight.value = VastuConstants.fullWallHeight;
    cameraTarget.value = target;
    cameraYaw.value = yaw;
    cameraPitch.value = pitch;
    cameraDistance.value = 0;

    isFading.value = false;
  }

  // ---------------- Walkthrough ----------------

  /// Plays the full story like a visitor coming home:
  /// 1. Top view: show the wrong ("Before Vastu") layout.
  /// 2. Slide every item to its Vastu place.
  ///    (Steps 1 and 2 are skipped if Vastu is already applied.)
  /// 3. Fly down to the street in front of the entry gate.
  /// 4. Walk through the gate and the main door, room by room,
  ///    stopping at each item to explain its Vastu place.
  /// 5. Walk to the open central hall and fly back up.
  Future<void> startWalkthrough() async {
    // A new id for every run, so an old run stops if a new one starts.
    final runId = ++_walkthroughId;
    isWalkthroughRunning.value = true;
    walkthroughStep.value = 0;
    selectedItem.value = null;

    if (!isVastuApplied) {
      // 1 and 2: Before -> After from the top.
      _showTopOverview();
      _placementAnimation.value = 0;
      if (!await _waitStep(runId, flyDuration)) return;

      _placementAnimation.forward();
      if (!await _waitStep(runId, placementDuration)) return;
    } else {
      // Already applied: make sure the slide is finished.
      _placementAnimation.forward();

      // If we are inside, fly up first, so the camera does not
      // pass through walls on its way to the street.
      if (isInsideView) {
        _showTopOverview();
        if (!await _waitStep(runId, flyDuration)) return;
      }
    }

    // 3: Fly down to the street.
    _flyDownToStreet();
    if (!await _waitStep(runId, flyDuration)) return;

    // 4: Visit every stop.
    for (var index = 0; index < HouseTour.stops.length; index++) {
      final stop = HouseTour.stops[index];
      selectedItem.value = null;

      if (!await _walkPath(runId, stop.walkPath)) return;

      final item = items.firstWhere((item) => item.vastuZone == stop.zone);
      walkthroughStep.value = index + 1;
      selectedItem.value = item;

      // Turn to look at the item.
      _moveCamera(
        mode: CameraMode.insideView,
        target: cameraTarget.value,
        yaw: _yawTowards(cameraTarget.value, positionOf(item)),
        pitch: lookAtItemPitch,
        distance: 0,
        duration: turnDuration,
      );
      if (!await _waitStep(runId, turnDuration + stopDuration)) return;
    }

    // 5: Central hall, then back to the top view.
    selectedItem.value = null;
    if (!await _walkPath(runId, HouseTour.endPath)) return;
    _showTopOverview();
    if (!await _waitStep(runId, flyDuration)) return;

    stopWalkthrough();
  }

  /// Walks point by point at [walkSpeed], always facing where we go.
  /// Returns false if the walkthrough was stopped on the way.
  Future<bool> _walkPath(int runId, List<Point3D> path) async {
    for (final floorPoint in path) {
      final nextPoint = Point3D(floorPoint.x, eyeHeight, floorPoint.z);
      final step = nextPoint - cameraTarget.value;
      final length = sqrt(step.dot(step));
      if (length < 0.01) continue;

      final duration = Duration(
        milliseconds: (length / walkSpeed * 1000).round(),
      );
      _moveCamera(
        mode: CameraMode.insideView,
        target: nextPoint,
        yaw: _yawTowards(cameraTarget.value, nextPoint),
        pitch: insidePitch,
        distance: 0,
        duration: duration,
        curve: Curves.linear,
      );
      if (!await _waitStep(runId, duration)) return false;
    }
    return true;
  }

  void stopWalkthrough() {
    _walkthroughId++;
    isWalkthroughRunning.value = false;
    walkthroughStep.value = 0;
    clearSelection();
  }

  /// Waits, then returns false if this walkthrough was stopped meanwhile.
  Future<bool> _waitStep(int runId, Duration duration) async {
    await Future.delayed(duration);
    return runId == _walkthroughId && isWalkthroughRunning.value;
  }
}
