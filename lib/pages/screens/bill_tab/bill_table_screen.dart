import 'package:coffee_cap/core/size/size.dart';
import 'package:coffee_cap/core/themes/theme_extensions.dart';
import 'package:coffee_cap/pages/screens/bill_tab/widget_bill/receipt_dialog.dart';
import 'package:flutter/material.dart';

import '../../../core/colors/color.dart';

class BillTableScreen extends StatelessWidget {
  const BillTableScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.calendar_today_outlined),
              const SizedBox(width: 5),
              Text('13/08/2024', style: context.theme.textTheme.headlineSmall),
              Container(
                padding: const EdgeInsets.all(15),
                margin: const EdgeInsets.only(left: 10),
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Styles.light),
                child: Text("The Coffee House",
                    style: context.theme.textTheme.headlineSmall),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Divider(
              thickness: 10,
              color: Colors.grey[300],
            ),
          ),
          Row(
            children: [
              Expanded(
                  child: Text(
                "Số hóa đơn",
                style: context.theme.textTheme.headlineSmall,
              )),
              Expanded(
                  child: Text(
                "Tên bàn ",
                style: context.theme.textTheme.headlineSmall,
              )),
              Expanded(
                  child: Text(
                "Số tiền",
                style: context.theme.textTheme.headlineSmall,
              )),
              Expanded(
                  child: Text(
                "Số lượng món",
                style: context.theme.textTheme.headlineSmall,
              )),
              Expanded(
                  child: Text(
                "Giờ vào",
                style: context.theme.textTheme.headlineSmall,
              )),
              Expanded(
                  child: Text(
                "Ngày",
                style: context.theme.textTheme.headlineSmall,
              )),
              Expanded(
                  child: Text(
                "Trạng thái",
                style: context.theme.textTheme.headlineSmall,
              )),
            ],
          ),
          SizedBox(
            height: context.height * 0.72,
            child: ListView.builder(
              // shrinkWrap: true,primary: true,
              // physics: const NeverScrollableScrollPhysics(),
              itemCount: 10,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => ReceiptDialog(
                        receiptNumber: "CH0000${index + 1}",
                        date: "13/08/2024 11:30:12",
                        employee: "T. Ngân",
                        table: "Tầng trệt 1",
                        items: const [
                          {
                            "name": "Trà Xanh Espresso Marble",
                            "quantity": 1,
                            "price": 35000
                          },
                          {
                            "name": "Caramel Macchiato",
                            "quantity": 2,
                            "price": 80000
                          },
                        ],
                        totalAmount: 75000,
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                        color: index % 2 == 0 ? null : Colors.green[50],
                        border: Border(
                            bottom: BorderSide(
                                width: 1, color: Colors.grey.shade300),
                            top: index == 0
                                ? BorderSide(
                                    width: 1, color: Colors.grey.shade300)
                                : BorderSide.none)),
                    child: Row(
                      children: [
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            "CH0000${index + 1}",
                            style: context.theme.textTheme.headlineSmall,
                          ),
                        )),
                        Expanded(
                            child: Text(
                          "Tầng trệt 1",
                          style: context.theme.textTheme.headlineSmall,
                        )),
                        Expanded(
                            child: Text(
                          "75,000 đ",
                          style: context.theme.textTheme.headlineSmall,
                        )),
                        Expanded(
                            child: Text(
                          "${index + 1}",
                          style: context.theme.textTheme.headlineSmall,
                        )),
                        Expanded(
                            child: Text(
                          "11:30:21",
                          style: context.theme.textTheme.headlineSmall,
                        )),
                        Expanded(
                            child: Text(
                          "${index + 1}/08/2024",
                          style: context.theme.textTheme.headlineSmall,
                        )),
                        Expanded(
                            child: Text(
                          "Chưa thanh toán",
                          style: context.theme.textTheme.headlineSmall,
                        )),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
