part of 'add_personal_popup.dart';

class PersonalTextField extends StatelessWidget {
  final String label;
  final String? initialValue;
  final String? hintText;
  final TextEditingController? controller;

  const PersonalTextField({
    super.key,
    required this.label,
    this.initialValue,
    this.hintText,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          initialValue: controller == null ? initialValue : null,
          decoration: InputDecoration(
            hintText: hintText,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.blueLight.withOpacity(0.3)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.blueDark),
            ),
          ),
        ),
      ],
    );
  }
}

class PersonalDropdown extends StatelessWidget {
  final String label;
  final String? value;
  final List<String> items;
  final String? hintText;
  final ValueChanged<String?>? onChanged;

  const PersonalDropdown({
    super.key,
    required this.label,
    this.value,
    required this.items,
    this.hintText,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hintText,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.blueLight.withOpacity(0.3)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.blueDark),
            ),
          ),
        ),
      ],
    );
  }
}

class PersonalDatePicker extends StatelessWidget {
  final String label;
  final TextEditingController? controller;

  const PersonalDatePicker({
    super.key,
    required this.label,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    // Use ValueListenableBuilder to react to controller text changes
    if (controller != null) {
      return ValueListenableBuilder<TextEditingValue>(
        valueListenable: controller!,
        builder: (context, value, child) {
          final display = value.text;
          return _buildDatePickerContent(context, display);
        },
      );
    } else {
      return _buildDatePickerContent(context, null);
    }
  }

  Widget _buildDatePickerContent(BuildContext context, String? display) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () async {
            final now = DateTime.now();
            final initial = controller != null && controller!.text.isNotEmpty
                ? DateTime.tryParse(controller!.text) ?? now
                : now;
            final picked = await showDatePicker(
              context: context,
              initialDate: initial,
              firstDate: DateTime(1900),
              lastDate: DateTime(now.year + 1),
            );
            if (picked != null && controller != null) {
              controller!.text = '${picked.month.toString().padLeft(2, '0')}/${picked.day.toString().padLeft(2, '0')}/${picked.year}';
            }
          },
          child: InputDecorator(
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppColors.blueLight.withOpacity(0.3)),
              ),
              suffixIcon: const Icon(Icons.calendar_today_outlined, size: 20),
            ),
            child: Text(
              display != null && display.isNotEmpty ? display : 'mm/dd/yyyy',
              style: TextStyle(
                color: display != null && display.isNotEmpty ? Colors.black87 : Colors.grey,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
