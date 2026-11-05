import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

import '../../core/widgets/no_internet_dialog.dart';

/// Watches Wi-Fi / mobile data for the whole app.
///
/// - Goes offline -> shows the "You're offline" dialog.
/// - Back online  -> closes the dialog. Screens listen to [isOnline]
///   and load their data again.
class ConnectivityService extends GetxService {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  final RxBool isOnline = true.obs;

  // onReady runs after the first frame, so the dialog can be shown.
  @override
  void onReady() {
    super.onReady();
    _checkNow();
    _subscription = _connectivity.onConnectivityChanged.listen(_onChanged);
  }

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }

  Future<void> _checkNow() async {
    _onChanged(await _connectivity.checkConnectivity());
  }

  /// Online means at least one network (Wi-Fi, mobile data, ...) is on.
  void _onChanged(List<ConnectivityResult> results) {
    final hasNetwork = results.any(
      (result) => result != ConnectivityResult.none,
    );
    if (hasNetwork == isOnline.value) return;

    isOnline.value = hasNetwork;
    if (hasNetwork) {
      _closeDialog();
    } else {
      _showDialog();
    }
  }

  void _showDialog() {
    if (Get.isDialogOpen == true) return;
    Get.dialog(const NoInternetDialog(), barrierDismissible: false);
  }

  void _closeDialog() {
    if (Get.isDialogOpen == true) Get.back();
  }
}
