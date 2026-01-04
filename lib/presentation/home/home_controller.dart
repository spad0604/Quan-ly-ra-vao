import 'package:get/get.dart';

import '../../core/base/base_controller.dart';
import 'controllers/dashboard_controller.dart';
import 'controllers/admin_controller.dart';
import 'controllers/staff_controller.dart';
import 'controllers/history_controller.dart';

class HomeController extends BaseController {
  
  Rx<int> selectedIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
  }
  
  @override
  void onReady() {
    super.onReady();
  }
  
  @override
  void onClose() {
    super.onClose();
  }
  
  void changeSelectedIndex(int index) {
    selectedIndex.value = index;
    // Refresh data when switching tabs
    _refreshTabData(index);
  }
  
  void _refreshTabData(int index) {
    try {
      switch (index) {
        case 0: // Dashboard
          final dashboardController = Get.find<DashboardController>();
          dashboardController.refreshAllData();
          break;
        case 1: // Staff
          final staffController = Get.find<StaffController>();
          staffController.getMembers();
          break;
        case 2: // Guest QR Scanner - no need to refresh
          break;
        case 3: // History
          final historyController = Get.find<HistoryController>();
          historyController.fetchHistory();
          break;
        case 4: // Admin
          final adminController = Get.find<AdminController>();
          adminController.fetchAdmins(showLoading: false);
          break;
      }
    } catch (e) {
      // Controller not found yet, ignore
    }
  }
}
