class Vehicle {
  final int id;
  final String name;
  final String imageUrl;
  final String typeName;
  final int capacity;
  final double price;

  Vehicle({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.typeName,
    required this.capacity,
    required this.price,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: json['vehicle_id'],
      name: json['name'],
      imageUrl: json['image_url'],
      typeName: json['type_name'],
      capacity: json['passenger_capacity'],
      price: (json['estimated_price']).toDouble(),
    );
  }
}
