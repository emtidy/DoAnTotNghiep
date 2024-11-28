import 'package:coffee_cap/core/colors/color.dart';
import 'package:coffee_cap/core/size/size.dart';
import 'package:flutter/material.dart';

Widget buildProductItem(
    BuildContext context, String image, String title, int quantity, int price) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Row(
      children: [
        Container(
          width: context.height * 0.1,
          height: context.height * 0.1,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            image: DecorationImage(
              image: AssetImage(image),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(width: 16.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              Row(
                children: [
                  Text('x$quantity',
                      style: const TextStyle(color: Colors.grey)),
                  const SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: Styles.green.withOpacity(0.1),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                        border: Border.all(color: Styles.green)),
                    child: const Text('Notes',
                        style: TextStyle(color: Styles.green)),
                  )
                ],
              ),
            ],
          ),
        ),
        Text(
          '$priceđ',
          style: Theme.of(context)
              .textTheme
              .titleSmall
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    ),
  );
}
