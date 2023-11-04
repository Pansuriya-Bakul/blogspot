import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Constants {
  static const List<String> categories = [
    "Personal",
    "Corporate",
    "Fashion",
    "Lifestyle",
    "Travel",
    "Food",
    "Multimedia",
    "News"
  ];

  static const String USER = "user";
  static const String TOKEN = "token";

  static Future<bool> setUser(Map<String, dynamic> user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(USER, jsonEncode(user));
  }

  static Future<Map<String, dynamic>> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String json = prefs.getString(USER) ?? "";
    if (json.isNotEmpty) {
      return await jsonDecode(json);
    }
    return {};
  }

  static Future<bool> setToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(TOKEN, token);
  }

  static Future<String> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(TOKEN) ?? "";
  }

  static Future<bool> clear() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.clear();
  }
}
