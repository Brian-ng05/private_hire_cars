import 'dart:convert';
import 'package:private_hire_cars/classes/auth/login_class.dart';
import 'package:private_hire_cars/classes/auth/user_class.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const _userKey = "user_data";

  static Future<void> saveUser(LoginResponse response) async {
    final prefs = await SharedPreferences.getInstance();

    final userMap = {
      "user_id": response.user.userId,
      "email": response.user.email,
      "role": response.user.role,
    };

    await prefs.setString(_userKey, jsonEncode(userMap));
  }

  static Future<User?> getUser() async {
    final prefs = await SharedPreferences.getInstance();

    final jsonString = prefs.getString(_userKey);
    if (jsonString == null) return null;

    final map = jsonDecode(jsonString);
    return User.fromJson(map);
  }

  static Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
  }
}
