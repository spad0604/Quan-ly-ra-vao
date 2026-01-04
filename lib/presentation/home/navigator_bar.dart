import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quanly/core/values/app_colors.dart';
import 'package:quanly/presentation/home/home_controller.dart';
import 'package:quanly/presentation/home/home_view.dart';
import 'package:quanly/core/services/auth_service.dart';
import 'package:quanly/app/routes/app_routes.dart';

class NavigatorBar extends StatefulWidget {
  const NavigatorBar({super.key});

  @override
  State<NavigatorBar> createState() => _NavigatorBarState();
}

class _NavigatorBarState extends State<NavigatorBar> {
  final homeController = Get.find<HomeController>();

  List<NavigatorBarItemDetails> _getItems() {
    return [
      NavigatorBarItemDetails(
        title: 'overview'.tr,
        icon: Icons.dashboard,
      ),
      NavigatorBarItemDetails(
        title: 'personal_management'.tr,
        icon: Icons.manage_accounts,
      ),
      NavigatorBarItemDetails(
        title: 'anoymus_qr_reader'.tr,
        icon: Icons.qr_code_scanner,
      ),
      NavigatorBarItemDetails(
        title: 'history'.tr,
        icon: Icons.history,
      ),
      NavigatorBarItemDetails(
        title: 'admin_management'.tr,
        icon: Icons.admin_panel_settings,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final items = _getItems();
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          right: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
      ),
      height: double.infinity,
      width: 300,
      child: Column(
        children: [
          // Logo and Name Header
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Logo
                Image.asset(
                  'assets/images/app_icon.png',
                  width: 60,
                  height: 60,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: AppColors.blueDark.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.security,
                        size: 30,
                        color: AppColors.blueDark,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                // Name
                const Text(
                  'BỘ ĐỘI BIÊN PHÒNG\nTỈNH LAI CHÂU',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppColors.blueDark,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          // Navigation Items
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              itemCount: items.length,
              itemBuilder: (_, index) {
                return Column(
                  children: [
                    Obx(
                      () => MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: NavigatorBarItem(
                          title: items[index].title,
                          icon: items[index].icon,
                          isChoose: homeController.selectedIndex.value == index,
                          onTap: () {
                            homeController.changeSelectedIndex(index);
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                );
              },
            ),
          ),
          // Logout Button
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.grey.shade300, width: 1),
              ),
            ),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: InkWell(
                onTap: () => _handleLogout(),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.logout,
                        color: Colors.red.shade700,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'logout'.tr,
                        style: TextStyle(
                          color: Colors.red.shade700,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleLogout() {
    Get.dialog(
      AlertDialog(
        title: Text('logout'.tr),
        content: const Text('Bạn có chắc chắn muốn đăng xuất?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('cancel'.tr),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              _performLogout();
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: Text('logout'.tr),
          ),
        ],
      ),
    );
  }

  void _performLogout() {
    try {
      // Clear auth service
      final authService = Get.find<AuthService>();
      authService.clear();
      
      // Navigate to login
      Get.offAllNamed(AppRoutes.LOGIN);
      
      // Show success message
      Get.snackbar(
        'logout'.tr,
        'logout_success'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      Get.snackbar(
        'error'.tr,
        'Lỗi khi đăng xuất: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}

class NavigatorBarItemDetails {
  NavigatorBarItemDetails({ 
    required this.title,
    required this.icon,
  });

  final String title;

  final IconData icon;

}