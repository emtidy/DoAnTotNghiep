import 'package:coffee_cap/core/themes/theme_extensions.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  final Function(int) onMenuItemTapped;
  SettingsScreen({required this.onMenuItemTapped});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.grey[300],
                      child: Icon(Icons.person_outline,
                          size: 60, color: Colors.grey[600]),
                    ),
                    title: Text(
                      'POSAPP CAFE',
                      style: context.theme.textTheme.headlineLarge,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ListTile(
                    title: Text(
                      'Quản Trị',
                      style: context.theme.textTheme.headlineLarge,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      onMenuItemTapped(8);
                    },
                    child: ListTile(
                      leading: Icon(
                        Icons.list,
                        size: 36,
                      ),
                      title: Text(
                        'Tài khoản nhân viên',
                        style: context.theme.textTheme.headlineMedium,
                      ),
                      trailing: Icon(
                        Icons.chevron_right,
                        size: 36,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      onMenuItemTapped(9);
                    },
                    child: ListTile(
                      leading: Icon(
                        Icons.group,
                        size: 36,
                      ),
                      title: Text(
                        'Thông tin nhân viên',
                        style: context.theme.textTheme.headlineMedium,
                      ),
                      trailing: Icon(
                        Icons.chevron_right,
                        size: 36,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ListTile(
                    title: Text(
                      'Thiết lập cửa hàng',
                      style: context.theme.textTheme.headlineLarge,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  // ListTile(
                  //   leading: Icon(
                  //     Icons.store,
                  //     size: 36,
                  //   ),
                  //   title: Text(
                  //     'Thông tin cửa hàng',
                  //     style: context.theme.textTheme.headlineMedium,
                  //   ),
                  //   trailing: Icon(
                  //     Icons.chevron_right,
                  //     size: 36,
                  //   ),
                  // // ),
                  // SizedBox(
                  //   height: 10,
                  // ),
                  // GestureDetector(
                  //   onTap: () {
                  //     onMenuItemTapped(
                  //         6);
                  //   },
                  //   child: ListTile(
                  //     leading: Icon(
                  //       Icons.print,
                  //       size: 36,
                  //     ),
                  //     title: Text(
                  //       'Quản lý bill',
                  //       style: context.theme.textTheme.headlineMedium,
                  //     ),
                  //     trailing: Icon(
                  //       Icons.chevron_right,
                  //       size: 36,
                  //     ),
                  //   ),
                  // ),
                  // SizedBox(
                  //   height: 10,
                  // ),
                  // GestureDetector(
                  //   onTap: () {
                  //     onMenuItemTapped(10);
                  //   },
                  //   child: ListTile(
                  //     leading: Icon(
                  //       Icons.point_of_sale,
                  //       size: 36,
                  //     ),
                  //     title: Text(
                  //       'Quản lý ',
                  //       style: context.theme.textTheme.headlineMedium,
                  //     ),
                  //     trailing: Icon(
                  //       Icons.chevron_right,
                  //       size: 36,
                  //     ),
                  //   ),
                  // ),
                  SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      onMenuItemTapped(11);
                    },
                    child: ListTile(
                      leading: Icon(
                        Icons.menu_book,
                        size: 36,
                      ),
                      title: Text(
                        'Thiết lập Menu',
                        style: context.theme.textTheme.headlineMedium,
                      ),
                      trailing: Icon(
                        Icons.chevron_right,
                        size: 36,
                      ),
                    ),
                  ),
                  Spacer(), // Thêm Spacer để đẩy nội dung lên và giữ ListTile cuối ở dưới cùng.
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
