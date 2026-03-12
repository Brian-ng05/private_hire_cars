import 'package:flutter/material.dart';
import '../../classes/trip.dart';
import '../../services/trips/get_trips.dart';
import '../../pages/home/booking_details_page.dart';
import '../../classes/vehicles/vehicle.dart';

class TripsPage extends StatefulWidget {
  const TripsPage({super.key, required this.title});

  final String title;

  @override
  State<TripsPage> createState() => _TripsPageState();
}

class _TripsPageState extends State<TripsPage> {
  List<Trip> trips = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadTrips();
  }

  Future<void> loadTrips() async {
    setState(() => isLoading = true);

    try {
      trips = await LocalTripService.getTrips();
    } catch (e) {
      debugPrint(e.toString());
    }

    if (!mounted) return;

    setState(() => isLoading = false);
  }

  /// Status color function
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

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: trips.length,
              itemBuilder: (_, i) {
                final trip = trips[i];

                return Card(
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
                          builder: (context) => BookingDetailsPage(
                            title: "Booking Details",
                            trip: trip,
                            vehicle: trip.vehicle,
                          ),
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
                        "${trip.serviceType} • ${trip.distanceKm} km",
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
                );
              },
            ),
    );
  }
}
