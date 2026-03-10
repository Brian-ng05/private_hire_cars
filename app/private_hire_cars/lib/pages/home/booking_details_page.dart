import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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

  @override
  void initState() {
    super.initState();
    bookingStatus = widget.trip.bookingStatus;
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
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
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

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        const Text(
                          "Departure",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          trip.pickupLocation,
                          style: const TextStyle(
                            color: Color.fromARGB(255, 52, 52, 52),
                          ),
                        ),

                        const SizedBox(height: 20),

                        const Text(
                          "Destination",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          trip.destination,
                          style: const TextStyle(
                            color: Color.fromARGB(255, 52, 52, 52),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const Divider(height: 30, thickness: 1),

              /// ===== PICKUP TIME =====
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

                        if (trip.pickupDatetime != null)
                          Text(
                            DateFormat(
                              'HH:mm dd/MM/yyyy',
                            ).format(trip.pickupDatetime!),

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

              const SizedBox(height: 20),

              /// ===== SERVICE =====
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

                      const SizedBox(height: 4),

                      Text(
                        trip.serviceType,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color.fromARGB(255, 52, 52, 52),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 20),

              /// ===== DISTANCE =====
              Row(
                children: [
                  const Icon(Icons.route_outlined),

                  const SizedBox(width: 12),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Distance",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        "${trip.distanceKm} km",
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color.fromARGB(255, 52, 52, 52),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 20),

              /// VEHICEL
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

              /// ===== STATUS =====
              Row(
                children: [
                  const Icon(Icons.info_outline),

                  const SizedBox(width: 12),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Status",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        bookingStatus,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: getStatusColor(bookingStatus),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),

      /// ===== BOTTOM BAR =====
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
              /// PRICE
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

              /// CANCEL BUTTON
              SizedBox(
                width: double.infinity,
                height: 50,

                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        (bookingStatus == "Completed" ||
                            bookingStatus == "Canceled")
                        ? Colors.grey
                        : Colors.red,

                    foregroundColor: Colors.white,
                  ),

                  onPressed:
                      (bookingStatus == "Completed" ||
                          bookingStatus == "Canceled")
                      ? null
                      : () {
                          setState(() {
                            bookingStatus = "Canceled";
                          });

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Booking has been canceled"),
                            ),
                          );
                        },

                  child: Text(
                    bookingStatus == "Completed"
                        ? "Completed"
                        : bookingStatus == "Canceled"
                        ? "Canceled"
                        : "Cancel Booking",
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
