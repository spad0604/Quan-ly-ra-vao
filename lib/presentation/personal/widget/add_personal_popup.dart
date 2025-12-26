import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quanly/core/values/app_colors.dart';
import 'package:quanly/presentation/personal/personal_controller.dart';

part 'scan_cccd_section.dart';
part 'personal_form_field.dart';
part 'personal_image_picker.dart';

class AddPersonalPopup extends StatefulWidget {
  const AddPersonalPopup({super.key});

  @override
  State<AddPersonalPopup> createState() => _AddPersonalPopupState();
}

class _AddPersonalPopupState extends State<AddPersonalPopup> {
  final personalController = Get.find<PersonalController>();
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.all(16),
      child: Container(
        width: 600, 
        constraints: const BoxConstraints(maxHeight: 800),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Thêm Cán bộ mới',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.close),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            
            // Body
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Scan Section
                    const ScanCccdSection(),
                    
                    const SizedBox(height: 24),
                    
                    // Divider "Hoặc nhập thủ công"
                    Row(
                      children: [
                        Expanded(child: Divider(color: Colors.grey.shade300)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'Hoặc nhập thủ công',
                            style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                          ),
                        ),
                        Expanded(child: Divider(color: Colors.grey.shade300)),
                      ],
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // CCCD Info Section
                    _buildSectionHeader(Icons.auto_awesome, 'THÔNG TIN TỪ CCCD'),
                    const SizedBox(height: 16),
                    
                    Row(
                      children: [
                        Expanded(
                          child: PersonalTextField(
                            label: 'Số CCCD / Định danh',
                            controller: personalController.idController,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: PersonalTextField(
                            label: 'Họ và tên',
                            controller: personalController.nameController,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    Row(
                      children: [
                        Expanded(
                          child: PersonalDatePicker(
                            label: 'Ngày sinh',
                            controller: personalController.dateOfBirthController,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Obx(() => PersonalDropdown(
                                label: 'Giới tính',
                                value: personalController.sex.value.isEmpty ? null : personalController.sex.value,
                                items: ['Nam', 'Nữ', 'Khác'],
                                onChanged: (v) {
                                  if (v != null) personalController.sex.value = v;
                                },
                              )),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    PersonalTextField(
                      label: 'Quê quán',
                      controller: personalController.addressController,
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Work Info Section
                    const Text(
                      'THÔNG TIN CÔNG TÁC',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    Row(
                      children: [
                        Expanded(
                          child: PersonalDropdown(
                            label: 'Phòng ban',
                            value: 'Phòng Hành chính',
                            items: ['Phòng Hành chính', 'Phòng Kế toán', 'Phòng IT'],
                            onChanged: (v) {},
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Expanded(
                          child: PersonalTextField(
                            label: 'Chức vụ',
                            hintText: 'Ví dụ: Chuyên viên',
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Photo Section
                    const PersonalImagePicker(),
                  ],
                ),
              ),
            ),
            
            const Divider(height: 1),
            
            // Footer
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () => Get.back(),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      side: BorderSide(color: Colors.grey.shade300),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Hủy bỏ',
                      style: TextStyle(color: Colors.black87),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.blueDark,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Lưu thông tin',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.success),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            color: AppColors.success,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}