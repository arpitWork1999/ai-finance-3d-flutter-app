import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';

import 'core/theme/app_theme.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';
import 'core/constants/app_strings.dart';
import 'data/services/connectivity_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env', isOptional: true);

  runApp(const AiFinanceApp());
}

class AiFinanceApp extends StatelessWidget {
  const AiFinanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialBinding: BindingsBuilder(() {
        Get.put(ConnectivityService(), permanent: true);
      }),
      initialRoute: AppRoutes.dashboard,
      getPages: AppPages.pages,
    );
  }
}
