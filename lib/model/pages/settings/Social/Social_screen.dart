import 'package:flutter/material.dart';

class ThietLapBanPage extends StatelessWidget {
  const ThietLapBanPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Kênh bán hàng",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SalesChannelItem(
                    channelName: "Grab Food",
                    onSettingsPressed: () {
                      _showChooseChannelDialog(context);
                    },
                    onDeletePressed: () {
                      // Implement delete functionality
                    },
                  ),
                  SalesChannelItem(
                    channelName: "Baemin",
                    onSettingsPressed: () {
                      _showChooseChannelDialog(context);
                    },
                    onDeletePressed: () {
                      // Implement delete functionality
                    },
                  ),
                  const Spacer(),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: FloatingActionButton(
                      onPressed: () {
                        // Implement add channel functionality
                      },
                      backgroundColor: Colors.green,
                      child: const Icon(Icons.add),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SalesChannelItem extends StatelessWidget {
  final String channelName;
  final VoidCallback onSettingsPressed;
  final VoidCallback onDeletePressed;

  const SalesChannelItem({
    Key? key,
    required this.channelName,
    required this.onSettingsPressed,
    required this.onDeletePressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: ListTile(
          title: Text(channelName),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: onSettingsPressed,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
                child: const Text(
                  'Thiết lập',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: onDeletePressed,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text(
                  'Xóa',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChooseChannelDialog extends StatelessWidget {
  const ChooseChannelDialog({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      titlePadding: EdgeInsets.zero, // Bỏ padding mặc định của tiêu đề
      title: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10.0),
            topRight: Radius.circular(10.0),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Chọn kênh bán hàng',
              style: TextStyle(color: Colors.white),
            ),
            IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var channel in [
            'Web Order',
            'CNV Loyalty',
            'Tại cửa hàng',
            'Shopee Food',
            'Baemin',
            'Gojek',
            'Loship',
            'Be',
            'Mang đi'
          ])
            ListTile(
              title: Text(channel),
              onTap: () {
                Navigator.pop(context, channel);
              },
            ),
        ],
      ),
    );
  }
}

void _showChooseChannelDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => const ChooseChannelDialog(),
  );
}
