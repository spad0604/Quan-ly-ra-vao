part of 'add_personal_popup.dart';

class PersonalImagePicker extends StatelessWidget {
  const PersonalImagePicker({super.key});

  @override
  Widget build(BuildContext context) {
    final personalController = Get.find<PersonalController>();
    final imageStorageService = ImageStorageService();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Ảnh thẻ (Tùy chọn)',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Obx(() {
              final imagePath = personalController.imageUrl.value;
              if (imagePath.isNotEmpty) {
                return FutureBuilder<String?>(
                  future: imageStorageService.getFullImagePath(imagePath),
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data != null) {
                      return Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey.shade300),
                          image: DecorationImage(
                            image: FileImage(File(snapshot.data!)),
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    }
                    return Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey.shade300),
                        color: Colors.grey.shade100,
                      ),
                      child: const Icon(
                        Icons.person_outline,
                        color: Colors.grey,
                        size: 32,
                      ),
                    );
                  },
                );
              }
              return Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey.shade300),
                  color: Colors.grey.shade100,
                ),
                child: const Icon(
                  Icons.person_outline,
                  color: Colors.grey,
                  size: 32,
                ),
              );
            }),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextButton(
                  onPressed: () async {
                    try {
                      final imagePath = await imageStorageService.pickImageWithSource();
                      if (imagePath != null) {
                        personalController.imageUrl.value = imagePath;
                        Get.snackbar(
                          'Thành công',
                          'Đã tải ảnh lên',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.green,
                          colorText: Colors.white,
                          duration: const Duration(seconds: 2),
                        );
                      }
                    } catch (e) {
                      Get.snackbar(
                        'Lỗi',
                        'Không thể tải ảnh: $e',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                      );
                    }
                  },
                  child: const Text(
                    'Tải ảnh lên',
                    style: TextStyle(
                      color: AppColors.blueDark,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Obx(() {
                  if (personalController.imageUrl.value.isNotEmpty) {
                    return TextButton(
                      onPressed: () {
                        personalController.imageUrl.value = '';
                      },
                      child: const Text(
                        'Xóa ảnh',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                }),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
