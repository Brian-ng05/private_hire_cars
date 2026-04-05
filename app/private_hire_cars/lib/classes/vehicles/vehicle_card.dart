import 'package:flutter/material.dart';
import 'package:private_hire_cars/classes/vehicles/vehicle.dart';
import 'package:private_hire_cars/pages/vehicle_review_page.dart';

class VehicleCard extends StatelessWidget {
  final Vehicle vehicle;
  final double distanceKm;

  const VehicleCard({
    super.key,
    required this.vehicle,
    required this.distanceKm,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      color: const Color(0xfff2f3f5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// ===== IMAGE =====
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.asset(
              vehicle.imageUrl,
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,

              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 150,
                  color: Colors.grey[300],
                  child: const Center(
                    child: Icon(Icons.directions_car, size: 40),
                  ),
                );
              },
            ),
          ),

          /// ===== INFO =====
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// LEFT: NAME + CAPACITY
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        vehicle.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text("${vehicle.capacity} passengers"),
                    ],
                  ),
                ),

                /// RIGHT: PRICE + RATING
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "£${(vehicle.pricing.baseFare + (distanceKm * vehicle.pricing.pricePerKm)).toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),

                    const SizedBox(height: 6),

                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VehicleReviewPage(),
                          ),
                        );
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            "4.2",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "(5)",
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
