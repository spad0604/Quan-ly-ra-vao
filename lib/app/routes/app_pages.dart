import 'package:get/get.dart';
import 'package:quanly/presentation/personal/personal_binding.dart';
import 'package:quanly/presentation/personal/personal_view.dart';

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
    GetPage(
      name: AppRoutes.PERSONAL,
      page: () => const PersonalView(),
      binding: PersonalBinding(),
    )
    // Thêm các page khác ở đây
  ];
}
