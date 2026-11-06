import 'dart:async';

import 'package:get/get.dart';

import '../../core/constants/api_constants.dart';
import '../../core/constants/stock_constants.dart';
import '../../data/models/stock_quote.dart';
import '../../data/services/stock_api_service.dart';
import '../../data/services/connectivity_service.dart';
import '../../data/services/stock_socket_service.dart';
import '../../core/constants/app_strings.dart';

class MarketController extends GetxController {
  final StockApiService _apiService;
  final StockSocketService _socketService;

  MarketController({
    StockApiService? apiService,
    StockSocketService? socketService,
  }) : _apiService = apiService ?? StockApiService(),
       _socketService = socketService ?? StockSocketService();

  final RxList<StockQuote> stocks = <StockQuote>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxBool isMarketOpen = false.obs;
  final RxBool isLiveConnected = false.obs;

  Timer? _reconnectTimer;
  Timer? _marketStatusTimer;
  Worker? _onlineWorker;
  static const Duration _reconnectDelay = Duration(seconds: 5);
  static const Duration _marketStatusInterval = Duration(minutes: 1);

  // so a fast failure doesn't make the screen blink
  static const Duration _minLoaderTime = Duration(milliseconds: 800);

  @override
  void onInit() {
    super.onInit();
    loadStocks();

    _onlineWorker = ever(Get.find<ConnectivityService>().isOnline, (
      bool isOnline,
    ) {
      if (isOnline) {
        loadStocks();
      } else {
        isLiveConnected.value = false;
      }
    });
    _marketStatusTimer = Timer.periodic(
      _marketStatusInterval,
      (_) => _checkMarketStatus(),
    );
  }

  @override
  void onClose() {
    _onlineWorker?.dispose();
    _reconnectTimer?.cancel();
    _marketStatusTimer?.cancel();
    _socketService.disconnect();
    super.onClose();
  }

  Future<void> loadStocks() async {
    if (ApiConstants.apiKey.isEmpty) {
      errorMessage.value = AppStrings.apiKeyMissing;
      return;
    }

    isLoading.value = stocks.isEmpty;
    errorMessage.value = '';
    // no need to hold the loader on pull-to-refresh
    final minLoader = isLoading.value
        ? Future.delayed(_minLoaderTime)
        : Future.value();

    try {
      final quotes = await _apiService.getQuotes(StockConstants.trackedStocks);
      stocks.assignAll(quotes);
      isMarketOpen.value = await _apiService.isMarketOpen();
      _updateLiveConnection();
    } catch (error) {
      errorMessage.value = error.toString().replaceFirst('Exception: ', '');
    } finally {
      await minLoader;
      isLoading.value = false;
    }
  }

  Future<void> _checkMarketStatus() async {
    if (stocks.isEmpty) return;

    try {
      final isOpenNow = await _apiService.isMarketOpen();
      if (isOpenNow != isMarketOpen.value) {
        await loadStocks();
      }
    } catch (_) {
      // ignore, we check again in a minute
    }
  }

  void _updateLiveConnection() {
    if (isMarketOpen.value) {
      _connectLiveUpdates();
    } else {
      _reconnectTimer?.cancel();
      _socketService.disconnect();
      isLiveConnected.value = false;
    }
  }

  Future<void> _connectLiveUpdates() async {
    _reconnectTimer?.cancel();

    try {
      await _socketService.connect(
        symbols: StockConstants.trackedStocks.keys.toList(),
        onTrade: _onLiveTrade,
        onDisconnected: _onLiveDisconnected,
      );
      isLiveConnected.value = true;
    } catch (_) {
      _onLiveDisconnected();
    }
  }

  void _onLiveTrade(String symbol, double price, DateTime time) {
    final index = stocks.indexWhere((stock) => stock.symbol == symbol);
    if (index == -1) return;

    // replacing the item is what makes Obx rebuild
    stocks[index] = stocks[index].updatePrice(price, time);
  }

  void _onLiveDisconnected() {
    isLiveConnected.value = false;
    _reconnectTimer?.cancel();
    if (!isMarketOpen.value) return;
    _reconnectTimer = Timer(_reconnectDelay, _connectLiveUpdates);
  }
}
