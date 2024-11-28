import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../model/invoice_item.dart';

class InvoiceHistoryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _key = 'invoices';

  Future<void> syncHistoryToFirebase() async {
    try {
      // Lấy dữ liệu từ SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final invoicesJson = prefs.getStringList(_key) ?? [];

      print('📝 Đang đồng bộ ${invoicesJson.length} hóa đơn lên Firebase');

      // Lưu từng hóa đơn lên Firebase
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

      print('✅ Đã đồng bộ xong lịch sử hóa đơn lên Firebase');
    } catch (e) {
      print('❌ Lỗi khi đồng bộ lịch sử: $e');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getInvoiceHistory() async {
    try {
      final querySnapshot = await _firestore
          .collection('invoice_history')
          .orderBy('date', descending: true)
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      print('❌ Lỗi khi lấy lịch sử hóa đơn: $e');
      return [];
    }
  }

  Future<void> saveInvoiceHistory(Invoice invoice) async {
    // Save invoice to history
    final historyData = {
      ...invoice.toMap(),
      'savedAt': DateTime.now().toIso8601String(),
    };
    // Implement your history storage logic here
  }
}
