// Chứa các widget liên quan đến thanh toán
import 'package:flutter/material.dart';

Widget buildSummaryItem(String title, String amount, {bool isTotal = false}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: isTotal ? 16.0 : 14.0,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          amount,
          style: TextStyle(
            fontSize: isTotal ? 16.0 : 14.0,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    ),
  );
}

Widget buildPaymentOption(String label, String qrImagePath) {
  return Column(
    children: [
      Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          image: DecorationImage(
            image: AssetImage(qrImagePath),
            fit: BoxFit.cover,
          ),
        ),
      ),
      const SizedBox(height: 8.0),
      Text(label, style: const TextStyle(color: Colors.black)),
    ],
  );
}
