import 'package:coffee_cap/core/size/size.dart';
import 'package:coffee_cap/core/themes/theme_extensions.dart';
import 'package:flutter/material.dart';

import '../../../core/colors/color.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  int selectedIndex = 0; // To manage selected tab
  int selectedOrderIndex = 0; // To manage selected order

  // Example data
  List<Map<String, dynamic>> orders = [
    {"id": 1240, "time": "17:06", "items": 4, "total": 15.90, "status": "Paid"},
    {"id": 1241, "time": "17:10", "items": 6, "total": 25.10, "status": "Paid"},
    {"id": 1242, "time": "17:14", "items": 2, "total": 6.50, "status": "Paid"},
    {"id": 1243, "time": "17:20", "items": 3, "total": 12.90, "status": "Paid"},
  ];

  // Example items in the order and their selected state
  List<bool> selectedItems = [false, false, false];

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
