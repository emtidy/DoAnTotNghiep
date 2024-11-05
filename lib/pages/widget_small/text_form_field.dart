import 'package:flutter/material.dart';

import '../../core/colors/color.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final Icon prefixIcon;
  final Color bg;
  final Color colorText;

  const CustomTextField({
    super.key,
    required this.hintText,
    required this.prefixIcon,
    required this.bg, required this.colorText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal:Styles.defaultPadding),
      child: TextFormField(
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
            filled: true, // Cho phép tô màu nền
            fillColor: bg,
            // border: const OutlineInputBorder(
            //   borderRadius: BorderRadius.all(
            //       Radius.circular(15)
            //   ),
            // ),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(15)), // Bo góc
              borderSide: BorderSide.none, // Loại bỏ viền
            ),
            hintText: hintText,
            hintStyle: TextStyle(
              color: colorText,
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
            prefixIcon: prefixIcon
        ),),
    );
  }
}
