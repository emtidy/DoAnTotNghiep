import 'package:flutter/material.dart';

extension CustomThemeExtension on BuildContext {
  ThemeData get theme => Theme.of(this);

  TextStyle get mediumTitle => theme.textTheme.titleMedium!;
  TextStyle get headLineMedium => theme.textTheme.headlineMedium!;
  TextStyle get headLineLarge => theme.textTheme.headlineLarge!;
  TextStyle get headLineSmall => theme.textTheme.headlineSmall!;
}
