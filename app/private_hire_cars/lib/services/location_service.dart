import 'dart:convert';
import 'package:http/http.dart' as http;

import '../classes/distance_class.dart';

class DistanceApi {
  static const String baseUrl =
      "https://privatehirecars-production.up.railway.app/api";

  static Future<DistanceData> calculateDistance(String from, String to) async {
    final response = await http.post(
      Uri.parse("$baseUrl/distance"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"from": from, "to": to}),
    );

    final json = jsonDecode(response.body);

    if (response.statusCode == 200 && json['status'] == 200) {
      final res = DistanceResponse.fromJson(json);

      return res.data;
    } else {
      throw Exception(json['message']);
    }
  }
}
