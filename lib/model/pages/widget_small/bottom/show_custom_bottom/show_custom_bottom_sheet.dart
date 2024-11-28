import 'package:flutter/material.dart';

class BottomMusicPlayer extends StatelessWidget {
  final List<String> options;
  final int selectedIndex;
  final ValueChanged<int> onOptionSelected;
  final String title;

  const BottomMusicPlayer({super.key,
    required this.options,
    required this.selectedIndex,
    required this.onOptionSelected,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.center,
            child: Container(
              height: 5.0,
              width: MediaQuery.of(context).size.width * 0.15,
              margin: const EdgeInsets.symmetric(vertical: 10.0),
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              fontWeight: FontWeight.w500
            ),
          ),
          const Divider(),
          ...options.asMap().entries.map((entry) {
            int index = entry.key;
            String title = entry.value;
            return _buildOptionTile(context, title, index);
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildOptionTile(BuildContext context, String title, int index) {
    return ListTile(
      title: Text(
        title,
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: selectedIndex == index?FontWeight.bold:null
        ),
      ),
      trailing: selectedIndex == index ? Icon(Icons.check, color: Colors.blue) : null,
      onTap: () {
        onOptionSelected(index);
        Navigator.pop(context);
      },
    );
  }
}

void showCustomSoundQualitySheet({
  required String title,
  required BuildContext context,
  required List<String> options,
  required int selectedIndex,
  required ValueChanged<int> onOptionSelected,
}) {
  showModalBottomSheet(
    backgroundColor: Colors.white,
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
    ),
    builder: (BuildContext context) {
      return BottomMusicPlayer(
        title:title,
        options: options,
        selectedIndex: selectedIndex,
        onOptionSelected: onOptionSelected,
      );
    },
  );
}