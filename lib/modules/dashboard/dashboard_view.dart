import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../market/market_view.dart';
import '../vastu/vastu_view.dart';
import 'dashboard_controller.dart';
import '../../core/constants/app_strings.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        // IndexedStack keeps both tabs alive so switching doesn't reload prices
        body: IndexedStack(
          index: controller.selectedTabIndex.value,
          children: const [MarketView(), VastuView()],
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: controller.selectedTabIndex.value,
          onDestinationSelected: controller.changeTab,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.show_chart_outlined),
              selectedIcon: Icon(Icons.show_chart),
              label: AppStrings.marketTab,
            ),
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: AppStrings.vastuTab,
            ),
          ],
        ),
      ),
    );
  }
}
