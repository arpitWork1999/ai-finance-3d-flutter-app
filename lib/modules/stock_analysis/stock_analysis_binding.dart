import 'package:get/get.dart';

import 'stock_analysis_controller.dart';

class StockAnalysisBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StockAnalysisController>(() => StockAnalysisController());
  }
}
