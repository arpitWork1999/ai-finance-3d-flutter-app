import 'package:get/get.dart';

/// Keeps track of which bottom tab is selected.
class DashboardController extends GetxController {
  final RxInt selectedTabIndex = 0.obs;

  void changeTab(int index) {
    selectedTabIndex.value = index;
  }
}
