import 'package:coffee_cap/core/assets.dart';
import 'package:coffee_cap/core/colors/color.dart';
import 'package:coffee_cap/core/size/size.dart';
import 'package:coffee_cap/model/pages/screens/home/home_screen.dart';
import 'package:coffee_cap/model/pages/screens/order_online/order_screen.dart';
import 'package:coffee_cap/model/pages/screens/report/report_screens.dart';
import 'package:coffee_cap/model/pages/settings/Employee/Employee_Screen.dart';
import 'package:coffee_cap/model/pages/settings/Employee/Group_employee_screen.dart';
import 'package:coffee_cap/model/pages/settings/Menu/Menu_screen.dart';
import 'package:coffee_cap/model/pages/settings/Social/Social_screen.dart';
import 'package:coffee_cap/model/pages/settings/setting_page_screen.dart';
import 'package:coffee_cap/model/pages/settings/settings_page/Setting_in_Screen.dart';
import 'package:coffee_cap/model/pages/settings/settings_screen.dart';
import 'package:firestore_ref/firestore_ref.dart';

import 'package:flutter/material.dart';
import '../screens/bill_tab/bill_table_screen.dart';
import '../screens/table/floor_layout_screen/floor_layout_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AppLayout extends StatefulWidget {
  const AppLayout({
    super.key,
  });

  @override
  State<AppLayout> createState() => _AppLayoutState();
}

