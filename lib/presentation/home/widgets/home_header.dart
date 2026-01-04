import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quanly/core/values/app_colors.dart';
import 'package:quanly/core/services/locale_service.dart';
import 'package:quanly/core/services/auth_service.dart';
import 'package:quanly/presentation/home/home_controller.dart';
import 'package:quanly/presentation/home/controllers/staff_controller.dart';
import 'package:quanly/presentation/home/controllers/history_controller.dart';

class HomeHeader extends StatelessWidget {
  final String title;
  final String? subtitle;

  const HomeHeader({
    super.key, 
    required this.title,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      color: Colors.white,
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              if (subtitle != null)
                Text(
                  subtitle!,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
            ],
          ),
          const SizedBox(width: 48),
          Expanded(
            child: Obx(() {
              final homeController = Get.find<HomeController>();
              final currentIndex = homeController.selectedIndex.value;
              
              // Only show search for Staff (1) and History (3) tabs
              if (currentIndex == 1) {
                // Staff tab
                final staffController = Get.find<StaffController>();
                return Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextField(
                    controller: staffController.searchController,
                    decoration: InputDecoration(
                      hintText: 'header_search_placeholder'.tr,
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                );
              } else if (currentIndex == 3) {
                // History tab
                final historyController = Get.find<HistoryController>();
                return Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextField(
                    controller: historyController.searchController,
                    decoration: InputDecoration(
                      hintText: 'header_search_placeholder'.tr,
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                );
              } else {
                // Other tabs - no search
                return const SizedBox.shrink();
              }
            }),
          ),
          const SizedBox(width: 24),
          PopupMenuButton<Locale>(
            tooltip: 'language'.tr,
            onSelected: (locale) async {
              await LocaleService.setLocale(locale);
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: const Locale('vi', 'VN'),
                child: Text('language_vi'.tr),
              ),
              PopupMenuItem(
                value: const Locale('en', 'US'),
                child: Text('language_en'.tr),
              ),
            ],
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                children: [
                  const Icon(Icons.language, size: 18, color: AppColors.blueDark),
                  const SizedBox(width: 8),
                  Text(
                    Get.locale?.languageCode == 'en' ? 'EN' : 'VI',
                    style: const TextStyle(
                      color: AppColors.blueDark,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),
          Obx(() {
            final authService = Get.find<AuthService>();
            final adminName = authService.adminName;
            final displayName = adminName.isNotEmpty ? adminName : 'admin';
            final firstLetter = displayName.isNotEmpty 
                ? displayName[0].toUpperCase() 
                : 'A';
            
            return Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      displayName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const Text(
                      'Quản trị viên',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 12),
                CircleAvatar(
                  radius: 18,
                  backgroundColor: AppColors.blueDark,
                  child: Text(
                    firstLetter,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }
}



