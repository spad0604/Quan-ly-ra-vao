import 'package:get/get.dart';

import '../../presentation/home/home_binding.dart';
import '../../presentation/home/home_view.dart';
import 'app_routes.dart';

class AppPages {
  AppPages._();

  static final routes = [
    GetPage(
      name: AppRoutes.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    // Thêm các page khác ở đây
  ];
}
