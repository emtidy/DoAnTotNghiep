// services/firebase_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Map<String, dynamic>>> getMenuItemsStream() {
    return _firestore.collection('menu_items').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return {
          'id': doc.id,
          'title': data['title'],
          'description': data['description'],
          'price': data['price'],
          'image': data['image'],
          'selectedMood': -1,
          'selectedSize': -1,
          'selectedSugar': -1,
          'selectedIce': -1,
        };
      }).toList();
    });
  }

  Future<void> addInvoice(Map<String, dynamic> invoiceData) async {
    await _firestore.collection('invoices').add(invoiceData);
  }

  Future<void> getInvoiceTotals(Function(List<Map<String, dynamic>>, double, double, double) callback) async {
    final querySnapshot = await _firestore.collection('invoices').get();
    double subtotal = 0;
    List<Map<String, dynamic>> invoiceItems = [];

    for (var doc in querySnapshot.docs) {
      Map<String, dynamic> data = doc.data();
      subtotal += (data['price'] as int) * (data['quantity'] as int);
      invoiceItems.add(data);
    }

    double vat = subtotal * 0.1;
    double total = subtotal + vat;

    callback(invoiceItems, subtotal, vat, total);
  }
}
