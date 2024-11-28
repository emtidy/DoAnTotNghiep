import 'package:cloud_firestore/cloud_firestore.dart';
import '../core/assets.dart';

class Beverage {
  final String id;
  final String name;
  final String imageUrl;

  Beverage({
    this.id = '',
    required this.name,
    required this.imageUrl,
  });

  // Chuyển đổi từ Firestore
  factory Beverage.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return Beverage(
      id: doc.id,
      name: data['name'] ?? '',
      imageUrl: data['imageUrl'] ?? Asset.imgProduct1,
    );
  }

  // Chuyển đổi thành Map để lưu lên Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'imageUrl': imageUrl,
    };
  }
}

class BeverageService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Dữ liệu mặc định
  static final List<Beverage> defaultBeverages = [
    Beverage(
      name: 'Tất cả',
      imageUrl: Asset.imgProduct1,
    ),
    Beverage(
      name: 'Trà sữa',
      imageUrl: Asset.imgProduct1,
    ),
    Beverage(
      name: 'Coffee',
      imageUrl: Asset.imgProduct2,
    ),
    Beverage(
      name: 'Nước ép',
      imageUrl: Asset.imgProduct3,
    ),
    Beverage(
      name: 'Sinh tố',
      imageUrl: Asset.imgProduct4,
    ),
    Beverage(
      name: 'Soda',
      imageUrl: Asset.imgProduct5,
    ),
    Beverage(
      name: 'Trà xanh',
      imageUrl: Asset.imgProduct6,
    ),
    Beverage(
      name: 'Nước khoáng',
      imageUrl: Asset.imgProduct7,
    ),
  ];

  // Lấy danh mục đồ uống
  Stream<List<Beverage>> getBeverages() {
    return _firestore.collection('categories').snapshots().map((snapshot) {
      if (snapshot.docs.isEmpty) {
        return defaultBeverages; // Fallback to default data
      }
      return snapshot.docs.map((doc) => Beverage.fromFirestore(doc)).toList();
    }).handleError((error) {
      print('Error fetching categories: $error');
      return defaultBeverages; // Fallback to default data on error
    });
  }

  // Thêm danh mục
  Future<void> addBeverage(Beverage beverage) async {
    try {
      await _firestore.collection('categories').add(beverage.toMap());
    } catch (e) {
      print('Error adding category: $e');
      throw e;
    }
  }

  // Cập nhật danh mục
  Future<void> updateBeverage(String id, Beverage beverage) async {
    try {
      await _firestore
          .collection('categories')
          .doc(id)
          .update(beverage.toMap());
    } catch (e) {
      print('Error updating category: $e');
      throw e;
    }
  }

  // Xóa danh mục
  Future<void> deleteBeverage(String id) async {
    try {
      await _firestore.collection('categories').doc(id).delete();
    } catch (e) {
      print('Error deleting category: $e');
      throw e;
    }
  }

  // Upload dữ liệu mặc định lên Firebase (chỉ chạy một lần)
  Future<void> uploadDefaultData() async {
    try {
      final snapshot = await _firestore.collection('categories').get();
      if (snapshot.docs.isEmpty) {
        for (var beverage in defaultBeverages) {
          await addBeverage(beverage);
        }
        print('Default categories uploaded successfully');
      }
    } catch (e) {
      print('Error uploading default data: $e');
    }
  }
}
