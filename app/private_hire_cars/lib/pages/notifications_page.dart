import 'package:flutter/material.dart';
import 'package:private_hire_cars/classes/trip.dart';
import 'package:private_hire_cars/classes/vehicles/vehicle.dart';
import 'package:private_hire_cars/pages/home/invoice_page.dart';
import 'package:private_hire_cars/pages/rating_page.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key, required this.title});
  final String title;

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final bookingId = DateTime.now().millisecondsSinceEpoch.toString();

  final trip = Trip(
    bookingId: 3,
    pickupLocation: "45 Le Duan",
    destination: "Hoi An Ancient Town",
    serviceType: "Intercity",
    pickupDatetime: DateTime.parse("2024-07-03T09:00:00"),
    passengerCount: 4,
    bookingStatus: "Completed",
    distanceKm: 35.0,
    finalPrice: 83.0,
    vehicle: Vehicle(
      id: 2,
      name: "Toyota - Vios",
      imageUrl: "assets/images/4_seater_car_image2.png",
      capacity: 4,
      pricing: Pricing(baseFare: 6.0, pricePerKm: 2.2, pricePerDay: 45.0),
    ),
  );

  /// Status color
  Color getStatusColor(String status) {
    switch (status) {
      case "Completed":
        return Colors.green;
      case "On-Going":
        return Colors.blue;
      case "Canceled":
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),

      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        backgroundColor: const Color(0xFFF5F5F5),
        elevation: 0,
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            color: Colors.white,
            elevation: 2,
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),

            child: ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        RatingPage(title: "Review Page", trip: trip),
                  ),
                );
              },

              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),

              /// Pickup → Destination
              title: Text(
                "${trip.pickupLocation} → ${trip.destination}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),

              /// Service + Distance
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  "${trip.pickupDatetime}",
                  style: const TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),

              /// Price + Status
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "£${trip.finalPrice}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    trip.bookingStatus,
                    style: TextStyle(
                      fontSize: 16,
                      color: getStatusColor(trip.bookingStatus),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Card(
            color: Colors.white,
            elevation: 2,
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),

            child: ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        InvoicePage(trip: trip, bookingId: bookingId),
                  ),
                );
              },

              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),

              /// Left content
              title: const Text(
                "Ride Payment",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),

              subtitle: Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Booking ID: $bookingId",
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),

                    Text(
                      "£${trip.finalPrice}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),

              /// Right arrow button
              trailing: const Icon(
                Icons.chevron_right,
                size: 28,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
