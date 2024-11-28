import 'package:coffee_cap/core/colors/color.dart';
import 'package:coffee_cap/core/size/size.dart';
import 'package:coffee_cap/core/themes/theme_extensions.dart';
import 'package:coffee_cap/model/invoice_item.dart';
import 'package:coffee_cap/model/pages/screens/bill_tab/widget_bill/receipt_dialog.dart';
import 'package:coffee_cap/service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

class BillTableScreen extends StatefulWidget {
  const BillTableScreen({super.key});

  @override
  State<BillTableScreen> createState() => _BillTableScreenState();
}

class _BillTableScreenState extends State<BillTableScreen> {
  final InvoiceService _invoiceService = InvoiceService();
  List<Invoice> _invoices = [];
  int _currentPage = 1;
  final int _itemsPerPage = 10;

  late int _totalPages;
  List<Invoice> get _paginatedInvoices {
    final startIndex = (_currentPage - 1) * _itemsPerPage;
    final endIndex = startIndex + _itemsPerPage;
    if (startIndex >= _invoices.length) return [];
    return _invoices.sublist(
      startIndex,
      endIndex > _invoices.length ? _invoices.length : endIndex,
    );
  }

  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    _loadInvoices();
    // Refresh every 30 seconds
    _refreshTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      _loadInvoices();
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadInvoices() async {
    try {
      final invoices = await _invoiceService.getInvoices();
      if (mounted) {
        setState(() {
          _invoices = invoices
              .where((invoice) =>
                  invoice != null &&
                  invoice.items != null &&
                  invoice.total != null)
              .toList();
          _totalPages = (_invoices.length / _itemsPerPage).ceil();
        });

        // Kiểm tra và đồng bộ lên Firebase
        final firestore = FirebaseFirestore.instance;

        for (var invoice in _invoices) {
          try {
            // Kiểm tra xem hóa đơn đã tồn tại chưa
            final querySnapshot = await firestore
                .collection('invoice_history')
                .where('id', isEqualTo: invoice.id)
                .get();

            // Chỉ đẩy lên nếu hóa đơn chưa tồn tại
            if (querySnapshot.docs.isEmpty) {
              await firestore.collection('invoice_history').add({
                'id': invoice.id,
                'items': invoice.items
                    .map((item) => {
                          'title': item['title'],
                          'price': item['price'],
                          'quantity': item['quantity'],
                        })
                    .toList(),
                'totalAmount': invoice.total,
                'employee': invoice.employee,
                'table': invoice.table,
                'date': invoice.date,
                'status': 'Đã thanh toán',
                'createdAt': FieldValue.serverTimestamp(),
              });
              print('✅ Đã đồng bộ hóa đơn mới ${invoice.id} lên Firebase');
            }
          } catch (firebaseError) {
            print('❌ Lỗi khi đồng bộ hóa đơn lên Firebase: $firebaseError');
          }
        }
      }
    } catch (e) {
      print('❌ Lỗi khi load hóa đơn: $e');
      if (mounted) {
        setState(() {
          _invoices = [];
          _totalPages = 0;
        });
      }
    }
  }

  String _formatDateTime(String dateTimeStr) {
    final dateTime = DateTime.parse(dateTimeStr);
    return DateFormat('dd/MM/yyyy HH:mm:ss').format(dateTime);
  }

  String _formatDate(String dateTimeStr) {
    final dateTime = DateTime.parse(dateTimeStr);
    return DateFormat('dd/MM/yyyy').format(dateTime);
  }

