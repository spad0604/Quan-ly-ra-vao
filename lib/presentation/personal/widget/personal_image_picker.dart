part of 'add_personal_popup.dart';

class PersonalImagePicker extends StatelessWidget {
  const PersonalImagePicker({super.key});

  @override
  Widget build(BuildContext context) {
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
            Container(
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
            ),
            const SizedBox(width: 16),
            TextButton(
              onPressed: () {},
              child: const Text(
                'Tải ảnh lên',
                style: TextStyle(
                  color: AppColors.blueDark,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
