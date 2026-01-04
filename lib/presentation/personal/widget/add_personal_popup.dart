import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quanly/core/values/app_colors.dart';
import 'package:quanly/presentation/personal/personal_controller.dart';
import 'package:quanly/core/services/image_storage_service.dart';

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
  void initState() {
    super.initState();
    // Add listeners to all text controllers to trigger validation
    personalController.nameController.addListener(_onFieldChanged);
    personalController.idController.addListener(_onFieldChanged);
    personalController.addressController.addListener(_onFieldChanged);
    personalController.dateOfBirthController.addListener(_onFieldChanged);
    personalController.positionController.addListener(_onFieldChanged);
    personalController.phoneNumberController.addListener(_onFieldChanged);
    personalController.officerNumberController.addListener(_onFieldChanged);
    personalController.rankController.addListener(_onFieldChanged);
    
    // Listen to RxString changes
    ever(personalController.sex, (_) => _onFieldChanged());
    ever(personalController.departmentId, (_) => _onFieldChanged());
  }
  
  @override
  void dispose() {
    // Remove listeners
    personalController.nameController.removeListener(_onFieldChanged);
    personalController.idController.removeListener(_onFieldChanged);
    personalController.addressController.removeListener(_onFieldChanged);
    personalController.dateOfBirthController.removeListener(_onFieldChanged);
    personalController.positionController.removeListener(_onFieldChanged);
    personalController.phoneNumberController.removeListener(_onFieldChanged);
    personalController.officerNumberController.removeListener(_onFieldChanged);
    personalController.rankController.removeListener(_onFieldChanged);
    super.dispose();
  }
  
  void _onFieldChanged() {
    setState(() {
      // Trigger rebuild to update button state
    });
  }
  
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
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        Expanded(child: Divider(color: Colors.grey.shade300)),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // CCCD Info Section
                    _buildSectionHeader(
                      Icons.auto_awesome,
                      'THÔNG TIN TỪ CCCD',
                    ),
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
                            controller:
                                personalController.dateOfBirthController,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Obx(
                            () => PersonalDropdown(
                              label: 'Giới tính',
                              value: personalController.sex.value.isEmpty
                                  ? null
                                  : personalController.sex.value,
                              items: ['Nam', 'Nữ', 'Khác'],
                              onChanged: (v) {
                                if (v != null) personalController.sex.value = v;
                              },
                            ),
                          ),
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
                    Obx(
                      () => Row(
                        children: [
                          Expanded(
                            child: PersonalDropdown(
                              label: 'Phòng ban',
                              value:
                                  personalController.departments.isNotEmpty &&
                                      personalController
                                          .departmentId
                                          .value
                                          .isNotEmpty
                                  ? () {
                                      try {
                                        return personalController.departments
                                            .firstWhere(
                                              (e) =>
                                                  e.id ==
                                                  personalController
                                                      .departmentId
                                                      .value,
                                            )
                                            .name;
                                      } catch (e) {
                                        return null;
                                      }
                                    }()
                                  : null,
                              items: personalController.departments
                                  .map((e) => e.name)
                                  .toList(),
                              onChanged: (v) {
                                if (v != null) {
                                  try {
                                    final department = personalController
                                        .departments
                                        .firstWhere((e) => e.name == v);
                                    personalController.departmentId.value =
                                        department.id;
                                  } catch (e) {
                                    // Department not found, ignore
                                  }
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: PersonalTextField(
                              controller: personalController.positionController,
                              label: 'Chức vụ',
                              hintText: 'Ví dụ: Chuyên viên',
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: PersonalTextField(
                            controller: personalController.officerNumberController,
                            label: 'Số hiệu sĩ quan',
                            hintText: 'Nhập số hiệu sĩ quan',
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: PersonalTextField(
                            controller: personalController.rankController,
                            label: 'Cấp bậc',
                            hintText: 'Ví dụ: Thượng úy',
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    PersonalTextField(
                      label: 'Số điện thoại',
                      controller: personalController.phoneNumberController,
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
                    onPressed: () { Get.back(); },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
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
                  Builder(
                    builder: (context) {
                      final isValid = personalController.isFormValid;
                      return ElevatedButton(
                        onPressed: isValid
                            ? () {
                                personalController.addPersonal();
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isValid
                              ? AppColors.blueDark
                              : Colors.grey.shade400,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Lưu thông tin',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
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
