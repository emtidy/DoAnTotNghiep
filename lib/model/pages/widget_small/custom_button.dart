import 'package:coffee_cap/core/size/size.dart';
import 'package:coffee_cap/core/themes/theme_extensions.dart';
import 'package:flutter/material.dart';

import '../../../core/colors/color.dart';
 
class CusButton extends StatelessWidget {
  final String text;
  final Color color;
  final VoidCallback onPressed;

  const CusButton({
    Key? key,
    required this.text,
    required this.color,
    required this.onPressed, SizedBox? child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: const EdgeInsets.only(left: 15, right: 15, top: 20),
        padding: const EdgeInsets.symmetric(vertical: 15),
        width: context.width,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: Styles.defaultBorderRadius,
          color: color,
        ),
        child: Text(
          text,
          style: context.theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Styles.light,
          ),
        ),
      ),
    );
  }
}
