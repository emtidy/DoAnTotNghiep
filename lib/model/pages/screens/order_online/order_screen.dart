import 'package:coffee_cap/core/size/size.dart';
import 'package:coffee_cap/core/themes/theme_extensions.dart';
import 'package:flutter/material.dart';

import '../../../../core/colors/color.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  int selectedIndex = 0;

  // Định nghĩa tem cho từng ngày trong tuần
  final Map<int, Map<String, String>> stampDesigns = {
    1: {
      // Thứ 2
      "name": "Monday Special",
      "design": "assets/stamps/monday.png",
      "description": "Tem Thứ 2 - Coffee Lover"
    },
    2: {
      // Thứ 3
      "name": "Tuesday Treat",
      "design": "assets/stamps/tuesday.png",
      "description": "Tem Thứ 3 - Tea Time"
    },
    3: {
      // Thứ 4
      "name": "Wednesday Delight",
      "design": "assets/stamps/wednesday.png",
      "description": "Tem Thứ 4 - Midweek Magic"
    },
    4: {
      // Thứ 5
      "name": "Thursday Charm",
      "design": "assets/stamps/thursday.png",
      "description": "Tem Thứ 5 - Sweet Treats"
    },
    5: {
      // Thứ 6
      "name": "Friday Joy",
      "design": "assets/stamps/friday.png",
      "description": "Tem Thứ 6 - Weekend Starter"
    },
    6: {
      // Thứ 7
      "name": "Saturday Bliss",
      "design": "assets/stamps/saturday.png",
      "description": "Tem Thứ 7 - Weekend Special"
    },
    7: {
      // Chủ nhật
      "name": "Sunday Serenity",
      "design": "assets/stamps/sunday.png",
      "description": "Tem Chủ Nhật - Premium Day"
    },
  };

  // Lấy thông tin tem cho ngày hiện tại
  Map<String, String> getCurrentDayStamp() {
    int currentWeekday = DateTime.now().weekday; // 1-7 (1 là thứ 2)
    return stampDesigns[currentWeekday] ??
        stampDesigns[1]!; // Mặc định là thứ 2 nếu có lỗi
  }

  // Lấy danh sách tất cả các tem
  List<Map<String, dynamic>> getAllStamps() {
    final now = DateTime.now();
    List<Map<String, dynamic>> allStamps = [];

    // Tạo tem mẫu cho cả 7 ngày
    for (int i = 1; i <= 7; i++) {
      final stamp = stampDesigns[i]!;
      allStamps.add({
        "id": "ST${now.millisecondsSinceEpoch + i}",
        "date": "${now.day - i}/${now.month}/${now.year}",
        "productName": stamp["name"],
        "amount": 45000,
        "customerName": "Khách hàng",
        "designUrl": stamp["design"],
        "description": stamp["description"],
        "used": true,
      });
    }
    return allStamps;
  }

  // Lấy tem theo tab đang chọn
  List<Map<String, dynamic>> getStampsByTab() {
    if (selectedIndex == 0) {
      // Tab "Tem hiện có" - chỉ hiện tem của ngày hôm nay
      return getStamps();
    } else {
      // Tab "Tem đã dùng" - hiện tất cả tem
      return getAllStamps();
    }
  }

  // Danh sách tem đổi thưởng mẫu
  List<Map<String, dynamic>> getStamps() {
    final currentStamp = getCurrentDayStamp();
    final now = DateTime.now();

    return [
      {
        "id": "ST${now.millisecondsSinceEpoch}",
        "date": "${now.day}/${now.month}/${now.year}",
        "productName": currentStamp["name"],
        "amount": 45000,
        "customerName": "Khách hàng A",
        "designUrl": currentStamp["design"],
        "description": currentStamp["description"],
      },
      // Thêm các tem mẫu khác nếu cần
    ];
  }

  @override
  Widget build(BuildContext context) {
    final stamps = getStampsByTab();
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Tem đổi thưởng",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                if (selectedIndex ==
                    0) // Chỉ hiển thị tem hôm nay ở tab "Tem hiện có"
                  Text(
                    "Hôm nay: ${getCurrentDayStamp()["name"]}",
                    style: const TextStyle(
                      color: Colors.brown,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                _buildTab("Tem hôm nay", 0),
                const SizedBox(width: 10),
                _buildTab("Tem theo tuần", 1),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 0.8,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                ),
                itemCount: stamps.length,
                itemBuilder: (context, index) => _buildStampCard(
                  stamps[index],
                  isUsed: selectedIndex == 1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStampCard(Map<String, dynamic> stamp, {bool isUsed = false}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isUsed
                ? [
                    Colors.grey.shade400,
                    Colors.grey.shade200,
                  ]
                : [
                    Colors.brown.shade300,
                    Colors.brown.shade100,
                  ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hình tem
            Expanded(
              flex: 2,
              child: Center(
                child: ColorFiltered(
                  colorFilter: ColorFilter.mode(
                    isUsed ? Colors.grey : Colors.transparent,
                    BlendMode.saturation,
                  ),
                  child: Image.asset(
                    stamp['designUrl'],
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            // Thông tin tem
            Text(
              stamp['productName'],
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isUsed ? Colors.grey.shade700 : Colors.white,
              ),
            ),
            // Text(
            //   'Ngày: ${stamp['date']}',
            //   style: TextStyle(
            //     color: isUsed ? Colors.grey.shade700 : Colors.white,
            //   ),
            // ),
            Text(
              stamp['description'],
              style: TextStyle(
                color: isUsed ? Colors.grey.shade700 : Colors.white,
                fontSize: 12,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            // Text(
            //   '${stamp['amount']}đ',
            //   style: TextStyle(
            //     color: isUsed ? Colors.grey.shade700 : Colors.white,
            //     fontWeight: FontWeight.bold,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(String title, int index) {
    bool isSelected = selectedIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.brown : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.brown,
            width: 1,
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.brown,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
