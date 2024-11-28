import 'package:coffee_cap/model/stamp.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class StampCard extends StatelessWidget {
  final Stamp stamp;

  const StampCard({Key? key, required this.stamp}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              stamp.designUrl,
              height: 100,
              width: double.infinity,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 8),
            Text(
              'Ngày: ${DateFormat('dd/MM/yyyy').format(stamp.date)}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text('Sản phẩm: ${stamp.productName}'),
            Text('Giá trị: ${stamp.amount}đ'),
            Text('Khách hàng: ${stamp.customerName}'),
          ],
        ),
      ),
    );
  }
} 