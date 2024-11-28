import 'dart:convert';

import 'package:coffee_cap/model/invoice_item.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class InvoiceService {
  static const String _tableKey = 'table_invoices';
  static const String _generalKey = 'general_invoices';

  Future<void> saveInvoice(Invoice invoice,
      {bool isTableInvoice = false}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = isTableInvoice ? _tableKey : _generalKey;

      print('Saving invoice to key: $key');
      print('Invoice type: ${isTableInvoice ? "Table" : "General"}');

      List<String> existingInvoices = prefs.getStringList(key) ?? [];
      print('Existing invoices for $key: ${existingInvoices.length}');

      final invoiceJson = jsonEncode({
        ...invoice.toJson(),
        'isTableInvoice': isTableInvoice,
      });

      existingInvoices.add(invoiceJson);
      await prefs.setStringList(key, existingInvoices);

      print('After saving - invoices count: ${existingInvoices.length}');
      await debugPrintAllInvoices();

      final allInvoices = await getInvoices();
      _invoiceController.add(allInvoices);
    } catch (e) {
      print('Error in saveInvoice: $e');
      rethrow;
    }
  }

  Future<List<Invoice>> getInvoices({bool? isTableInvoice}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      List<Invoice> allInvoices = [];

      // Nếu isTableInvoice == null, lấy cả hai loại
      if (isTableInvoice == null || isTableInvoice) {
        final tableInvoices = prefs.getStringList(_tableKey) ?? [];
        print('Table invoices found: ${tableInvoices.length}');
        allInvoices.addAll(
            tableInvoices.map((json) => Invoice.fromJson(jsonDecode(json))));
      }

      if (isTableInvoice == null || !isTableInvoice) {
        final generalInvoices = prefs.getStringList(_generalKey) ?? [];
        print('General invoices found: ${generalInvoices.length}');
        allInvoices.addAll(
            generalInvoices.map((json) => Invoice.fromJson(jsonDecode(json))));
      }

      // Sắp xếp theo thời gian
      allInvoices.sort(
          (a, b) => DateTime.parse(b.date).compareTo(DateTime.parse(a.date)));

      return allInvoices;
    } catch (e) {
      print('Error getting invoices: $e');
      return [];
    }
  }

  // Thêm method để lấy hóa đơn theo loại
  Future<List<Invoice>> getTableInvoices() async {
    return getInvoices(isTableInvoice: true);
  }

  Future<List<Invoice>> getGeneralInvoices() async {
    return getInvoices(isTableInvoice: false);
  }

  // Method để xóa tất cả hóa đơn (để debug)
  Future<void> clearAllInvoices() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tableKey);
    await prefs.remove(_generalKey);
    print('Cleared all invoices');
  }

  // Method để debug
  Future<void> debugPrintAllInvoices() async {
    final prefs = await SharedPreferences.getInstance();
    final tableInvoices = prefs.getStringList(_tableKey) ?? [];
    final generalInvoices = prefs.getStringList(_generalKey) ?? [];

    print('\n=== DEBUG INVOICES ===');
    print('Table invoices: ${tableInvoices.length}');
    if (tableInvoices.isNotEmpty) {
      print('First table invoice: ${tableInvoices.first}');
    }
    print('General invoices: ${generalInvoices.length}');
    if (generalInvoices.isNotEmpty) {
      print('First general invoice: ${generalInvoices.first}');
    }
    print('=====================\n');
  }

  // Thêm StreamController để quản lý stream
  final _invoiceController = StreamController<List<Invoice>>.broadcast();
  Timer? _refreshTimer;

  // Thêm method để lấy stream
  Stream<List<Invoice>> getInvoicesStream() {
    // Load dữ liệu ngay lập tức
    _loadAndEmitInvoices();

    // Tạo timer để refresh định kỳ
    _refreshTimer = Timer.periodic(const Duration(seconds: 2), (_) {
      _loadAndEmitInvoices();
    });

    return _invoiceController.stream;
  }

  Future<void> _loadAndEmitInvoices() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.reload(); // Force reload từ disk

      final tableInvoices = prefs.getStringList(_tableKey) ?? [];
      final generalInvoices = prefs.getStringList(_generalKey) ?? [];

      List<Invoice> allInvoices = [
        ...tableInvoices.map((json) => Invoice.fromJson(jsonDecode(json))),
        ...generalInvoices.map((json) => Invoice.fromJson(jsonDecode(json)))
      ];

      // Sắp xếp theo thời gian
      allInvoices.sort(
          (a, b) => DateTime.parse(b.date).compareTo(DateTime.parse(a.date)));

      if (!_invoiceController.isClosed) {
        _invoiceController.add(allInvoices);
      }
    } catch (e) {
      print('Error loading invoices: $e');
    }
  }

  // Thêm dispose method
  void dispose() {
    _refreshTimer?.cancel();
    _invoiceController.close();
  }
}
