import 'package:coffee_cap/core/themes/theme_extensions.dart';
import 'package:flutter/material.dart';

import '../../../../core/colors/color.dart';
class FloorLayoutScreen extends StatefulWidget {
  const FloorLayoutScreen({super.key});

  @override
  _FloorLayoutScreenState createState() => _FloorLayoutScreenState();
}

class _FloorLayoutScreenState extends State<FloorLayoutScreen> {
  int _selectedButtonIndex = 1; // chỉ số để xác định button đang chọn
  final List<String> _buttons = ['Đang mở', 'Tầng trệt', 'Tầng 1']; // danh sách các nút

  // Dữ liệu mẫu cho các mục trong GridView
  final List<Map<String, dynamic>> open = [
    {'name': 'Tầng trệt bàn 1', 'people': 5, 'orders': 2, 'status': true},
    {'name': 'Tầng trệt bàn 2', 'people': 10, 'orders': 20, 'status': true},
    {'name': 'Tầng 1 bàn 3', 'people': 2, 'orders': 1, 'status': true},
    {'name': 'Tầng trệt bàn 4', 'people': 9, 'orders': 8, 'status': true},
    {'name': 'Tầng trệt bàn 5', 'people': 5, 'orders': 2, 'status': true},
    {'name': 'Tầng 1 bàn 6', 'people': 5, 'orders': 2, 'status': true},
  ];
  // Dữ liệu mẫu cho các mục trong GridView
  final List<Map<String, dynamic>> _floors = [
    {'name': 'Tầng trệt bàn 1', 'people': 5, 'orders': 2, 'status': true},
    {'name': 'Tầng trệt bàn 2', 'people': 0, 'orders': 0, 'status': false},
    {'name': 'Tầng trệt bàn 3', 'people': 0, 'orders': 0, 'status': false},
    {'name': 'Tầng trệt bàn 4', 'people': 0, 'orders': 0, 'status': false},
    {'name': 'Tầng trệt bàn 5', 'people': 5, 'orders': 2, 'status': true},
    {'name': 'Tầng trệt bàn 6', 'people': 5, 'orders': 2, 'status': true},
  ];
  // Dữ liệu mẫu cho các mục trong GridView
  final List<Map<String, dynamic>> _floors1 = [
    {'name': 'bàn 1', 'people': 5, 'orders': 2, 'status': true},
    {'name': 'bàn 2', 'people': 0, 'orders': 0, 'status': false},
    {'name': 'bàn 3', 'people': 0, 'orders': 0, 'status': false},
    {'name': 'bàn 4', 'people': 0, 'orders': 0, 'status': false},
    {'name': 'bàn 5', 'people': 5, 'orders': 2, 'status': true},
    {'name': 'bàn 6', 'people': 5, 'orders': 2, 'status': true},
  ];
  // Hàm để chuyển đổi chỉ số button khi nhấn
  void _onButtonPressed(int index) {
    setState(() {
      _selectedButtonIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Tạo các nút chọn trạng thái
        Padding(
          padding: const EdgeInsets.symmetric(horizontal:15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: List.generate(_buttons.length, (index) {
              return
                GestureDetector(
                  onTap: () => _onButtonPressed(index),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    margin: EdgeInsets.only(right: Styles.defaultPadding),
                    decoration: BoxDecoration(
                        color: _selectedButtonIndex == index
                            ? Styles.deepOrange // Màu khi button được chọn
                            : Styles.light,
                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                        border: Border.all(color:_selectedButtonIndex == index
                            ?Styles.deepOrange: Styles.dark)
                    ),
                    child: Text(_buttons[index],style: context.theme.textTheme.titleMedium?.copyWith(
                        color: _selectedButtonIndex == index
                            ? Styles.light
                            : Styles.dark
                    ),),
                  ),
                );
            }),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal:15.0,vertical: 10),
          child: Divider(thickness: 10,color: Colors.grey[300],),
        ),
        // Hiển thị các ô như trong hình ảnh
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(8.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, // Số cột
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1, // Tỷ lệ khung hình của mỗi ô
            ),
            itemCount:_selectedButtonIndex==0?
            open.length:_selectedButtonIndex==1?
            _floors.length:_floors1.length,
            itemBuilder: (context, index) {
              final floor =_selectedButtonIndex==0?open[index]:_selectedButtonIndex==1? _floors[index]:_floors1[index];
              return _buildFloorCard(floor);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFloorCard(Map<String, dynamic> floor) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: floor['status'] ? Colors.green[200] : Colors.grey[400],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: floor['status'] ? Colors.green : Colors.grey,
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
                    style:context.theme.textTheme.headlineSmall?.copyWith(
                        color: Styles.light)
                    ),
                // Thêm PopupMenuButton tại đây
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert, color: Colors.white),
                  onSelected: (String value) {
                    // Xử lý khi chọn menu item
                    switch (value) {
                      case 'add_order':
                      // Gọi hàm thêm order
                        break;
                      case 'notify_payment':
                      // Gọi hàm báo thanh toán
                        break;
                      case 'print_bill':
                      // Gọi hàm in tạm tính
                        break;
                      case 'payment':
                      // Gọi hàm thanh toán
                        break;
                    }
                  },
                  itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                    const PopupMenuItem<String>(
                      value: 'add_order',
                      child: ListTile(
                        leading: Icon(Icons.receipt_long),
                        title: Text('Thêm order'),
                      ),
                    ),
                    const PopupMenuItem<String>(
                      value: 'notify_payment',
                      child: ListTile(
                        leading: Icon(Icons.notifications),
                        title: Text('Báo thanh toán'),
                      ),
                    ),
                    const PopupMenuItem<String>(
                      value: 'print_bill',
                      child: ListTile(
                        leading: Icon(Icons.print),
                        title: Text('In tạm tính'),
                      ),
                    ),
                    const PopupMenuItem<String>(
                      value: 'payment',
                      child: ListTile(
                        leading: Icon(Icons.payment),
                        title: Text('Thanh toán'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                floor['name'],
                style:context.theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Styles.light
                    )
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Icon(Icons.receipt, color: Colors.white),
                Text(
                  ' ${floor['orders']}',
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(width: 10),
                const Icon(Icons.people, color: Colors.white),
                Text(
                  ' ${floor['people']}',
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
