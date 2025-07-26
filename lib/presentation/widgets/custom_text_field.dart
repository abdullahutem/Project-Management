import 'package:flutter/material.dart';

Widget customTextField(
  TextEditingController controller,
  String label, {
  TextInputType keyboardType = TextInputType.text,
  String? Function(String?)? validator,
  bool obscureText = false,
  bool enabled = true,
  IconData? icon,
}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            obscureText: obscureText,
            enabled: enabled,
            validator:
                validator ??
                (value) => value == null || value.isEmpty ? 'مطلوب' : null,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: label,
              hintStyle: const TextStyle(color: Colors.grey),
            ),
          ),
        ),
      ],
    ),
  );
}
