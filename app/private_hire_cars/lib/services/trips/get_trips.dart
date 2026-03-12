import 'dart:convert';
import 'package:flutter/services.dart';
import '../../classes/trip.dart';

class LocalTripService {
  static Future<List<Trip>> getTrips() async {
    final String response = await rootBundle.loadString(
      'assets/data/bookings.json',
    );

    final List data = json.decode(response);

    return data
        .map((json) => Trip.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
