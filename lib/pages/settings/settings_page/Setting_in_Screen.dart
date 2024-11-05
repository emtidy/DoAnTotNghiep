import 'package:coffee_cap/core/themes/theme_extensions.dart';
import 'package:flutter/material.dart';

class PrinterSettingsinPage extends StatefulWidget {
  @override
  _PrinterSettingsinPageState createState() => _PrinterSettingsinPageState();
}

class _PrinterSettingsinPageState extends State<PrinterSettingsinPage> {
  // Các biến lưu trạng thái của các Switch
  bool _receiptPrintSwitched = false;
  bool _servicePrintSwitched = false;
  bool _openDrawerSwitched = false;
  bool _retryPrintSwitched = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
                height: 16), // Khoảng cách giữa tiêu đề và danh sách máy in

            // Danh sách tùy chọn máy in
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    title: Text(
                      'In phiếu biên lai khi thanh toán',
                      style: context.theme.textTheme.headlineMedium,
                    ),
                    trailing: Switch(
                      value: _receiptPrintSwitched,
                      onChanged: (bool value) {
                        setState(() {
                          _receiptPrintSwitched = value;
                        });
                      },
                    ),
                  ),
                  Divider(),
                  ListTile(
                    title: Text(
                      'In phiếu dịch vụ khi thanh toán',
                      style: context.theme.textTheme.headlineMedium,
                    ),
                    trailing: Switch(
                      value: _servicePrintSwitched,
                      onChanged: (bool value) {
                        setState(() {
                          _servicePrintSwitched = value;
                        });
                      },
                    ),
                  ),
                  Divider(),
                  ListTile(
                    title: Text(
                      'Mở két khi thanh toán',
                      style: context.theme.textTheme.headlineMedium,
                    ),
                    trailing: Switch(
                      value: _openDrawerSwitched,
                      onChanged: (bool value) {
                        setState(() {
                          _openDrawerSwitched = value;
                        });
                      },
                    ),
                  ),
                  Divider(),
                  ListTile(
                    title: Text(
                      'Thử in lại khi gặp lỗi',
                      style: context.theme.textTheme.headlineMedium,
                    ),
                    trailing: Switch(
                      value: _retryPrintSwitched,
                      onChanged: (bool value) {
                        setState(() {
                          _retryPrintSwitched = value;
                        });
                      },
                    ),
                  ),
                  Divider(),
                ],
              ),
            ),

            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
