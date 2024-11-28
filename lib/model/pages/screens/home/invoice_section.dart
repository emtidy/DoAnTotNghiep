import 'package:coffee_cap/model/invoice_item.dart';
import 'package:coffee_cap/model/stamp.dart';
import 'package:coffee_cap/service.dart';
import 'package:coffee_cap/services/stamp_service.dart';
import 'package:flutter/material.dart';
import 'package:coffee_cap/core/colors/color.dart';
import 'package:coffee_cap/core/assets.dart';
import 'package:coffee_cap/core/themes/theme_extensions.dart';

import '../bill_tab/widget_bill/receipt_dialog.dart';

class InvoiceWidget extends StatelessWidget {
  final List<Map<String, dynamic>> invoiceItems;
  final double subtotal;
  final double vat;
  final double total;
  final VoidCallback onClearInvoice;
  final InvoiceService _invoiceService = InvoiceService();

  InvoiceWidget({
    Key? key,
    required this.invoiceItems,
    required this.subtotal,
    required this.vat,
    required this.total,
    required this.onClearInvoice,
  }) : super(key: key);

  Future<void> _showSuccessDialog(BuildContext context) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.check_circle_outline,
                color: Styles.green,
                size: 50,
              ),
              const SizedBox(height: 16),
              Text(
                'Thanh toán thành công!',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Hóa đơn đã được lưu vào lịch sử',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Đóng',
                style: TextStyle(color: Styles.green),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _handlePayment(BuildContext context) async {
    if (invoiceItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng thêm sản phẩm vào hóa đơn'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Tạo hóa đơn mới
    final invoice = Invoice(
      id: "CH${DateTime.now().microsecond}",
      date: DateTime.now().toString(),
      employee: "T. Ngân",
      table: "Tại Quầy",
      items: invoiceItems,
      total: total,
      subtotal: subtotal,
      vat: vat,
      isTableInvoice: true,
    );

    // Lưu hóa đơn
    await _invoiceService.saveInvoice(invoice, isTableInvoice: true);

    // Hiển thị dialog in hóa đơn
    if (context.mounted) {
      await showDialog(
        context: context,
        builder: (context) => ReceiptDialog(
          receiptNumber: invoice.id,
          date: invoice.date,
          employee: invoice.employee,
          table: invoice.table,
          items: invoice.items
              .map((item) => {
                    "name": item['title'],
                    "quantity": item['quantity'],
                    "price": item['price'],
                  })
              .toList(),
          totalAmount: invoice.total,
          subtotal: subtotal,
          vat: vat,
        ),
      );
    }

    // Hiển thị thông báo thành công
    if (context.mounted) {
      await _showSuccessDialog(context);
    }

    // Xóa hóa đơn hiện tại
    onClearInvoice();

    // Tạo tem đổi thưởng
    final stampService = StampService();
    final stamp = Stamp(
      id: 'ST${DateTime.now().millisecondsSinceEpoch}',
      date: DateTime.now(),
      productName: 'Coffee', // Thay bằng tên sản phẩm thực tế
      amount: total,
      customerName: 'Customer', // Thay bằng tên khách hàng thực tế
      designUrl: stampService.getStampDesignForDate(DateTime.now()),
    );

    await stampService.saveStamp(stamp);

    // Hiển thị thông báo
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Thanh toán Thành công')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 9),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Hóa đơn",
                  style: context.theme.textTheme.headlineSmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.history, color: Styles.green),
                  onPressed: () {
                    // Navigator.pushNamed(context, '/invoice-history');
                  },
                  tooltip: 'Xem lịch sử hóa đơn',
                ),
              ],
            ),
          ),
          Expanded(
            child: invoiceItems.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.receipt_long_outlined,
                          size: 48,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Chưa có sản phẩm nào',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: invoiceItems.length,
                    itemBuilder: (context, index) {
                      final item = invoiceItems[index];
                      return buildProductItem(
                        context,
                        item['image'],
                        item['title'],
                        item['quantity'],
                        item['price'],
                        item['options'],
                      );
                    },
                  ),
          ),
          if (invoiceItems.isNotEmpty) ...[
            const SizedBox(height: 16.0),
            buildSummaryItem('Tổng phụ', '${subtotal.toStringAsFixed(0)}đ'),
            buildSummaryItem('VAT (10%)', '${vat.toStringAsFixed(0)}đ'),
            const Divider(),
            buildSummaryItem('Tổng cộng', '${total.toStringAsFixed(0)}đ',
                isTotal: true),
            const SizedBox(height: 16.0),
            Text(
              'Thanh toán online',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildPaymentOption('Momo', Asset.qrMomo),
                buildPaymentOption('Vietcombank', Asset.qrVTB),
              ],
            ),
            const SizedBox(height: 16.0),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _handlePayment(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Styles.green,
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: const Text(
                  'Thanh toán',
                  style: TextStyle(fontSize: 16.0, color: Colors.white),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget buildProductItem(BuildContext context, String image, String title,
      int quantity, int price, String options) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            width: MediaQuery.of(context).size.height * 0.1,
            height: MediaQuery.of(context).size.height * 0.1,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              image: DecorationImage(
                image: AssetImage(image),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  options,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
                Row(
                  children: [
                    Text(
                      'x$quantity',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Text(
            '${price * quantity}đ',
            style: Theme.of(context)
                .textTheme
                .titleSmall
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

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
        Text(
          label,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
