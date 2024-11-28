import 'package:coffee_cap/core/colors/color.dart';
import 'package:coffee_cap/core/size/size.dart';
import 'package:coffee_cap/core/themes/theme_extensions.dart';
import 'package:flutter/material.dart';

class BeverageContainer extends StatelessWidget {
  final String title;
  final String img;
  final bool isSelected;
  final VoidCallback onTap;

  const BeverageContainer({
    required this.title,
    required this.img,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        margin: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          color: isSelected ? Colors.greenAccent.withOpacity(0.1) : Styles.light,
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Styles.green.withOpacity(0.2),
              offset: const Offset(1.1, 1.1),
              blurRadius: 5,
            ),
          ],
          border: Border.all(
            width: 1,
            color: isSelected ? Styles.green : Styles.grey,
          ),
        ),
        child: Column(
          children: [
            Container(
              height: context.height * 0.07,
              width: context.width * 0.06,
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(15)),
                color: Styles.light,
                image: DecorationImage(
                  image: AssetImage(img),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            SizedBox(
              width: context.width * 0.055,
              child: Text(
                title,
                style: context.theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  overflow: TextOverflow.ellipsis,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
