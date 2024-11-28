import 'package:flutter/material.dart';
import 'package:coffee_cap/model/table.dart';
import 'package:coffee_cap/core/colors/color.dart';
import 'package:coffee_cap/core/themes/theme_extensions.dart';

class PaymentDialog extends StatelessWidget {
  final TableModel table;

  const PaymentDialog({Key? key, required this.table}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.6,
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Thanh toán - ${table.name}',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 20),
            // Danh sách món đã order
            Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.4,
              ),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: table.orders.length,
                itemBuilder: (context, index) {
                  final order = table.orders[index];
                  return ListTile(
                    title: Text(order.productName),
                    subtitle: Text(
                      'Số lượng: ${order.quantity}\n'
                      'Tùy chọn: ${order.options.join(", ")}\n'
                      'Ghi chú: ${order.note}',
                    ),
                    trailing: Text(
                      '${(order.price * order.quantity).toStringAsFixed(0)}đ',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  );
                },
              ),
            ),
            const Divider(),
            // Thông tin thanh toán
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Tạm tính:'),
                      Text('${(table.totalAmount / 1.1).toStringAsFixed(0)}đ'),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('VAT (10%):'),
                      Text('${(table.totalAmount - table.totalAmount / 1.1).toStringAsFixed(0)}đ'),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Tổng cộng:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${table.totalAmount.toStringAsFixed(0)}đ',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Nút thanh toán
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Hủy'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context, true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Styles.green,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 15,
                    ),
                  ),
                  child: const Text('Xác nhận thanh toán'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
} 