import 'package:get/get.dart';

import '../modules/dashboard/dashboard_binding.dart';
import '../modules/dashboard/dashboard_view.dart';
import '../modules/stock_analysis/stock_analysis_binding.dart';
import '../modules/stock_analysis/stock_analysis_view.dart';
import 'app_routes.dart';

class AppPages {
  static final List<GetPage> pages = [
    GetPage(
      name: AppRoutes.dashboard,
      page: () => const DashboardView(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: AppRoutes.stockAnalysis,
      page: () => const StockAnalysisView(),
      binding: StockAnalysisBinding(),
    ),
  ];
}
