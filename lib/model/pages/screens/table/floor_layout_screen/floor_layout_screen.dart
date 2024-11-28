import 'package:coffee_cap/core/themes/theme_extensions.dart';
import 'package:coffee_cap/model/invoice_item.dart';
import 'package:coffee_cap/service.dart';
import 'package:flutter/material.dart';
import 'package:coffee_cap/model/table.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../../../../../core/colors/color.dart';
import '../../floor/dialogs/order_dialog.dart';
import '../../floor/dialogs/payment_dialog.dart';

class FloorLayoutScreen extends StatefulWidget {
  const FloorLayoutScreen({super.key});

  @override
  _FloorLayoutScreenState createState() => _FloorLayoutScreenState();
}

class _FloorLayoutScreenState extends State<FloorLayoutScreen> {
  int _selectedButtonIndex = 1;
  final List<String> _buttons = ['Đang ngồi ', 'Tầng trệt', 'Tầng 1'];
  final List<TableModel> _tables = [];

  @override
  void initState() {
    super.initState();
    _initializeTables();
  }

  void _initializeTables() {
    _tables.addAll([
      // Tầng trệt
      TableModel(
        id: 'T1',
        name: 'Tầng trệt bàn 1',
        floor: 'Tầng trệt',
        isOccupied: false,
        numberOfPeople: 0,
      ),
      TableModel(
        id: 'T2',
        name: 'Tầng trệt bàn 2',
        floor: 'Tầng trệt',
        isOccupied: false,
        numberOfPeople: 0,
      ),
      TableModel(
        id: 'T3',
        name: 'Tầng trệt bàn 3',
        floor: 'Tầng trệt',
        isOccupied: false,
        numberOfPeople: 0,
      ),
      TableModel(
        id: 'T4',
        name: 'Tầng trệt bàn 4',
        floor: 'Tầng trệt',
        isOccupied: false,
        numberOfPeople: 0,
      ),
      TableModel(
        id: 'T5',
        name: 'Tầng trệt bàn 5',
        floor: 'Tầng trệt',
        isOccupied: false,
        numberOfPeople: 0,
      ),
      TableModel(
        id: 'T6',
        name: 'Tầng trệt bàn 6',
        floor: 'Tầng trệt',
        isOccupied: false,
        numberOfPeople: 0,
      ),
      // Tầng 1
      TableModel(
        id: 'F1',
        name: 'Tầng 1 bàn 1',
        floor: 'Tầng 1',
        isOccupied: false,
        numberOfPeople: 0,
      ),
      TableModel(
        id: 'F2',
        name: 'Tầng 1 bàn 2',
        floor: 'Tầng 1',
        isOccupied: false,
        numberOfPeople: 0,
      ),
      TableModel(
        id: 'F3',
        name: 'Tầng 1 bàn 3',
        floor: 'Tầng 1',
        isOccupied: false,
        numberOfPeople: 0,
      ),
      TableModel(
        id: 'F4',
        name: 'Tầng 1 bàn 4',
        floor: 'Tầng 1',
        isOccupied: false,
        numberOfPeople: 0,
      ),
      TableModel(
        id: 'F5',
        name: 'Tầng 1 bàn 5',
        floor: 'Tầng 1',
        isOccupied: false,
        numberOfPeople: 0,
      ),
      TableModel(
        id: 'F6',
        name: 'Tầng 1 bàn 6',
        floor: 'Tầng 1',
        isOccupied: false,
        numberOfPeople: 0,
      ),
    ]);
  }

  List<TableModel> get _currentTables {
    switch (_selectedButtonIndex) {
      case 0:
        return _tables.where((table) => table.isOccupied).toList();
      case 1:
        return _tables.where((table) => table.floor == 'Tầng trệt').toList();
      case 2:
        return _tables.where((table) => table.floor == 'Tầng 1').toList();
      default:
        return [];
    }
  }

  void _handleAddOrder(TableModel table) async {
    final orderData = await showDialog(
      context: context,
      builder: (context) => OrderDialog(table: table),
    );

    if (orderData != null && orderData['items'] != null) {
      setState(() {
        try {
          final List<OrderItem> orderItems = (orderData['items'] as List)
              .where((item) => item != null)
              .map((item) {
            var itemMap = Map<String, dynamic>.from(item as Map);
            itemMap['orderTime'] =
                itemMap['orderTime'] ?? DateTime.now().toIso8601String();
            return OrderItem.fromMap(itemMap);
          }).toList();

          if (orderItems.isNotEmpty) {
            table.orders.addAll(orderItems);
            table.isOccupied = true;
            table.numberOfPeople = orderData['numberOfPeople'] ?? 1;
            table.totalAmount += _calculateTotal(orderItems);
          }
        } catch (e, stackTrace) {
          debugPrint('Error processing order: $e');
          debugPrint('Stack trace: $stackTrace');
        }
      });
    }
  }

  double _calculateTotal(List<OrderItem> orders) {
    return orders.fold(
      0,
      (total, item) => total + (item.price * item.quantity),
    );
  }

