import 'package:get/get.dart';

import '../market/market_controller.dart';
import '../vastu/vastu_controller.dart';
import 'dashboard_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardController>(() => DashboardController());
    Get.lazyPut<MarketController>(() => MarketController());
    Get.lazyPut<VastuController>(() => VastuController());
  }
}
