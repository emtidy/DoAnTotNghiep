import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/table.dart';

class TableService {
  static const String _key = 'tables';

  Future<void> saveTables(List<TableModel> tables) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final tablesJson =
          tables.map((table) => jsonEncode(table.toMap())).toList();
      await prefs.setStringList(_key, tablesJson);
    } catch (e) {
      print('Error saving tables: $e');
      rethrow;
    }
  }

  Future<List<TableModel>> getTables() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final tablesJson = prefs.getStringList(_key) ?? [];
      return tablesJson.map((json) {
        Map<String, dynamic> map = jsonDecode(json);
        return TableModel.fromMap(map);
      }).toList();
    } catch (e) {
      print('Error getting tables: $e');
      return [];
    }
  }
}
