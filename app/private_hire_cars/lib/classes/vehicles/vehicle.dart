class Vehicle {
  final int id;
  final String name;
  final String imageUrl;
  final int capacity;
  final Pricing pricing;

  Vehicle({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.capacity,
    required this.pricing,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: json['vehicle_id'],
      name: json['name'],
      imageUrl: json['image_url'],
      capacity: json['capacity'],
      pricing: Pricing.fromJson(json['pricing'] ?? {}),
    );
  }
}

class Pricing {
  final double baseFare;
  final double pricePerKm;
  final double pricePerDay;

  Pricing({
    required this.baseFare,
    required this.pricePerKm,
    required this.pricePerDay,
  });

  factory Pricing.fromJson(Map<String, dynamic> json) {
    return Pricing(
      baseFare: (json['base_fare'] ?? 0).toDouble(),
      pricePerKm: (json['price_per_km'] ?? 0).toDouble(),
      pricePerDay: (json['price_per_day'] ?? 0).toDouble(),
    );
  }
}
