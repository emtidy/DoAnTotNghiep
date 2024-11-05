import 'package:coffee_cap/core/size/size.dart';
import 'package:coffee_cap/core/themes/theme_extensions.dart';
import 'package:flutter/material.dart';

import '../../../../core/colors/color.dart';

class ReceiptDialog extends StatelessWidget {
  final String receiptNumber;
  final String date;
  final String employee;
  final String table;
  final List<Map<String, dynamic>> items;
  final double totalAmount;

  const ReceiptDialog({
    super.key,
    required this.receiptNumber,
    required this.date,
    required this.employee,
    required this.table,
    required this.items,
    required this.totalAmount,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Styles.light,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: const EdgeInsets.all(20.0),
        width: context.width * 0.5,
        height: context.height,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "The Coffee House",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 10),
            Text(
              "Phiếu thanh toán",
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 10),
            Text(
              "Số phiếu: $receiptNumber",
              style: context.theme.textTheme.titleMedium?.copyWith(),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Text(
                  "Ngày tạo: ",
                  style: context.theme.textTheme.titleMedium?.copyWith(),
                ),
                const Spacer(),
                Text(
                  date,
                  style: context.theme.textTheme.titleMedium?.copyWith(),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  "Nhân viên: ",
                  style: context.theme.textTheme.titleMedium?.copyWith(),
                ),
                const Spacer(),
                Text(
                  employee,
                  style: context.theme.textTheme.titleMedium?.copyWith(),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  "Bàn: ",
                  style: context.theme.textTheme.titleMedium?.copyWith(),
                ),
                const Spacer(),
                Text(
                  table,
                  style: context.theme.textTheme.titleMedium?.copyWith(),
                ),
              ],
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      flex: 2,
                      child: Text(
                        "Tên món",
                        style: context.theme.textTheme.titleMedium?.copyWith(),
                      )),
                  Expanded(
                      child: Text(
                    "SL:",
                    style: context.theme.textTheme.titleMedium?.copyWith(),
                  )),
                  Expanded(
                    child: Text(
                      "Tổng",
                      style: context.theme.textTheme.titleMedium?.copyWith(),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
            for (var item in items)
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            flex: 2,
                            child: Text(
                              item['name'],
                              style: context.theme.textTheme.titleMedium
                                  ?.copyWith(overflow: TextOverflow.ellipsis),
                            )),
                        Expanded(
                            child: Text(
                          "${item['quantity']}",
                          style:
                              context.theme.textTheme.titleMedium?.copyWith(),
                        )),
                        Expanded(
                          child: Text(
                            "${item['price']} VND",
                            style: context.theme.textTheme.titleMedium
                                ?.copyWith(overflow: TextOverflow.ellipsis),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    flex: 3,
                    child: Text("Tổng tiền:",
                        style: context.theme.textTheme.titleMedium
                            ?.copyWith(overflow: TextOverflow.ellipsis))),
                Expanded(
                    child: Text("$totalAmount VND",
                        style: context.theme.textTheme.titleMedium
                            ?.copyWith(overflow: TextOverflow.ellipsis))),
              ],
            ),
            SizedBox(height: context.height * 0.04),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 40, vertical: 0),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Styles.green,
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      // border: Border.all(width: 0.5),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                            color: Styles.grey.withOpacity(0.2),
                            offset: const Offset(1.1, 1.1),
                            blurRadius: 5),
                      ],
                    ),
                    child: Text("Đóng",
                        style: context.theme.textTheme.headlineSmall?.copyWith(
                            overflow: TextOverflow.ellipsis,
                            color: Styles.light)),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 40),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Styles.green,
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      // border: Border.all(width: 0.5),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                            color: Styles.grey.withOpacity(0.2),
                            offset: const Offset(1.1, 1.1),
                            blurRadius: 5),
                      ],
                    ),
                    child: Text("In hóa đơn",
                        style: context.theme.textTheme.headlineSmall?.copyWith(
                            overflow: TextOverflow.ellipsis,
                            color: Styles.light)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
