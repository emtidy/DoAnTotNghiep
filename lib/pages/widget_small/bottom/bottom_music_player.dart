import 'package:coffee_cap/core/size/size.dart';
import 'package:flutter/material.dart';

import '../../../core/colors/color.dart';
class BottomMusicPlayer extends StatelessWidget {
  final String songName;
  final String artistName;
  final String albumArt;
  final VoidCallback onClose;

  const BottomMusicPlayer({
    super.key,
    required this.songName,
    required this.artistName,
    required this.albumArt,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      width: context.width,
      decoration: BoxDecoration(
        color: Styles.greyLight,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage:AssetImage(
                  albumArt,
                ) ,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      songName,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      artistName,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.pause_rounded,),
              const SizedBox(width: 12),
              const Icon(Icons.favorite_border, color: Colors.black87),
              const SizedBox(width: 12),
              const Icon(Icons.volume_up, color: Colors.black87),
              const SizedBox(width: 20),
              // Nút tắt thanh nhạc
              InkWell(onTap:onClose,child: const Icon(Icons.close, color: Colors.black87))
            ],
          ),
          Slider(
            value: 0.25,
            onChanged: (value) {},
            activeColor: Styles.blueIcon,
            inactiveColor: Styles.grey.withOpacity(0.4),
          ),
        ],
      ),
    );
  }
}
