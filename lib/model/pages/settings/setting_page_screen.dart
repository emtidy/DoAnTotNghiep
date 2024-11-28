import 'package:coffee_cap/core/themes/theme_extensions.dart';
import 'package:coffee_cap/model/pages/settings/settings_page/Setting_in_Screen.dart';
 import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PrinterSettingsPage extends StatelessWidget {
  final Function(int) onMenuItemTapped;
  PrinterSettingsPage({required this.onMenuItemTapped});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Phần tiêu đề tùy chọn in

            SizedBox(
                height: 16), // Khoảng cách giữa tiêu đề và danh sách máy in

            // Danh sách tùy chọn máy in
            Expanded(
              child: ListView(
                children: [
                  GestureDetector(
                    onTap: () {
                      // Chuyển sang trang cài đặt máy in
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PrinterSettingsinPage()),
                      );
                    },
                    child: ListTile(
                      title: Text(
                        'Thiết lập tùy chọn máy in',
                        style: context.theme.textTheme.headlineMedium,
                      ),
                      trailing: Icon(
                        Icons.chevron_right,
                        size: 36,
                      ),
                      onTap: () {
                        onMenuItemTapped(7);
                      },
                    ),
                  ),
                  Divider(),
                  ListTile(
                    title: Text(
                      'Máy in mặc định',
                      style: context.theme.textTheme.headlineMedium,
                    ),
                    trailing: Icon(
                      Icons.chevron_right,
                      size: 36,
                    ),
                    onTap: () {
                      // Điều hướng đến trang thiết lập Máy in mặc định
                    },
                  ),
                  Divider(), // Dòng phân cách giữa các mục

                  ListTile(
                    title: Text(
                      'Máy số 1',
                      style: context.theme.textTheme.headlineMedium,
                    ),
                    trailing: Icon(
                      Icons.chevron_right,
                      size: 36,
                    ),
                    onTap: () {
                      // Điều hướng đến trang thiết lập Máy số 1
                    },
                  ),
                  Divider(),

                  ListTile(
                    title: Text(
                      'Máy số 2',
                      style: context.theme.textTheme.headlineMedium,
                    ),
                    trailing: Icon(
                      Icons.chevron_right,
                      size: 36,
                    ),
                    onTap: () {
                      // Điều hướng đến trang thiết lập Máy số 2
                    },
                  ),
                  Divider(),
                ],
              ),
            ),

            // Button lưu thiết lập hoặc nút hành động khác
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
