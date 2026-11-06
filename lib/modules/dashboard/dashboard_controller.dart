import 'package:get/get.dart';

class DashboardController extends GetxController {
  final RxInt selectedTabIndex = 0.obs;

  void changeTab(int index) {
    selectedTabIndex.value = index;
  }
}
