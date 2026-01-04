import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quanly/app/database/app_database.dart';
import 'package:quanly/core/authentication/authentication_service.dart';
import 'package:quanly/core/values/app_colors.dart';
import 'package:quanly/core/widgets/member_avatar.dart';

class MemberDetailDialog extends StatelessWidget {
  final MemberTableData member;

  const MemberDetailDialog({super.key, required this.member});

  @override
  Widget build(BuildContext context) {
    final authenticationService = AuthenticationService();
    
    // Decode identity number
    String identityNumber = '';
    try {
      identityNumber = authenticationService.decodeIndentityNumber(member.identityNumber);
    } catch (e) {
      identityNumber = member.identityNumber;
    }

    // Get department name
    String departmentName = member.departmentId;
    if (departmentName.isEmpty) {
      departmentName = 'Chưa có phòng ban';
    }

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.all(16),
      child: Container(
        width: 600,
        constraints: const BoxConstraints(maxHeight: 700),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Thông tin Cán bộ',
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
                    // Avatar and Name
                    Center(
                      child: Column(
                        children: [
                          MemberAvatar(
                            imageUrl: member.imageUrl,
                            name: member.name,
                            radius: 50,
                            backgroundColor: AppColors.blueDark.withOpacity(0.1),
                            textColor: AppColors.blueDark,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            member.name,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Thông tin từ CCCD
                    _buildSectionHeader(Icons.auto_awesome, 'THÔNG TIN TỪ CCCD'),
                    const SizedBox(height: 16),
                    _buildInfoRow('Họ và tên', member.name),
                    _buildInfoRow('Số CCCD / Định danh', identityNumber),
                    _buildInfoRow('Ngày tháng năm sinh', member.dateOfBirth),
                    _buildInfoRow('Quê quán', member.address),
                    _buildInfoRow('Giới tính', member.sex),

                    const SizedBox(height: 24),

                    // Thông tin công tác
                    _buildSectionHeader(Icons.work, 'THÔNG TIN CÔNG TÁC'),
                    const SizedBox(height: 16),
                    _buildInfoRow('Số hiệu sĩ quan', member.officerNumber.isNotEmpty ? member.officerNumber : 'Chưa có'),
                    _buildInfoRow('Cấp bậc', member.rank.isNotEmpty ? member.rank : 'Chưa có'),
                    _buildInfoRow('Chức vụ', member.position.isNotEmpty ? member.position : 'Chưa có'),
                    _buildInfoRow('Đơn vị công tác', departmentName),
                    _buildInfoRow('Số điện thoại', member.phoneNumber.isNotEmpty ? member.phoneNumber : 'Chưa có'),
                  ],
                ),
              ),
            ),

            const Divider(height: 1),

            // Footer
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Get.back(),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: BorderSide(color: AppColors.blueDark),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Đóng',
                    style: TextStyle(
                      color: AppColors.blueDark,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
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
        Icon(icon, size: 16, color: AppColors.blueDark),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            color: AppColors.blueDark,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}



