import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:private_hire_cars/classes/profile.dart';

class ProfileApi {
  static const baseUrl =
      "https://privatehirecars-production.up.railway.app/api";

  static Future<Profile> getProfile({required int userId}) async {
    final response = await http.post(
      Uri.parse("$baseUrl/profile/get_profile.php"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"user_id": userId}),
    );

    print("STATUS CODE: ${response.statusCode}");
    print("RAW RESPONSE: ${response.body}");
    final json = jsonDecode(response.body);

    if (response.statusCode == 200 && json['status'] == 200) {
      return Profile.fromJson(json['profile']);
    } else {
      throw Exception(json['message'] ?? "Unknown backend error");
    }
  }
}
