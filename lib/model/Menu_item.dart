import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_cap/core/assets.dart';

class MenuItem {
  final String id;
  final String title;
  final String description;
  final int price;
  final String image;
  final String category;
  final int selectedMood;
  final int selectedSize;
  final int selectedSugar;
  final int selectedIce;

  MenuItem({
    this.id = '',
    required this.title,
    required this.description,
    required this.price,
    required this.image,
    this.category = '',
    this.selectedMood = -1,
    this.selectedSize = -1,
    this.selectedSugar = -1,
    this.selectedIce = -1,
  });

  // Chuyển đổi từ Firestore
  factory MenuItem.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return MenuItem(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      price: int.parse(data['price'].toString()) ?? 0,
      image: data['image'] ?? Asset.imgProduct,
      category: data['category'] ?? '',
      selectedMood: int.parse(data['selectedMood']?.toString() ?? '-1'),
      selectedSize: int.parse(data['selectedSize']?.toString() ?? '-1'),
      selectedSugar: int.parse(data['selectedSugar']?.toString() ?? '-1'),
      selectedIce: int.parse(data['selectedIce']?.toString() ?? '-1'),
    );
  }

  // Chuyển đổi thành Map để lưu lên Firestore
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'price': price,
      'image': image,
      'category': category,
      'selectedMood': selectedMood,
      'selectedSize': selectedSize,
      'selectedSugar': selectedSugar,
      'selectedIce': selectedIce,
    };
  }
}

class MenuService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Lấy tất cả menu items
  Stream<List<MenuItem>> getMenuItems() {
    return _firestore.collection('menu_items').snapshots().map((snapshot) {
      if (snapshot.docs.isEmpty) {
        return allMenuItems; // Fallback to default data
      }
      return snapshot.docs.map((doc) => MenuItem.fromFirestore(doc)).toList();
    }).handleError((error) {
      print('Error fetching menu items: $error');
      return allMenuItems; // Fallback to default data on error
    });
  }

  // Thêm menu item mới
  Future<void> addMenuItem(MenuItem item) async {
    try {
      await _firestore.collection('menu_items').add(item.toMap());
    } catch (e) {
      print('Error adding menu item: $e');
      throw e;
    }
  }

  // Cập nhật menu item
  Future<void> updateMenuItem(String id, MenuItem item) async {
    try {
      await _firestore.collection('menu_items').doc(id).update(item.toMap());
    } catch (e) {
      print('Error updating menu item: $e');
      throw e;
    }
  }

  // Xóa menu item
  Future<void> deleteMenuItem(String id) async {
    try {
      await _firestore.collection('menu_items').doc(id).delete();
    } catch (e) {
      print('Error deleting menu item: $e');
      throw e;
    }
  }

  // Upload default data to Firebase (chỉ chạy một lần)
  Future<void> uploadDefaultData() async {
    try {
      final snapshot = await _firestore.collection('menu_items').get();
      if (snapshot.docs.isNotEmpty) {
        for (var item in allMenuItems) {
          await addMenuItem(item);
        }
        print('Default menu items uploaded successfully');
      }
    } catch (e) {
      print('Error uploading default data: $e');
    }
  }
}

