import 'package:get/get.dart';

import '../../data/models/stock_analysis.dart';
import '../../data/models/stock_quote.dart';
import '../../data/services/analysis_api_service.dart';
import '../../data/services/connectivity_service.dart';

/// Loads the AI analysis of the stock that was tapped on the Market tab.
class StockAnalysisController extends GetxController {
  final AnalysisApiService _analysisService = AnalysisApiService();

  /// Passed from the Market tab: Get.toNamed(..., arguments: stock)
  final StockQuote stock = Get.arguments as StockQuote;

  final Rxn<StockAnalysis> analysis = Rxn<StockAnalysis>();
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  Worker? _onlineWorker;

  @override
  void onInit() {
    super.onInit();
    loadAnalysis();

    // Back online and the analysis failed to load -> try again.
    _onlineWorker = ever(Get.find<ConnectivityService>().isOnline, (
      bool isOnline,
    ) {
      if (isOnline && analysis.value == null && !isLoading.value) {
        loadAnalysis();
      }
    });
  }

  @override
  void onClose() {
    _onlineWorker?.dispose();
    super.onClose();
  }

  Future<void> loadAnalysis() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      analysis.value = await _analysisService.getAnalysis(stock.symbol);
    } catch (error) {
      errorMessage.value = error.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading.value = false;
    }
  }
}
