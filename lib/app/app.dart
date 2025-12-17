import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/translations/app_translations.dart';
import '../core/values/app_colors.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Quản lý',
      debugShowCheckedModeBanner: false,
      
      // Translations
      translations: AppTranslations(),
      locale: Get.deviceLocale,
      fallbackLocale: const Locale('vi', 'VN'),
      
      // Theme
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        useMaterial3: true,
      ),
      
      // Routing
      initialRoute: AppRoutes.HOME,
      getPages: AppPages.routes,
      
      // Default transition
      defaultTransition: Transition.cupertino,
    );
  }
}
