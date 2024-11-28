import 'package:coffee_cap/core/colors/color.dart';
import 'package:coffee_cap/core/themes/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

Widget bottomInProduct(BuildContext context, String img, String title,
    bool isSelected, VoidCallback onTap) {
  return GestureDetector(
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.only(right: 12, top: 8, bottom: 8),
      child: Opacity(
        opacity: isSelected ? 0.5 : 1,
        child: CircleAvatar(
          backgroundColor: Styles.greyNearLight,
          radius: 20,
          child: title == ""
              ? Image.asset(img)
              : Text(
                  title,
                  style: context.theme.textTheme.headlineSmall,
                ),
        ),
      ),
    ),
  );
}

Widget buildOptionButton({
  required String option,
  required bool isSelected,
  required VoidCallback onTap,
  required dynamic context,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isSelected
            ? Colors.green.withOpacity(0.1)
            : Colors.grey.withOpacity(0.1),
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected ? Colors.green : Colors.grey,
        ),
      ),
      child: Text(
        option,
        style: context.theme.textTheme.titleSmall?.copyWith(
          color: isSelected ? Colors.green : Colors.grey,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}
