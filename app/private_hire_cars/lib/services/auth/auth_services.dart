import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:private_hire_cars/classes/auth/login_class.dart';

class AuthService {
  static const String baseUrl =
      "https://privatehirecars-production.up.railway.app/api";

  // static Future<Map<String, dynamic>> login(
  //   String email,
  //   String password,
  // ) async {
  //   final response = await http.post(
  //     Uri.parse("$baseUrl/login"),
  //     headers: {"Content-Type": "application/json"},
  //     body: jsonEncode({"email": email, "password": password}),
  //   );

  //   return jsonDecode(response.body);
  // }

  static Future<LoginResponse> login(String email, String password) async {
    final response = await http.post(
      Uri.parse("$baseUrl/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return LoginResponse.fromJson(data);
    } else {
      throw Exception(data['summary']);
    }
  }
}
