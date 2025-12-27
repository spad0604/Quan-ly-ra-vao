part of '../home_view.dart';

class GuestTab extends GetView<GuestController> {
  const GuestTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        HomeHeader(
          title: 'anoymus_qr_reader'.tr,
          subtitle: 'dashboard_qr_description'.tr,
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Scan Button Area
                  Center(
                    child: Column(
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.qr_code_scanner, size: 60, color: AppColors.blueDark),
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: 200,
                          height: 48,
                          child: ElevatedButton.icon(
                            onPressed: () => controller.scanQrCode(),
                            icon: const Icon(Icons.document_scanner),
                            label: const Text('QUÉT CCCD / QR', style: TextStyle(fontWeight: FontWeight.bold)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.blueDark,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text('hoặc nhập thủ công thông tin bên dưới', style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  
                  // Form Fields
                  const Text('THÔNG TIN KHÁCH', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 24),
                  
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          controller: controller.idController,
                          label: 'Số CCCD / Định danh',
                          icon: Icons.credit_card,
                        ),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: _buildTextField(
                          controller: controller.nameController,
                          label: 'Họ và tên',
                          icon: Icons.person,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          controller: controller.dateOfBirthController,
                          label: 'Ngày sinh',
                          icon: Icons.calendar_today,
                        ),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: _buildTextField(
                          controller: controller.addressController,
                          label: 'Quê quán / Địa chỉ',
                          icon: Icons.home,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  
                  const Text('THÔNG TIN RA VÀO', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 24),
                  
                  _buildTextField(
                    controller: controller.reasonController,
                    label: 'Lý do vào / Nơi đến',
                    icon: Icons.description,
                    maxLines: 3,
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // Action Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton(
                        onPressed: () => controller.clearForm(),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                        ),
                        child: const Text('Xóa form'),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton.icon(
                        onPressed: () => controller.checkIn(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                        ),
                        icon: const Icon(Icons.login),
                        label: const Text('XÁC NHẬN VÀO (CHECK-IN)', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.grey)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: Colors.grey),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.blueDark, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
    );
  }
}
