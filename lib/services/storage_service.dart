import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// 本地存储服务
class StorageService {
  static SharedPreferences? _prefs;

  /// 初始化存储服务
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// 保存字符串
  static Future<bool> setString(String key, String value) async {
    return await _prefs!.setString(key, value);
  }

  /// 获取字符串
  static String? getString(String key) {
    return _prefs!.getString(key);
  }

  /// 保存JSON对象
  static Future<bool> setJson(String key, Map<String, dynamic> value) async {
    final jsonString = json.encode(value);
    return await setString(key, jsonString);
  }

  /// 获取JSON对象
  static Map<String, dynamic>? getJson(String key) {
    final jsonString = getString(key);
    if (jsonString == null) return null;
    return json.decode(jsonString) as Map<String, dynamic>;
  }

  /// 保存JSON数组
  static Future<bool> setJsonList(
      String key, List<Map<String, dynamic>> value) async {
    final jsonString = json.encode(value);
    return await setString(key, jsonString);
  }

  /// 获取JSON数组
  static List<Map<String, dynamic>>? getJsonList(String key) {
    final jsonString = getString(key);
    if (jsonString == null) return null;
    final List<dynamic> decoded = json.decode(jsonString) as List;
    return decoded.map((e) => e as Map<String, dynamic>).toList();
  }

  /// 保存布尔值
  static Future<bool> setBool(String key, bool value) async {
    return await _prefs!.setBool(key, value);
  }

  /// 获取布尔值
  static bool? getBool(String key) {
    return _prefs!.getBool(key);
  }

  /// 删除指定键
  static Future<bool> remove(String key) async {
    return await _prefs!.remove(key);
  }

  /// 清空所有数据
  static Future<bool> clear() async {
    return await _prefs!.clear();
  }
}
