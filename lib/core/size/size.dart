import 'package:flutter/cupertino.dart';

extension SizeX on BuildContext{
  double get width=>MediaQuery.of(this).size.width;
  double get height=>MediaQuery.of(this).size.height;
}
hideKeyBoard() async {
  FocusManager.instance.primaryFocus?.unfocus();
}