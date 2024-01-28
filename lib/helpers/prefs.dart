import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/keys.dart';

const nameKey = 'myManageKeys';

class Prefs {
  static saveKey(List<Keys> keys) async {
    final prefs = await SharedPreferences.getInstance();

    final jsonString = json.encode(keys);

    await prefs.setString(nameKey, jsonString);
  }

  static Future<List<Keys>?> readKey() async {
    final prefs = await SharedPreferences.getInstance();

    final String keysJson = prefs.getString(nameKey) ?? '[]';
    final List jsonDecoded = json.decode(keysJson) as List;

    return jsonDecoded.map((e) => Keys.fromJson(e)).toList();
  }
}
