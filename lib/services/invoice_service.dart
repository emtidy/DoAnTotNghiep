import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import '../model/invoice_item.dart';
import '../services/invoice_history_service.dart';

class InvoiceService extends ChangeNotifier {
  static const String _key = 'invoices';
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final InvoiceHistoryService _historyService = InvoiceHistoryService();

  Future<void> saveInvoice(Invoice invoice) async {
    try {
      // Lưu vào SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      List<String> invoices = prefs.getStringList(_key) ?? [];
      invoices.add(jsonEncode(invoice.toMap()));
      await prefs.setStringList(_key, invoices);
      print('✅ Đã lưu vào SharedPreferences');

      // Lưu vào Firebase
      final invoiceData = {
        ...invoice.toMap(),
        'createdAt': FieldValue.serverTimestamp(),
        // 'staffName': invoice.staffName,
        // 'tableName': invoice.tableName,
        'items': invoice.items
            .map((item) => {
                  'title': item['title'],
                  'price': item['price'],
                  'quantity': item['quantity'],
                })
            .toList(),
      };

      final docRef = await _firestore.collection('invoices').add(invoiceData);
      print('✅ Đã lưu lên Firebase với ID: ${docRef.id}');
      print('📝 Dữ liệu đã lưu: $invoiceData');

      // Lưu vào lịch sử
      await _historyService.saveInvoiceHistory(invoice);
    } catch (e) {
      print('❌ Lỗi khi lưu hóa đơn: $e');
      rethrow;
    }
  }

  Future<List<Invoice>> getInvoices() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final invoicesJson = prefs.getStringList(_key) ?? [];

      print('📱 Đã load ${invoicesJson.length} hóa đơn từ SharedPreferences');

      // Đẩy dữ liệu lên Firebase
      for (String json in invoicesJson) {
        final invoiceData = jsonDecode(json);
        await _firestore.collection('invoice_history').add({
          'items': invoiceData['items'],
          'totalAmount': invoiceData['items'].fold(
              0.0, (sum, item) => sum + (item['price'] * item['quantity'])),
          'staffName': invoiceData['staffName'],
          'tableName': invoiceData['tableName'],
          'date': FieldValue.serverTimestamp(),
        });
      }

      print('✅ Đã đồng bộ ${invoicesJson.length} hóa đơn lên Firebase');

      // Xóa dữ liệu từ SharedPreferences sau khi đã đồng bộ
      await prefs.setStringList(_key, []);
      print('🗑️ Đã xóa dữ liệu từ SharedPreferences');

      return invoicesJson.map((json) {
        Map<String, dynamic> map = jsonDecode(json);
        return Invoice.fromMap(map);
      }).toList();
    } catch (e) {
      print('❌ Lỗi khi load và đồng bộ hóa đơn: $e');
      return [];
    }
  }

  // Hàm xóa hóa đơn
  Future<void> deleteInvoice(String invoiceId) async {
    try {
      await _firestore.collection('invoices').doc(invoiceId).delete();
    } catch (e) {
      print('Error deleting invoice: $e');
      rethrow;
    }
  }

  Stream<List<Invoice>> getInvoicesStream() {
    return _firestore
        .collection('invoices')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return Invoice.fromMap({...data, 'id': doc.id});
      }).toList();
    });
  }
}
