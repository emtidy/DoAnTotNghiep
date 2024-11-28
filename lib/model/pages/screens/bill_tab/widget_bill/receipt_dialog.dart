import 'package:coffee_cap/core/size/size.dart';
import 'package:coffee_cap/core/themes/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReceiptDialog extends StatelessWidget {
  final String receiptNumber;
  final String date;
  final String employee;
  final String table;
  final List<Map<String, dynamic>> items;
  final double subtotal;
  final double vat;
  final double totalAmount;

  const ReceiptDialog({
    Key? key,
    required this.receiptNumber,
    required this.date,
    required this.employee,
    required this.table,
    required this.items,
    required this.subtotal,
    required this.vat,
    required this.totalAmount,
  }) : super(key: key);

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('dd/MM/yyyy HH:mm').format(date);
    } catch (e) {
      return dateString; // Return original string if parsing fails
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 400,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('The Coffee House',
                style: context.theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                )),
            const SizedBox(height: 8),
            Text('Phiếu thanh toán',
                style: context.theme.textTheme.titleLarge?.copyWith(
                  color: Colors.grey[700],
                )),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  _buildInfoRow('Số phiếu:', receiptNumber),
                  _buildInfoRow('Ngày tạo:', _formatDate(date)),
                  _buildInfoRow('Nhân viên:', employee),
                  _buildInfoRow('Bàn:', table),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ...items.map((item) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item['name'],
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500)),
                            Text('${item['quantity']}',
                                style: TextStyle(
                                    color: Colors.grey[600], fontSize: 13)),
                          ],
                        ),
                      ),
                      Text(
                          '${(item['quantity'] * item['price']).toStringAsFixed(0)}đ',
                          style: const TextStyle(fontWeight: FontWeight.w500)),
                    ],
                  ),
                )),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Divider(thickness: 1),
            ),
            _buildTotalRow('Tổng phụ:', subtotal),
            _buildTotalRow('VAT (10%):', vat),
            const SizedBox(height: 8),
            _buildTotalRow('Tổng cộng:', totalAmount, isTotal: true),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.print, size: 18),
                  label: const Text('In hóa đơn'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildTotalRow(String label, double amount, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
                fontSize: isTotal ? 16 : 14,
              )),
          Text(
            '${amount.toStringAsFixed(0)}đ',
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 16 : 14,
            ),
          ),
        ],
      ),
    );
  }
}