  void _handlePayment(TableModel table) async {
    if (!table.isOccupied) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bàn này chưa có khách')),
      );
      return;
    }

    final confirmed = await showDialog(
      context: context,
      builder: (context) => PaymentDialog(table: table),
    );

    if (confirmed == true) {
      try {
        await _saveToInvoiceHistory(table);

        setState(() {
          table.orders.clear();
          table.isOccupied = false;
          table.numberOfPeople = 0;
          table.totalAmount = 0;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Thanh toán thành công')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi khi thanh toán: $e')),
        );
      }
    }
  }

  Future<void> _saveToInvoiceHistory(TableModel table) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final now = DateTime.now();

      final invoice = Invoice(
        id: 'CH${now.millisecondsSinceEpoch}',
        date: now.toIso8601String(),
        employee: 'T. Ngân',
        table: table.name,
        items: table.orders
            .map((order) => {
                  'title': order.productName,
                  'price': order.price,
                  'quantity': order.quantity,
                  'image': 'assets/images/product/img_product.png',
                  'options': order.options.join(', '),
                })
            .toList(),
        subtotal: table.totalAmount,
        vat: table.totalAmount * 0.1,
        total: table.totalAmount * 1.1,
      );

      final invoiceService = InvoiceService();
      await invoiceService.saveInvoice(
        invoice,
        isTableInvoice: true,
      );

      print('Successfully saved table invoice: ${invoice.id}');
    } catch (e, stackTrace) {
      print('Error saving invoice: $e');
      print('Stack trace: $stackTrace');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> _getAllInvoices() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String> invoiceIds = prefs.getStringList('invoice_ids') ?? [];

      List<Map<String, dynamic>> invoices = [];
      for (String id in invoiceIds) {
        final String? invoiceJson = prefs.getString('invoice_$id');
        if (invoiceJson != null) {
          invoices.add(json.decode(invoiceJson));
        }
      }

      return invoices;
    } catch (e) {
      print('Error getting invoices: $e');
      return [];
    }
  }

  Future<void> _clearAllInvoices() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String> invoiceIds = prefs.getStringList('invoice_ids') ?? [];

      // Xóa từng hóa đơn
      for (String id in invoiceIds) {
        await prefs.remove('invoice_$id');
      }

      // Xóa danh sách ID
      await prefs.remove('invoice_ids');

      print('Cleared all invoices');
    } catch (e) {
      print('Error clearing invoices: $e');
    }
  }

  Future<void> _saveTables() async {
    // TODO: Implement save tables state
  }

  void _printTemporaryBill(TableModel table) {
    // TODO: Implement print temporary bill
  }

  void _onButtonPressed(int index) {
    setState(() {
      _selectedButtonIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: List.generate(_buttons.length, (index) {
              return GestureDetector(
                onTap: () => _onButtonPressed(index),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  margin: EdgeInsets.only(right: Styles.defaultPadding),
                  decoration: BoxDecoration(
                    color: _selectedButtonIndex == index
                        ? Styles.deepOrange
                        : Styles.light,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    border: Border.all(
                      color: _selectedButtonIndex == index
                          ? Styles.deepOrange
                          : Styles.dark,
                    ),
                  ),
                  child: Text(
                    _buttons[index],
                    style: context.theme.textTheme.titleMedium?.copyWith(
                      color: _selectedButtonIndex == index
                          ? Styles.light
                          : Styles.dark,
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
          child: Divider(thickness: 10, color: Colors.grey[300]),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(8.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1,
            ),
            itemCount: _currentTables.length,
            itemBuilder: (context, index) {
              return _buildFloorCard(_currentTables[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFloorCard(TableModel table) {
    final bool isAvailable = !table.isOccupied;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: isAvailable ? Colors.grey[400] : Colors.green[200],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: isAvailable ? Colors.grey : Colors.green,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "The Coffee House",
                  style: context.theme.textTheme.headlineSmall?.copyWith(
                    color: Styles.light,
                  ),
                ),
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert, color: Colors.white),
                  onSelected: (String value) {
                    switch (value) {
                      case 'add_order':
                        _handleAddOrder(table);
                        break;
                      case 'payment':
                        _handlePayment(table);
                        break;
                      case 'print_bill':
                        _printTemporaryBill(table);
                        break;
                    }
                  },
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<String>>[
                    const PopupMenuItem<String>(
                      value: 'add_order',
                      child: ListTile(
                        leading: Icon(Icons.receipt_long),
                        title: Text('Thêm order'),
                      ),
                    ),
                    if (table.isOccupied) ...[
                      // const PopupMenuItem<String>(
                      //   value: 'print_bill',
                      //   child: ListTile(
                      //     leading: Icon(Icons.print),
                      //     title: Text('In tạm tính'),
                      //   ),
                      // ),
                      const PopupMenuItem<String>(
                        value: 'payment',
                        child: ListTile(
                          leading: Icon(Icons.payment),
                          title: Text('Thanh toán'),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    table.name,
                    style: context.theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Styles.light,
                    ),
                  ),
                  if (table.isOccupied)
                    Text(
                      '${table.totalAmount.toStringAsFixed(0)}đ',
                      style: context.theme.textTheme.titleMedium?.copyWith(
                        color: Styles.light,
                      ),
                    ),
                ],
              ),
            ),
          ),
          if (table.isOccupied)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Icon(Icons.receipt, color: Colors.white),
                  Text(
                    ' ${table.orders.length}',
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(width: 10),
                  const Icon(Icons.people, color: Colors.white),
                  Text(
                    ' ${table.numberOfPeople}',
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
