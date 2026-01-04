import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quanly/core/values/app_colors.dart';
import 'package:quanly/presentation/home/controllers/staff_controller.dart';

class FilterDepartmentDialog extends StatelessWidget {
  const FilterDepartmentDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<StaffController>();
    
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        width: 500,
        constraints: const BoxConstraints(maxHeight: 400),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Lọc theo Phòng Ban',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            Obx(() {
              return Column(
                children: [
                  // Option: All departments
                  ListTile(
                    title: const Text('Tất cả phòng ban'),
                    leading: Radio<String?>(
                      value: null,
                      groupValue: controller.selectedDepartmentId.value,
                      activeColor: AppColors.blueDark,
                      onChanged: (value) {
                        controller.clearDepartmentFilter();
                        Get.back();
                      },
                    ),
                    onTap: () {
                      controller.clearDepartmentFilter();
                      Get.back();
                    },
                  ),
                  const Divider(),
                  // List of departments
                  ...controller.departments.map((dept) => ListTile(
                    title: Text(dept.name),
                    leading: Radio<String?>(
                      value: dept.id,
                      groupValue: controller.selectedDepartmentId.value,
                      activeColor: AppColors.blueDark,
                      onChanged: (value) {
                        controller.filterByDepartment(value);
                        Get.back();
                      },
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                      onPressed: () {
                        controller.showDeleteDepartmentConfirmation(dept);
                      },
                      tooltip: 'Xóa phòng ban',
                    ),
                    onTap: () {
                      controller.filterByDepartment(dept.id);
                      Get.back();
                    },
                  )),
                ],
              );
            }),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Get.back(),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: AppColors.blueDark),
                  foregroundColor: AppColors.blueDark,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Đóng',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

