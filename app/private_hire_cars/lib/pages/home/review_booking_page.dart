import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:private_hire_cars/classes/vehicles/vehicle.dart';
import 'package:private_hire_cars/data/notifiers.dart';
import 'package:private_hire_cars/pages/trips_page.dart';
import 'package:private_hire_cars/pages/widget_tree.dart';

class ReviewOrderPage extends StatelessWidget {
  const ReviewOrderPage({
    super.key,
    required this.quantity,
    required this.departure,
    required this.destination,
    required this.time,
    required this.vehicle,
  });

  final double quantity;
  final String departure;
  final String destination;
  final DateTime? time;
  final Vehicle vehicle;

  @override
  Widget build(BuildContext context) {
    final totalPrice =
        (vehicle.pricing.baseFare + (quantity * vehicle.pricing.pricePerKm))
            .toStringAsFixed(2);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Review"),
        backgroundColor: Colors.white,
        elevation: 0,
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  /// ===== BOOKING DETAILS =====
                  const Text(
                    "Booking details",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 20),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// ICON + LINE COLUMN
                      Column(
                        children: [
                          const Icon(Icons.circle_outlined),

                          Container(
                            width: 2,
                            height: 85,
                            color: Colors.grey.shade400,
                          ),

                          const Icon(Icons.location_on_outlined),
                        ],
                      ),

                      const SizedBox(width: 12),

                      /// TEXT COLUMN
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// DEPARTURE
                            const Text(
                              "Departure",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),

                            const SizedBox(height: 4),

                            Text(
                              departure,
                              style: const TextStyle(
                                color: Color.fromARGB(255, 52, 52, 52),
                              ),
                            ),

                            const SizedBox(height: 20),

                            /// DESTINATION
                            const Text(
                              "Destination",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),

                            const SizedBox(height: 4),

                            Text(
                              destination,
                              style: const TextStyle(
                                color: Color.fromARGB(255, 52, 52, 52),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const Divider(height: 30, thickness: 1),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.calendar_month_outlined),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Pickup time",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 4),

                        /// ===== PICKUP TIME =====
                        if (time != null)
                          Text(
                            DateFormat('HH:mm dd/MM/yyyy').format(time!),
                            style: const TextStyle(
                              fontSize: 16,
                              color: Color.fromARGB(255, 52, 52, 52),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),

              /// ===== VEHICLE =====
              const Text(
                "Vehicle Details",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),

              const SizedBox(height: 16),

              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// IMAGE
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
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

                    /// INFO
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        "${vehicle.name} / Capacity: ${vehicle.capacity}",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),

      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: Colors.black12)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// ===== TOTAL =====
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Total",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  Text(
                    "£$totalPrice",
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              /// ===== BOOK BUTTON =====
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    selectedPageNotifier.value = 1;

                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const WidgetTree()),
                      (route) => false,
                    );
                  },
                  child: const Text("Book", style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
