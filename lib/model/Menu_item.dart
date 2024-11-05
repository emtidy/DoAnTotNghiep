import 'package:coffee_cap/core/assets.dart';

class MenuItem {
  final String title;
  final String description;
  final int price;
  final String image;
  final int selectedMood;
  final int selectedSize;
  final int selectedSugar;
  final int selectedIce;

  MenuItem({
    required this.title,
    required this.description,
    required this.price,
    required this.image,
    this.selectedMood = -1,
    this.selectedSize = -1,
    this.selectedSugar = -1,
    this.selectedIce = -1,
  });
}

 

final List<MenuItem> allMenuItems = [
  MenuItem(
    title: 'Trà xanh Espresso Marble',
    description:
        'Cho ngày thêm tươi, tỉnh, êm, mượt với Trà Xanh Espresso Marble.',
    price: 49000,
    image: Asset.imgProduct,
  ),
  MenuItem(
    title: 'Trà xanh Espresso Marble1',
    description:
        'Cho ngày thêm tươi, tỉnh, êm, mượt với Trà Xanh Espresso Marble.',
    price: 49000,
    image: Asset.imgProduct1,
  ),
  // Thêm các món ăn khác
];
