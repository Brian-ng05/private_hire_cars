class Coordinate {
  final double lat;
  final double lng;

  Coordinate({required this.lat, required this.lng});

  factory Coordinate.fromJson(Map<String, dynamic> json) {
    return Coordinate(
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
    );
  }
}

class DistanceData {
  final double distanceKm;
  final Coordinate from;
  final Coordinate to;

  DistanceData({
    required this.distanceKm,
    required this.from,
    required this.to,
  });

  factory DistanceData.fromJson(Map<String, dynamic> json) {
    return DistanceData(
      distanceKm: (json['distance_km'] as num).toDouble(),
      from: Coordinate.fromJson(json['from_coord']),
      to: Coordinate.fromJson(json['to_coord']),
    );
  }
}

class DistanceResponse {
  final int status;
  final String message;
  final DistanceData data;

  DistanceResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory DistanceResponse.fromJson(Map<String, dynamic> json) {
    return DistanceResponse(
      status: json['status'],
      message: json['summary'],
      data: DistanceData.fromJson(json['detailed']),
    );
  }
}
