import 'package:flutter/material.dart';

Widget customDropdownField({
  required String? value,
  required List<DropdownMenuItem<String>> items,
  required Function(String?) onChanged,
  IconData? icon,
}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
    margin: const EdgeInsets.symmetric(vertical: 6),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: Colors.grey.shade400),
    ),
    child: Row(
      children: [
        if (icon != null) ...[
          Icon(icon, color: Colors.grey.shade700),
          const SizedBox(width: 10),
        ],
        Expanded(
          child: DropdownButtonFormField<String>(
            value: value,
            isExpanded: true,
            icon: const Icon(Icons.arrow_drop_down),
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: 'اختر الدور',
              hintStyle: TextStyle(
                fontFamily: "EXPOARABIC",
                color: Colors.grey,
              ),
            ),
            items: items,
            onChanged: onChanged,
            validator: (value) =>
                value == null || value.isEmpty ? 'الرجاء اختيار الدور' : null,
          ),
        ),
      ],
    ),
  );
}
