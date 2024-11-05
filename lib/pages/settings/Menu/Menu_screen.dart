import 'package:coffee_cap/pages/widget_small/custom_button.dart';
import 'package:flutter/material.dart';

class MenuSetupScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_circle_outline, size: 80, color: Colors.grey),
            SizedBox(height: 20),
            Text("Chưa có menu nào, mời thêm vào menu",
                style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddMenuScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class AddMenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Thêm Menu"),
        actions: const [
          SizedBox(width: 20),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tên Menu
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Tên Menu',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),

              // Mô tả
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Mô tả',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              // Thứ ngày áp dụng
              const Text(
                "Thứ ngày áp dụng",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              GridView.count(
                shrinkWrap: true,
                crossAxisCount: 4, // Số cột cho các ngày trong tuần
                childAspectRatio:
                    3, // Điều chỉnh tỷ lệ giữa chiều rộng và chiều cao
                children: [
                  for (var day in [
                    "Thứ hai",
                    "Thứ ba",
                    "Thứ tư",
                    "Thứ năm",
                    "Thứ sáu",
                    "Thứ bảy",
                    "Chủ nhật"
                  ])
                    Row(
                      children: [
                        Checkbox(value: true, onChanged: (value) {}),
                        Text(day),
                      ],
                    ),
                ],
              ),

              const SizedBox(height: 20),

              // Món trong menu
              const Text(
                "Món trong menu",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              Column(
                children: [
                  for (var item in [
                    {
                      'name': 'Cà phê đá',
                      'price': '35,000đ',
                      'image': 'assets/images/product/img_product1.png'
                    },
                    {
                      'name': 'Bánh cake chuối',
                      'price': '35,000đ',
                      'image': 'assets/images/product/img_product1.png'
                    },
                    {
                      'name': 'Bánh cake dừa',
                      'price': '35,000đ',
                      'image': 'assets/images/product/img_product1.png'
                    },
                    {
                      'name': 'Cà phê đá xay',
                      'price': '35,000đ',
                      'image': 'assets/images/product/img_product1.png'
                    },
                    {
                      'name': 'Cacao đá',
                      'price': '35,000đ',
                      'image': 'assets/images/product/img_product1.png'
                    },
                  ])
                    CheckboxListTile(
                      value: true, // Giá trị ban đầu của checkbox
                      onChanged: (bool? value) {},
                      title: Row(
                        children: [
                          Image.asset(
                            item['image']!,
                            width: 40,
                            height: 40,
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item['name']!),
                              Text(item['price']!,
                                  style: const TextStyle(
                                      fontSize: 12, color: Colors.grey)),
                            ],
                          ),
                        ],
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 20),

              // Nút Lưu
              CusButton(
                text: 'Lưu',
                color: Colors.green,
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
