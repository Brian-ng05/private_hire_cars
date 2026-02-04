import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:private_hire_cars/classes/vehicles/sort_type.dart';
import 'package:private_hire_cars/classes/vehicles/vehicle.dart';

class VehicleApi {
  static const baseUrl =
      "https://privatehirecars-production.up.railway.app/api";

  static Future<List<Vehicle>> getVehicles({
    required int serviceId,
    required double quantity,
    required SortType sort,
  }) async {
    final response = await http.post(
      Uri.parse("$baseUrl/get_car_quote"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "service_id": serviceId,
        "quantity": quantity,
        "sort": sort.apiValue,
      }),
    );

    final json = jsonDecode(response.body);

    if (response.statusCode == 200 && json['status'] == 200) {
      final list = json['detailed']['vehicles'] as List;

      return list.map((e) => Vehicle.fromJson(e)).toList();
    } else {
      throw Exception(json['message']);
    }
  }
}
