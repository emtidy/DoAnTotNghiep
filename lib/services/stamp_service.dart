import 'dart:convert';

import 'package:coffee_cap/model/stamp.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StampService {
  static const String _key = 'stamps';
  
  // Danh sách các design tem cho từng ngày
  final List<String> stampDesigns = [
    'assets/stamps/monday.png',
    'assets/stamps/tuesday.png',
    'assets/stamps/wednesday.png',
    'assets/stamps/thursday.png',
    'assets/stamps/friday.png',
    'assets/stamps/saturday.png',
    'assets/stamps/sunday.png',
  ];

  String getStampDesignForDate(DateTime date) {
    // Lấy design dựa vào thứ trong tuần (0 = Chủ nhật, 1 = Thứ 2,...)
    int dayOfWeek = date.weekday % 7;
    return stampDesigns[dayOfWeek];
  }

  Future<void> saveStamp(Stamp stamp) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      List<String> existingStamps = prefs.getStringList(_key) ?? [];
      
      existingStamps.add(jsonEncode(stamp.toJson()));
      await prefs.setStringList(_key, existingStamps);
      
      print('Saved stamp for date: ${stamp.date}');
    } catch (e) {
      print('Error saving stamp: $e');
      rethrow;
    }
  }

  Future<List<Stamp>> getStamps() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      List<String> stampStrings = prefs.getStringList(_key) ?? [];
      
      return stampStrings
          .map((json) => Stamp.fromJson(jsonDecode(json)))
          .toList()
        ..sort((a, b) => b.date.compareTo(a.date));
    } catch (e) {
      print('Error getting stamps: $e');
      return [];
    }
  }
} 