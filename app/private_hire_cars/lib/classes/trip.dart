import 'vehicles/vehicle.dart';

class Trip {
  final int bookingId;
  final String pickupLocation;
  final String destination;
  final String serviceType;
  final DateTime pickupDatetime;
  final int passengerCount;
  final String bookingStatus;
  final double distanceKm;
  final double finalPrice;
  final Vehicle vehicle;

  Trip({
    required this.bookingId,
    required this.pickupLocation,
    required this.destination,
    required this.serviceType,
    required this.pickupDatetime,
    required this.passengerCount,
    required this.bookingStatus,
    required this.distanceKm,
    required this.finalPrice,
    required this.vehicle,
  });

  factory Trip.fromJson(Map<String, dynamic> json) {
    print("FULL JSON:");
    print(json);

    print("VEHICLE FIELD:");
    print(json['vehicle']);

    return Trip(
      bookingId: json['booking_id'],
      pickupLocation: json['pickup_location'],
      destination: json['destination'],
      serviceType: json['service_type'],
      pickupDatetime: DateTime.parse(json['pickup_datetime']),
      passengerCount: json['passenger_count'],
      bookingStatus: json['booking_status'],
      distanceKm: (json['distance_km'] as num).toDouble(),
      finalPrice: (json['final_price'] as num).toDouble(),

      vehicle: json['vehicle'] != null
          ? Vehicle.fromJson(json['vehicle'])
          : Vehicle(
              id: 0,
              name: "Unknown Vehicle",
              imageUrl: "",
              capacity: 0,
              pricing: Pricing(baseFare: 0, pricePerKm: 0, pricePerDay: 0),
            ),
    );
  }
}
