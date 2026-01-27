import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

Future<LatLng?> geocode(String address) async {
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

  return LatLng(double.parse(data[0]['lat']), double.parse(data[0]['lon']));
}

double calculateDistance(LatLng a, LatLng b) {
  final d = const Distance();
  final meter = d(a, b);
  return meter / 1000; // km
}
