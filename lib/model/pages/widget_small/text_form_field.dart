import 'package:flutter/material.dart';

import '../../../core/colors/color.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final Icon prefixIcon;
  final Color bg;
  final Color colorText;
  final String? Function(String?)? validator;
  final TextEditingController controller; // Thêm này

  const CustomTextField({
    super.key,
    required this.hintText,
    required this.prefixIcon,
    required this.bg,
    required this.colorText,
    required this.controller, // Thêm này
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Styles.defaultPadding),
      child: TextFormField(
        controller: controller, // Thêm này
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
            filled: true,
            fillColor: bg,
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              borderSide: BorderSide.none,
            ),
            hintText: hintText,
            hintStyle: TextStyle(
              color: colorText,
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
            prefixIcon: prefixIcon),
        validator: validator,
      ),
    );
  }
}
