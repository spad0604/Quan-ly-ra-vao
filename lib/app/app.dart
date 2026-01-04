import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/translations/app_translations.dart';
import '../core/values/app_colors.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';

class App extends StatelessWidget {
  final Locale? initialLocale;

  const App({super.key, this.initialLocale});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Quản lý',
      debugShowCheckedModeBanner: false,
      
      // Translations
      translations: AppTranslations(),
      locale: initialLocale ?? Get.deviceLocale,
      fallbackLocale: const Locale('vi', 'VN'),
      
      // Theme
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        useMaterial3: true,
      ),
      
      // Routing
      initialRoute: AppRoutes.LOGIN,
      getPages: AppPages.routes,
      
      // Default transition
      defaultTransition: Transition.cupertino,
    );
  }
}