  String _formatTime(String dateTimeStr) {
    final dateTime = DateTime.parse(dateTimeStr);
    return DateFormat('HH:mm:ss').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    final currentDate = DateFormat('dd/MM/yyyy').format(DateTime.now());

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.calendar_today_outlined),
              const SizedBox(width: 5),
              Text(currentDate, style: context.theme.textTheme.headlineSmall),
              Container(
                padding: const EdgeInsets.all(15),
                margin: const EdgeInsets.only(left: 10),
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Styles.light),
                child: Text("The Coffee House",
                    style: context.theme.textTheme.headlineSmall),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Divider(
              thickness: 10,
              color: Colors.grey[300],
            ),
          ),
          Row(
            children: [
              Expanded(
                  child: Text(
                "Số hóa đơn",
                style: context.theme.textTheme.headlineSmall,
              )),
              Expanded(
                  child: Text(
                "Thanh toán ",
                style: context.theme.textTheme.headlineSmall,
              )),
              Expanded(
                  child: Text(
                "Số tiền",
                style: context.theme.textTheme.headlineSmall,
              )),
              Expanded(
                  child: Text(
                "Số lượng món",
                style: context.theme.textTheme.headlineSmall,
              )),
              Expanded(
                  child: Text(
                "Giờ vào",
                style: context.theme.textTheme.headlineSmall,
              )),
              Expanded(
                  child: Text(
                "Ngày",
                style: context.theme.textTheme.headlineSmall,
              )),
              Expanded(
                  child: Text(
                "Trạng thái",
                style: context.theme.textTheme.headlineSmall,
              )),
            ],
          ),
          SizedBox(
            height: context.height *
                0.65, // Giảm chiều cao để chừa chỗ cho phân trang
            child: _invoices.isEmpty
                ? Center(
                    child: Text(
                      'Chưa có hóa đơn nào',
                      style: context.theme.textTheme.titleLarge,
                    ),
                  )
                : ListView.builder(
                    itemCount: _paginatedInvoices.length,
                    itemBuilder: (context, index) {
                      final invoice = _paginatedInvoices[index];
                      return GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => ReceiptDialog(
                              receiptNumber: invoice.id,
                              date: _formatDateTime(invoice.date),
                              employee: invoice.employee,
                              table: invoice.table,
                              items: invoice.items
                                  .map((item) => {
                                        'name': item['title'] ?? '',
                                        'quantity': item['quantity'] ?? 1,
                                        'price': item['price'] ?? 0,
                                      })
                                  .toList(),
                              totalAmount: invoice.total,
                              subtotal: invoice.total,
                              vat: 0.08,
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          decoration: BoxDecoration(
                              color: index % 2 == 0 ? null : Colors.green[50],
                              border: Border(
                                  bottom: BorderSide(
                                      width: 1, color: Colors.grey.shade300),
                                  top: index == 0
                                      ? BorderSide(
                                          width: 1, color: Colors.grey.shade300)
                                      : BorderSide.none)),
                          child: Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Text(
                                    invoice.id,
                                    style:
                                        context.theme.textTheme.headlineSmall,
                                    maxLines: 1,
                                  ),
                                ),
                              ),
                              Expanded(
                                  child: Text(
                                invoice.table,
                                style: context.theme.textTheme.headlineSmall,
                              )),
                              Expanded(
                                  child: Text(
                                "${invoice.total.toStringAsFixed(0)} đ",
                                style: context.theme.textTheme.headlineSmall,
                              )),
                              Expanded(
                                  child: Text(
                                "${invoice.items.length}",
                                style: context.theme.textTheme.headlineSmall,
                              )),
                              Expanded(
                                  child: Text(
                                _formatTime(invoice.date),
                                style: context.theme.textTheme.headlineSmall,
                              )),
                              Expanded(
                                  child: Text(
                                _formatDate(invoice.date),
                                style: context.theme.textTheme.headlineSmall,
                              )),
                              Expanded(
                                  child: Text(
                                "Đã thanh toán",
                                style: context.theme.textTheme.headlineSmall
                                    ?.copyWith(
                                  color: Styles.green,
                                ),
                              )),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),

          // Thêm phần phân trang
          if (_invoices.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.first_page),
                    onPressed: _currentPage > 1
                        ? () => setState(() => _currentPage = 1)
                        : null,
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_left),
                    onPressed: _currentPage > 1
                        ? () => setState(() => _currentPage--)
                        : null,
                  ),
                  const SizedBox(width: 20),
                  ...List.generate(
                    _totalPages,
                    (index) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _currentPage == index + 1
                              ? Styles.deepOrange
                              : Styles.light,
                          minimumSize: const Size(40, 40),
                          padding: EdgeInsets.zero,
                        ),
                        onPressed: () {
                          setState(() {
                            _currentPage = index + 1;
                          });
                        },
                        child: Text(
                          '${index + 1}',
                          style: TextStyle(
                            color: _currentPage == index + 1
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  IconButton(
                    icon: const Icon(Icons.chevron_right),
                    onPressed: _currentPage < _totalPages
                        ? () => setState(() => _currentPage++)
                        : null,
                  ),
                  IconButton(
                    icon: const Icon(Icons.last_page),
                    onPressed: _currentPage < _totalPages
                        ? () => setState(() => _currentPage = _totalPages)
                        : null,
                  ),
                ],
              ),
            ),

          // Hiển thị thông tin trang hiện tại
          if (_invoices.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                'Trang $_currentPage/${_totalPages} (${_invoices.length} hóa đơn)',
                style: context.theme.textTheme.titleMedium,
              ),
            ),
        ],
      ),
    );
  }
}
