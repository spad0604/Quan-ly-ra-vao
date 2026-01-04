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
                  // COM Port Selection
                  Obx(() {
                    final qrReaderController = controller.qrReaderController;
                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.usb, color: AppColors.blueDark),
                          const SizedBox(width: 12),
                          const Text(
                            'Cổng COM:',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: DropdownButton<String>(
                                value: qrReaderController.selectedPort.value,
                                isExpanded: true,
                                underline: const SizedBox(),
                                hint: const Text('Chọn cổng COM'),
                                items: qrReaderController.availablePorts.map((port) {
                                  return DropdownMenuItem<String>(
                                    value: port,
                                    child: Text(port),
                                  );
                                }).toList(),
                                onChanged: (String? newPort) {
                                  if (newPort != null) {
                                    qrReaderController.selectPort(newPort);
                                  }
                                },
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          IconButton(
                            icon: const Icon(Icons.refresh),
                            onPressed: () => qrReaderController.fetchPorts(),
                            tooltip: 'Làm mới danh sách cổng',
                          ),
                        ],
                      ),
                    );
                  }),
                  const SizedBox(height: 24),
                  
                  // Scan Button Area
                  Center(
                    child: Column(
                      children: [
                        Obx(() {
                          final isQrMode = controller.scanMode.value == 0;
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildModeButton(
                                text: 'scan_mode_qr'.tr,
                                isSelected: isQrMode,
                                onTap: () => controller.setMode(0),
                              ),
                              const SizedBox(width: 12),
                              _buildModeButton(
                                text: 'scan_mode_cccd'.tr,
                                isSelected: !isQrMode,
                                onTap: () => controller.setMode(1),
                              ),
                            ],
                          );
                        }),
                        const SizedBox(height: 20),
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
                            onPressed: () => controller.scanQrOrCccd(),
                            icon: const Icon(Icons.document_scanner),
                            label: Text(
                              'guest_scan_button'.tr,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.blueDark,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'guest_scan_hint'.tr,
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),

                  // QR result section (mode: QR)
                  Obx(() {
                    if (controller.scanMode.value != 0) return const SizedBox.shrink();
                    if (controller.lastScanMessage.value == null) {
                      return Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Text(
                          'qr_scan_ready_hint'.tr,
                          style: TextStyle(color: Colors.grey.shade700),
                        ),
                      );
                    }

                    final success = controller.lastScanIsSuccess.value;
                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: success ? Colors.green.shade50 : Colors.red.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: success ? Colors.green.shade200 : Colors.red.shade200,
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            success ? Icons.check_circle : Icons.error,
                            color: success ? Colors.green : Colors.red,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  controller.lastScanTitle.value ?? '',
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                if (controller.lastScanName.value != null) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    controller.lastScanName.value!,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                                const SizedBox(height: 4),
                                Text(controller.lastScanMessage.value ?? ''),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }),

                  // Guest form section (mode: CCCD/Guest)
                  Obx(() {
                    if (controller.scanMode.value != 1) return const SizedBox.shrink();
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'guest_info_title'.tr,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const SizedBox(height: 24),

                        Row(
                          children: [
                            Expanded(
                              child: _buildTextField(
                                controller: controller.idController,
                                label: 'guest_identity'.tr,
                                icon: Icons.credit_card,
                              ),
                            ),
                            const SizedBox(width: 24),
                            Expanded(
                              child: _buildTextField(
                                controller: controller.nameController,
                                label: 'guest_full_name'.tr,
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
                                label: 'guest_dob'.tr,
                                icon: Icons.calendar_today,
                              ),
                            ),
                            const SizedBox(width: 24),
                            Expanded(
                              child: _buildTextField(
                                controller: controller.addressController,
                                label: 'guest_address'.tr,
                                icon: Icons.home,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        Text(
                          'guest_entry_info_title'.tr,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const SizedBox(height: 24),

                        _buildTextField(
                          controller: controller.reasonController,
                          label: 'guest_reason'.tr,
                          icon: Icons.description,
                          maxLines: 3,
                        ),

                        const SizedBox(height: 40),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            OutlinedButton(
                              onPressed: () => controller.clearForm(),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                              ),
                              child: Text('guest_clear_form'.tr),
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
                              label: Text(
                                'guest_checkin_button'.tr,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  }),
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

  Widget _buildModeButton({
    required String text,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          color: isSelected ? AppColors.blueLight : Colors.white,
          border: Border.all(
            color: isSelected ? AppColors.blueDark : Colors.grey.shade300,
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: isSelected ? AppColors.blueDark : Colors.black87,
          ),
        ),
      ),
    );
  }
}
