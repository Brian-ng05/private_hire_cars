// import 'dart:convert';
// import 'package:http/http.dart' as http;

// import '../classes/distance_class.dart';

// class DistanceApi {
//   static const String baseUrl =
//       "https://privatehirecars-production.up.railway.app/api";

//   static Future<DistanceData> calculateDistance(String from, String to) async {
//     final response = await http.post(
//       Uri.parse("$baseUrl/distance"),
//       headers: {"Content-Type": "application/json"},
//       body: jsonEncode({"from": from, "to": to}),
//     );

//     final json = jsonDecode(response.body);

//     if (response.statusCode == 200 && json['status'] == 200) {
//       final res = DistanceResponse.fromJson(json);

//       return res.data;
//     } else {
//       throw Exception(json['message']);
//     }
//   }
// }

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class GeocodeResult {
  final LatLng location;
  final String displayName;

  GeocodeResult({required this.location, required this.displayName});
}

Future<GeocodeResult?> geocode(String address) async {
  final uri = Uri.https('nominatim.openstreetmap.org', '/search', {
    'q': address,
    'format': 'json',
    'limit': '1',
  });

  final res = await http.get(
    uri,
    headers: {'User-Agent': 'private-hire-cars-app'},
  );

  if (res.statusCode != 200) {
    print(res.body);
    return null;
  }

  final data = jsonDecode(res.body);

  if (data.isEmpty) return null;

  final lat = double.parse(data[0]['lat']);
  final lon = double.parse(data[0]['lon']);
  final displayName = data[0]['display_name'];

  return GeocodeResult(location: LatLng(lat, lon), displayName: displayName);
}

double calculateDistance(LatLng a, LatLng b) {
  final d = const Distance();
  final meter = d(a, b);
  return meter / 1000; // km
}
