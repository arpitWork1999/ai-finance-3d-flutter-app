import 'package:get/get.dart';

import '../../data/models/stock_analysis.dart';
import '../../data/models/stock_quote.dart';
import '../../data/services/analysis_api_service.dart';
import '../../data/services/connectivity_service.dart';

class StockAnalysisController extends GetxController {
  final AnalysisApiService _analysisService = AnalysisApiService();

  final StockQuote stock = Get.arguments as StockQuote;

  final Rxn<StockAnalysis> analysis = Rxn<StockAnalysis>();
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  Worker? _onlineWorker;

  // so a fast failure doesn't make the screen blink
  static const Duration _minLoaderTime = Duration(milliseconds: 800);

  @override
  void onInit() {
    super.onInit();
    loadAnalysis();

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
    final minLoader = Future.delayed(_minLoaderTime);

    try {
      analysis.value = await _analysisService.getAnalysis(stock.symbol);
    } catch (error) {
      errorMessage.value = error.toString().replaceFirst('Exception: ', '');
    } finally {
      await minLoader;
      isLoading.value = false;
    }
  }
}