final List<MenuItem> allMenuItems = [
  // Danh mục Coffee
  MenuItem(
    title: 'Cà phê sữa đá',
    description:
        'Cà phê pha phin truyền thống, kết hợp cùng sữa đặc thơm ngon.',
    price: 45000,
    image: 'assets/images/product/cafe_sua.jpeg',
    category: 'Coffee',
    selectedIce: -1,
    selectedMood: -1,
    selectedSize: -1,
    selectedSugar: -1,
  ),
  MenuItem(
    title: 'Cà phê đen',
    description: 'Vị cà phê đậm đà, thích hợp cho người yêu sự đơn giản.',
    price: 40000,
    image: 'assets/images/product/cafe_den.jpeg',
    category: 'Coffee',
    selectedIce: -1,
    selectedMood: -1,
    selectedSize: -1,
    selectedSugar: -1,
  ),
  MenuItem(
    title: 'Latte',
    description: 'Hương vị nhẹ nhàng, hài hòa giữa cà phê và sữa tươi.',
    price: 49000,
    image: 'assets/images/product/latte.jpeg',
    category: 'Coffee',
    selectedIce: -1,
    selectedMood: -1,
    selectedSize: -1,
    selectedSugar: -1,
  ),
  MenuItem(
    title: 'Cappuccino',
    description: 'Cà phê thơm lừng, kết hợp cùng lớp bọt sữa mềm mịn.',
    price: 52000,
    image: 'assets/images/product/cappuccino.jpeg',
    category: 'Coffee',
    selectedIce: -1,
    selectedMood: -1,
    selectedSize: -1,
    selectedSugar: -1,
  ),

  // Danh mục Trà
  MenuItem(
    title: 'Trà đào cam sả',
    description: 'Trà đào thơm mát, vị ngọt dịu cùng hương cam và sả.',
    price: 50000,
    image: 'assets/images/product/tra_dao_cam_sa.jpeg',
    category: 'Trà',
    selectedIce: -1,
    selectedMood: -1,
    selectedSize: -1,
    selectedSugar: -1,
  ),
  MenuItem(
    title: 'Trà sữa trân châu',
    description: 'Hương vị trà sữa đậm đà, đi kèm trân châu dai ngon.',
    price: 55000,
    image: 'assets/images/product/tra_sua_tran_chau.jpeg',
    category: 'Trà',
    selectedIce: -1,
    selectedMood: -1,
    selectedSize: -1,
    selectedSugar: -1,
  ),
  // MenuItem(
  //   title: 'Trà xanh matcha',
  //   description: 'Hương vị matcha đậm đà, hòa quyện cùng sữa tươi.',
  //   price: 49000,
  //   image: 'assets/images/product/matcha.jpeg',
  //   category: 'Trà',
  //   selectedIce: -1,
  //   selectedMood: -1,
  //   selectedSize: -1,
  //   selectedSugar: -1,
  // ),
  MenuItem(
    title: 'Trà hoa cúc mật ong',
    description: 'Trà hoa cúc thơm dịu, thêm vị ngọt tự nhiên từ mật ong.',
    price: 48000,
    image: 'assets/images/product/tra_hoa_cuc.jpeg',
    category: 'Trà',
    selectedIce: -1,
    selectedMood: -1,
    selectedSize: -1,
    selectedSugar: -1,
  ),

  // Danh mục Sinh tố
  MenuItem(
    title: 'Sinh tố xoài',
    description: 'Sinh tố từ xoài tươi, bổ sung vitamin C, thơm ngon.',
    price: 55000,
    image: 'assets/images/product/sinh_to_xoai.jpeg',
    category: 'Sinh tố',
    selectedIce: -1,
    selectedMood: -1,
    selectedSize: -1,
    selectedSugar: -1,
  ),
  MenuItem(
    title: 'Sinh tố dâu',
    description: 'Sinh tố dâu ngọt dịu, tươi mát, phù hợp với mọi lứa tuổi.',
    price: 60000,
    image: 'assets/images/product/sinh_to_dau.jpeg',
    category: 'Sinh tố',
    selectedIce: -1,
    selectedMood: -1,
    selectedSize: -1,
    selectedSugar: -1,
  ),
  MenuItem(
    title: 'Sinh tố bơ',
    description: 'Sinh tố bơ béo ngậy, giàu dưỡng chất và thơm ngon.',
    price: 65000,
    image: 'assets/images/product/sinh_to_bo.jpeg',
    category: 'Sinh tố',
    selectedIce: -1,
    selectedMood: -1,
    selectedSize: -1,
    selectedSugar: -1,
  ),
  MenuItem(
    title: 'Sinh tố chuối',
    description: 'Hương vị chuối tươi kết hợp cùng sữa chua.',
    price: 53000,
    image: 'assets/images/product/sinh_to_chuoi.jpeg',
    category: 'Sinh tố',
    selectedIce: -1,
    selectedMood: -1,
    selectedSize: -1,
    selectedSugar: -1,
  ),

  // Danh mục Nước ép
  MenuItem(
    title: 'Nước ép cam',
    description: 'Giàu vitamin C, giúp bạn tràn đầy năng lượng.',
    price: 50000,
    image: 'assets/images/product/nuoc_ep_cam.jpeg',
    category: 'Nước ép',
    selectedIce: -1,
    selectedMood: -1,
    selectedSize: -1,
    selectedSugar: -1,
  ),
  MenuItem(
    title: 'Nước ép dưa hấu',
    description: 'Giải nhiệt tức thì với nước ép từ dưa hấu tươi ngon.',
    price: 48000,
    image: 'assets/images/product/nuoc_ep_dua_hau.jpeg',
    category: 'Nước ép',
    selectedIce: -1,
    selectedMood: -1,
    selectedSize: -1,
    selectedSugar: -1,
  ),
  MenuItem(
    title: 'Nước ép táo',
    description: 'Hương vị thanh ngọt tự nhiên từ táo tươi.',
    price: 52000,
    image: 'assets/images/product/nuoc_ep_tao.jpeg',
    category: 'Nước ép',
    selectedIce: -1,
    selectedMood: -1,
    selectedSize: -1,
    selectedSugar: -1,
  ),
  MenuItem(
    title: 'Nước ép cà rốt',
    description: 'Thơm ngon và giàu dưỡng chất từ cà rốt tươi.',
    price: 55000,
    image: 'assets/images/product/nuoc_ep_ca_rot.jpeg',
    category: 'Nước ép',
    selectedIce: -1,
    selectedMood: -1,
    selectedSize: -1,
    selectedSugar: -1,
  ),

  // Danh mục Soda
  MenuItem(
    title: 'Soda việt quất',
    description: 'Sự kết hợp tươi mới giữa việt quất và soda mát lạnh.',
    price: 45000,
    image: 'assets/images/product/soda_viet_quat.jpeg',
    category: 'Soda',
    selectedIce: -1,
    selectedMood: -1,
    selectedSize: -1,
    selectedSugar: -1,
  ),
  MenuItem(
    title: 'Soda chanh dây',
    description: 'Hương vị độc đáo, sảng khoái từ chanh dây và soda.',
    price: 43000,
    image: 'assets/images/product/soda_chanh_day.jpeg',
    category: 'Soda',
    selectedIce: -1,
    selectedMood: -1,
    selectedSize: -1,
    selectedSugar: -1,
  ),
  MenuItem(
    title: 'Soda bạc hà',
    description: 'Hương bạc hà mát lạnh, kết hợp cùng soda tươi mát.',
    price: 42000,
    image: 'assets/images/product/soda_bac_ha.jpeg',
    category: 'Soda',
    selectedIce: -1,
    selectedMood: -1,
    selectedSize: -1,
    selectedSugar: -1,
  ),
  MenuItem(
    title: 'Soda dâu tây',
    description: 'Sự kết hợp ngọt ngào giữa dâu tây và soda mát lạnh.',
    price: 44000,
    image: 'assets/images/product/soda_dau_tay.jpeg',
    category: 'Soda',
    selectedIce: -1,
    selectedMood: -1,
    selectedSize: -1,
    selectedSugar: -1,
  ),
];
