import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quanly/app/database/app_database.dart';
import 'package:quanly/core/authentication/authentication_service.dart';
import 'package:quanly/core/values/app_colors.dart';
import 'package:quanly/presentation/home/controllers/staff_controller.dart';
import 'package:quanly/presentation/personal/widget/add_personal_popup.dart';

class EditMemberPopup extends StatefulWidget {
  final MemberTableData member;

  const EditMemberPopup({super.key, required this.member});

  @override
  State<EditMemberPopup> createState() => _EditMemberPopupState();
}

class _EditMemberPopupState extends State<EditMemberPopup> {
  final staffController = Get.find<StaffController>();
  final authenticationService = AuthenticationService();

  final nameController = TextEditingController();
  final idController = TextEditingController();
  final addressController = TextEditingController();
  final dateOfBirthController = TextEditingController();
  final positionController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final officerNumberController = TextEditingController();
  final rankController = TextEditingController();

  String selectedDepartmentId = '';
  String selectedSex = '';

  @override
  void initState() {
    super.initState();
    _loadMemberData();
  }

  Future<void> _loadMemberData() async {
    // Get original member data from database (with original departmentId)
    final originalMember = await AppDatabase.instance.getMemberById(widget.member.id);
    if (originalMember != null) {
      nameController.text = originalMember.name;
      // Decode identity number for display
      try {
        idController.text = authenticationService.decodeIndentityNumber(originalMember.identityNumber);
      } catch (e) {
        idController.text = '';
      }
      addressController.text = originalMember.address;
      dateOfBirthController.text = originalMember.dateOfBirth;
      positionController.text = originalMember.position;
      phoneNumberController.text = originalMember.phoneNumber;
      officerNumberController.text = originalMember.officerNumber;
      rankController.text = originalMember.rank;
      selectedDepartmentId = originalMember.departmentId;
      selectedSex = originalMember.sex;
      setState(() {});
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    idController.dispose();
    addressController.dispose();
    dateOfBirthController.dispose();
    positionController.dispose();
    phoneNumberController.dispose();
    officerNumberController.dispose();
    rankController.dispose();
    super.dispose();
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
                    'Chỉnh sửa Cán bộ',
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
                    // CCCD Info Section
                    _buildSectionHeader(
                      Icons.auto_awesome,
                      'THÔNG TIN CÁ NHÂN',
                    ),
                    const SizedBox(height: 16),

                    Row(
                      children: [
                        Expanded(
                          child: PersonalTextField(
                            label: 'Số CCCD / Định danh',
                            controller: idController,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: PersonalTextField(
                            label: 'Họ và tên',
                            controller: nameController,
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
                            controller: dateOfBirthController,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: PersonalDropdown(
                            label: 'Giới tính',
                            value: selectedSex.isEmpty ? null : selectedSex,
                            items: ['Nam', 'Nữ', 'Khác'],
                            onChanged: (v) {
                              if (v != null) {
                                setState(() {
                                  selectedSex = v;
                                });
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    PersonalTextField(
                      label: 'Quê quán',
                      controller: addressController,
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
                              value: staffController.departments.isNotEmpty &&
                                      selectedDepartmentId.isNotEmpty
                                  ? () {
                                      try {
                                        return staffController.departments
                                            .firstWhere(
                                              (e) => e.id == selectedDepartmentId,
                                            )
                                            .name;
                                      } catch (e) {
                                        return null;
                                      }
                                    }()
                                  : null,
                              items: staffController.departments
                                  .map((e) => e.name)
                                  .toList(),
                              onChanged: (v) {
                                if (v != null) {
                                  try {
                                    final department = staffController.departments
                                        .firstWhere((e) => e.name == v);
                                    setState(() {
                                      selectedDepartmentId = department.id;
                                    });
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
                              controller: positionController,
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
                            controller: officerNumberController,
                            label: 'Số hiệu sĩ quan',
                            hintText: 'Nhập số hiệu sĩ quan',
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: PersonalTextField(
                            controller: rankController,
                            label: 'Cấp bậc',
                            hintText: 'Ví dụ: Thượng úy',
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    PersonalTextField(
                      label: 'Số điện thoại',
                      controller: phoneNumberController,
                    ),
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
                  ElevatedButton(
                    onPressed: () async {
                      final ok = await staffController.updateMember(
                        widget.member.id,
                        nameController.text.trim(),
                        idController.text.trim(),
                        addressController.text.trim(),
                        dateOfBirthController.text.trim(),
                        positionController.text.trim(),
                        phoneNumberController.text.trim(),
                        selectedDepartmentId,
                        selectedSex,
                        officerNumberController.text.trim(),
                        rankController.text.trim(),
                      );
                      if (ok) {
                        // Unfocus any focused field to release keyboard state, then close.
                        try {
                          FocusManager.instance.primaryFocus?.unfocus();
                        } catch (_) {}

                        // Small delay to allow platform key events to settle
                        await Future.delayed(const Duration(milliseconds: 60));

                        // Try to close via Get first, then fallback to root navigator pop
                        try {
                          if (Get.isDialogOpen == true) {
                            Get.back();
                            return;
                          }
                        } catch (_) {}

                        try {
                          final navigator = Navigator.of(context, rootNavigator: true);
                          if (navigator.canPop()) {
                            navigator.pop();
                          }
                        } catch (_) {
                          // As a last resort, call Get.back() again
                          try {
                            Get.back();
                          } catch (_) {}
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.blueDark,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Lưu thay đổi',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
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

