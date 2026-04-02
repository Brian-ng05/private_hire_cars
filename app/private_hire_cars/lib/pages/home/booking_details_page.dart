import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:private_hire_cars/pages/amend_booking_page.dart';
import '../../classes/trip.dart';
import 'package:private_hire_cars/classes/vehicles/vehicle.dart';

class BookingDetailsPage extends StatefulWidget {
  const BookingDetailsPage({
    super.key,
    required this.title,
    required this.trip,
    required this.vehicle,
  });

  final String title;
  final Trip trip;
  final Vehicle vehicle;

  @override
  State<BookingDetailsPage> createState() => _BookingDetailsPageState();
}

class _BookingDetailsPageState extends State<BookingDetailsPage> {
  late String bookingStatus;
  final bookingId = DateTime.now().millisecondsSinceEpoch.toString();
  String cancelTimeText = "24h left";

  @override
  void initState() {
    super.initState();
    bookingStatus = widget.trip.bookingStatus;

    if (widget.trip.serviceType == "Intercity") {
      cancelTimeText = "12h left";
    } else if (widget.trip.serviceType == "City Ride") {
      cancelTimeText = "6h left";
    }
  }

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

  Widget _bullet(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("• "),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }

  /// SERVICE DETAILS
  Widget buildServiceDetails(Trip trip) {
    final pricing = trip.vehicle.pricing;

    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${trip.serviceType} Details",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),

          /// COMMON
          _bullet("Passengers: ${trip.passengerCount}"),
          _bullet("Distance: ${trip.distanceKm} km"),

          const SizedBox(height: 6),

          _bullet("Base fare: £${pricing.baseFare.toStringAsFixed(2)}"),
          _bullet("Price per km: £${pricing.pricePerKm.toStringAsFixed(2)}"),

          const SizedBox(height: 8),

          /// SERVICE-SPECIFIC
          if (trip.serviceType == "Airport Transfer") ...[
            _bullet("Meet & Greet service included"),
            _bullet("Waiting allowance: up to 60 minutes"),
            _bullet("Suitable for flights and luggage handling"),
          ] else if (trip.serviceType == "Intercity") ...[
            _bullet("Trip between different cities"),
            _bullet("Pricing based on total distance"),
            _bullet("Long-distance travel"),
          ] else if (trip.serviceType == "City Ride") ...[
            _bullet("Short trips within the city"),
            _bullet(
              "Estimated duration: ${(trip.distanceKm * 3).toInt()} mins",
            ),
            _bullet("Suitable for daily travel"),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final trip = widget.trip;

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Booking ID: #$bookingId",
                style: const TextStyle(
                  fontSize: 16,
                  color: Color.fromARGB(255, 81, 81, 81),
                ),
              ),

              const SizedBox(height: 20),

              /// ROUTE
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      const Icon(Icons.circle_outlined),
                      Container(
                        width: 2,
                        height: 50,
                        color: Colors.grey.shade400,
                      ),
                      const Icon(Icons.location_on_outlined),
                    ],
                  ),
                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Departure",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        Text(trip.pickupLocation),

                        const SizedBox(height: 25),

                        const Text(
                          "Destination",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        Text(trip.destination),
                      ],
                    ),
                  ),
                ],
              ),

              const Divider(height: 30),

              /// TIME
              Row(
                children: [
                  const Icon(Icons.calendar_month_outlined),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Pickup time",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        DateFormat(
                          'HH:mm dd/MM/yyyy',
                        ).format(trip.pickupDatetime),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 20),

              /// SERVICE
              Row(
                children: [
                  const Icon(Icons.local_taxi_outlined),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Service",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Text(trip.serviceType),
                    ],
                  ),
                ],
              ),

              /// ADDITIONAL INFO BOX
              buildServiceDetails(trip),

              const SizedBox(height: 20),

              /// VEHICLE
              const SizedBox(height: 20),

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
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                      child: Image.asset(
                        widget.vehicle.imageUrl,
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
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        "${widget.vehicle.name} / Capacity: ${widget.vehicle.capacity}",
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              /// STATUS
              Row(
                children: [
                  const Icon(Icons.info_outline),
                  const SizedBox(width: 12),
                  Text(
                    bookingStatus,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: getStatusColor(bookingStatus),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),

      /// ===== BOTTOM =====
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: Colors.black12)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// TOTAL
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Total",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "£${trip.finalPrice}",
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              Row(
                children: [
                  /// AMEND
                  if (!(bookingStatus == "Completed" ||
                      bookingStatus == "Canceled"))
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AmendBookingPage(
                                initialPickup: trip.pickupDatetime,
                                initialVehicle: trip.vehicle,
                                quantity: trip.distanceKm,
                              ),
                            ),
                          );
                        },
                        child: const Text("Amend"),
                      ),
                    ),

                  if (!(bookingStatus == "Completed" ||
                      bookingStatus == "Canceled"))
                    const SizedBox(width: 10),

                  /// CANCEL
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            (bookingStatus == "Completed" ||
                                bookingStatus == "Canceled")
                            ? Colors.grey
                            : Colors.red,
                        foregroundColor: Colors.white,
                        disabledForegroundColor: Colors.white,
                      ),
                      onPressed:
                          (bookingStatus == "Completed" ||
                              bookingStatus == "Canceled")
                          ? null
                          : () {
                              setState(() {
                                bookingStatus = "Canceled";
                              });
                            },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Text(
                              bookingStatus == "Completed"
                                  ? "Completed"
                                  : bookingStatus == "Canceled"
                                  ? "Canceled"
                                  : "Cancel",
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (!(bookingStatus == "Completed" ||
                              bookingStatus == "Canceled")) ...[
                            const SizedBox(width: 6),
                            Text(
                              "($cancelTimeText)",
                              style: const TextStyle(color: Colors.white70),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
