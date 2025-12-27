import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quanly/app/database/app_database.dart';
import 'package:quanly/core/values/app_colors.dart';
import 'package:quanly/presentation/home/navigator_bar.dart';
import 'package:quanly/presentation/home/widgets/filter_department_dialog.dart';
import 'package:quanly/presentation/home/widgets/home_header.dart';
import 'package:quanly/presentation/home/widgets/stat_card.dart';
import 'package:quanly/presentation/personal/personal_controller.dart';
import 'package:quanly/presentation/home/controllers/dashboard_controller.dart';
import 'package:quanly/presentation/home/controllers/staff_controller.dart';
import 'package:quanly/presentation/home/controllers/history_controller.dart';
import 'package:quanly/presentation/home/controllers/guest_controller.dart';
import 'package:intl/intl.dart';
import '../../core/base/base_view.dart';
import 'home_controller.dart';

part 'navigator_bar_item.dart';
part 'tabs/dashboard_tab.dart';
part 'tabs/staff_tab.dart';
part 'tabs/history_tab.dart';
part 'tabs/guest_tab.dart';

class HomeView extends BaseView<HomeController> {
  const HomeView({super.key});
  
  @override
  Widget buildBody(BuildContext context) {
    return buildLoadingOverlay(
      loadingText: 'loading'.tr,
      child: Scaffold(
        body: Row(
          children: [
            const NavigatorBar(),
            Expanded(
              child: Container(
                color: const Color(0xFFF5F7FA), // Light background for content area
                child: Obx(() => IndexedStack(
                  index: controller.selectedIndex.value,
                  children: const [
                    DashboardTab(), // Index 0
                    StaffTab(),     // Index 1
                    GuestTab(),     // Index 2 - Guest QR Reader
                    HistoryTab(),   // Index 3
                  ],
                )),
              ),
            ),
          ],
        ),
      )
    );
  }
}