class _AppLayoutState extends State<AppLayout> {
  int _selectedIndex = 0;
  String userName = '';
  String role = '';

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Đọc thông tin user từ Firestore
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (userDoc.exists) {
        setState(() {
          userName = userDoc.data()?['name'] ?? 'Người dùng';
          role = userDoc.data()?['role'] ?? 'user';
        });
      }
    }
  }

  void _onMenuItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<String> menu = [
    "Chọn món",
    "Lịch sử hóa đơn",
    "Tem đổi thưởng",
    "Báo Cáo",
    "Chọn bàn",
    "Thiết Lập",
    "Thiết Lập Máy In",
    "Danh Sách ",
    "Tài khoản nhân viên.",
    "Danh Sách nhân viên",
    "Thiết lập bán",
    "Thiết lập bán",
    "Thiết lập Menu",
  ];
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Styles().hideKeyBoard(),
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).padding.top + 10),
            child: SizedBox(
              height: context.height,
              width: context.width,
              child: Row(
                children: [
                  _buildMenuItem(context),
                  Expanded(
                    child: Column(
                      children: [
                        _buildTopSection(context),
                        Expanded(
                          child: IndexedStack(
                            index: _selectedIndex,
                            children: _buildPages(),
                          ),
                        ),
                        // widget.body,
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Hàm xây dựng các trang con
  List<Widget> _buildPages() {
    // Các trang cơ bản mà tất cả users đều có thể truy cập
    final List<Widget> basicPages = [
      const HomeScreen(), // Trang Chủ
      const BillTableScreen(), // Lịch Sử
      const OrderScreen(), // Đơn Online
      ReportPage(), // Báo Cáo
      const FloorLayoutScreen(), // Tại Bàn
    ];

    // Các trang chỉ dành cho admin
    final List<Widget> adminPages = [
      SettingsScreen(onMenuItemTapped: _onMenuItemTapped),
      PrinterSettingsPage(onMenuItemTapped: _onMenuItemTapped),
      PrinterSettingsinPage(),
      EmployeeListScreen(),
      EmployeeGroupScreen(),
      ThietLapBanPage(),
      MenuSetupScreen(),
    ];

    // Trả về danh sách trang dựa trên role
    return role == 'admin' ? [...basicPages, ...adminPages] : basicPages;
  }

  // Hàm xây dựng phần top
  Widget _buildTopSection(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.84,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            menu[_selectedIndex],
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const Spacer(),
          // SizedBox(
          //   width: MediaQuery.of(context).size.width * 0.4,
          //   child: TextField(
          //     decoration: InputDecoration(
          //       hintText: "Tìm kiếm danh mục hoặc menu ",
          //       hintStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
          //             color: Styles.grey,
          //           ),
          //       border: const OutlineInputBorder(
          //         borderRadius: BorderRadius.all(Radius.circular(20)),
          //         borderSide: BorderSide.none,
          //       ),
          //       fillColor: Styles.light,
          //       filled: true,
          //       suffixIcon: const Icon(Icons.search, color: Styles.grey),
          //       enabledBorder: OutlineInputBorder(
          //         borderRadius: const BorderRadius.all(Radius.circular(20)),
          //         borderSide: BorderSide(
          //           color: Styles.grey.withOpacity(0.5),
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
          SizedBox(width: MediaQuery.of(context).size.width * 0.04),
          // IconButton(
          //   onPressed: () {},
          //   icon: const Icon(Icons.notifications_none, size: 35),
          // ),
          // Hero(
          //   tag: 'profile_${userName}',
          //   child: CircleAvatar(
          //     radius: 30,
          //     backgroundImage: AssetImage(
          //         Asset.bgImageAvatar), // Đảm bảo ảnh tồn tại trong assets
          //   ),
          // ),
          SizedBox(width: MediaQuery.of(context).size.width * 0.01),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                role == 'admin' ? "Chào quản trị viên" : "Chào nhân viên",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Styles.grey,
                    ),
              ),
              Text(
                userName,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Hàm xây dựng menu bên trái
  Widget _buildMenuItem(BuildContext context) {
    // Các menu item cơ bản cho tất cả users
    final List<MenuItemData> basicMenuItems = [
      MenuItemData("Trang Chủ", Icons.home_outlined, 0),
      MenuItemData("Lịch Sử", Icons.history, 1),
      MenuItemData("Tem", Icons.edit_calendar, 2),
      MenuItemData("Báo Cáo", Icons.calendar_month, 3),
      MenuItemData("Tại bàn", Icons.table_restaurant_outlined, 4),
    ];

    // Các menu item chỉ dành cho admin
    final List<MenuItemData> adminMenuItems = [
      MenuItemData("Cài đặt", Icons.settings_suggest_outlined, 5),
    ];

    // Chọn danh sách menu items dựa trên role
    final menuItems = role == 'admin'
        ? [...basicMenuItems, ...adminMenuItems]
        : basicMenuItems;

    return Column(
      children: [
        // Logo
        GestureDetector(
          onTap: () => _onMenuItemTapped(0),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.12,
            width: MediaQuery.of(context).size.height * 0.12,
            margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            decoration: BoxDecoration(
              color: Styles.light,
              image: const DecorationImage(
                image: AssetImage(Asset.iconLogo),
                fit: BoxFit.cover,
              ),
              boxShadow: [
                BoxShadow(
                  color: Styles.dark.withOpacity(0.2),
                  offset: const Offset(1.1, 1.1),
                  blurRadius: 5,
                ),
              ],
            ),
          ),
        ),

        // Menu Items
        ...menuItems.map((item) =>
            _buildMenuItemWidget(context, item.title, item.icon, item.index)),

        // Logout button
        const Spacer(),
        IconButton(
          onPressed: () async {
            await FirebaseAuth.instance.signOut();
            if (mounted) {
              Navigator.of(context).pushReplacementNamed('/signin');
            }
          },
          icon: const Icon(Icons.logout, size: 30, color: Styles.grey),
        ),
        SizedBox(height: 20),
      ],
    );
  }

  // Helper widget để xây dựng từng menu item
  Widget _buildMenuItemWidget(
      BuildContext context, String title, IconData icon, int index) {
    bool isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => _onMenuItemTapped(index),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.08,
        width: MediaQuery.of(context).size.width * 0.07,
        margin: const EdgeInsets.only(bottom: 16),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? Styles.green : Styles.light,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: Styles.dark.withOpacity(0.2),
              offset: const Offset(1.1, 1.1),
              blurRadius: 5,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon,
                color: isSelected ? Styles.light : Styles.dark, size: 30),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isSelected ? Styles.light : Styles.dark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MenuItemData {
  final String title;
  final IconData icon;
  final int index;

  MenuItemData(this.title, this.icon, this.index);
}
