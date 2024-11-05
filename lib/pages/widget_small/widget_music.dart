import 'package:coffee_cap/core/size/size.dart';
import 'package:flutter/material.dart';

import '../../core/colors/color.dart';
class CustomMusic extends StatelessWidget {
  final String img;
  final String rank;
  final String nameMusic;
  final String singer;
  final IconData icon;
  final VoidCallback onMorePressed;

  const CustomMusic({
    super.key,
    required this.img,
    required this.rank,
    required this.nameMusic,
    required this.singer,
    required this.icon,
    required this.onMorePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: context.height * 0.1,
          height: context.height * 0.1,
          margin: const EdgeInsets.only(right: 10, top: 10),
          alignment: Alignment.bottomRight,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            image: DecorationImage(
              image: AssetImage(img),
              fit: BoxFit.fitHeight,
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  rank,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                SizedBox(width: MediaQuery.of(context).size.width * 0.01),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.55,
                  child: Text(
                    nameMusic,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.ellipsis),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Icon(icon, size: 15, color: Colors.grey),
                SizedBox(width: context.width * 0.01),
                SizedBox(
                  width: context.width * 0.45,
                  child: Text(
                    singer,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(
                        fontWeight: FontWeight.bold, color: Colors.grey),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
        const Spacer(),
        InkWell(
          onTap: onMorePressed,
          child: const Icon(Icons.more_horiz),
        )
      ],
    );
  }
}