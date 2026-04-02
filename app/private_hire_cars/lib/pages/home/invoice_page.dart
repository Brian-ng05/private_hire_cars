import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:private_hire_cars/classes/trip.dart';

class InvoicePage extends StatelessWidget {
  final Trip trip;
  final String bookingId;

  const InvoicePage({super.key, required this.trip, required this.bookingId});

  String generateTransactionId() {
    return "TXN${DateTime.now().millisecondsSinceEpoch}";
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat("dd MMM yyyy, HH:mm");
    final transactionId = generateTransactionId();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),

      appBar: AppBar(
        title: const Text("Payment Details"),
        centerTitle: true,
        backgroundColor: const Color(0xFFF5F5F5),
        elevation: 0,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// INVOICE CARD
            Card(
              color: Colors.white,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),

              child: Padding(
                padding: const EdgeInsets.all(16),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// HEADER
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Invoice",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        /// PAID BADGE
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            "PAID",
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    /// BOOKING + TRANSACTION
                    _buildRow("Booking ID", bookingId),
                    const SizedBox(height: 6),
                    _buildRow("Transaction ID", transactionId),

                    const Divider(height: 24),

                    /// PAYMENT METHOD
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Payment Method"),

                        Row(
                          children: const [
                            Icon(Icons.credit_card, size: 18),
                            SizedBox(width: 6),
                            Text(
                              "Visa •••• 4242",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const Divider(height: 24),

                    /// RIDE INFO
                    _buildRow(
                      "Route",
                      "${trip.pickupLocation} → ${trip.destination}",
                    ),
                    const SizedBox(height: 8),
                    _buildRow("Date", dateFormat.format(trip.pickupDatetime)),
                    const SizedBox(height: 8),
                    _buildRow("Distance", "${trip.distanceKm} km"),
                    const SizedBox(height: 8),
                    _buildRow("Passengers", "${trip.passengerCount}"),

                    const Divider(height: 24),

                    /// PRICE BREAKDOWN (real hơn)
                    _buildRow("Base Fare", "£${trip.vehicle.pricing.baseFare}"),
                    const SizedBox(height: 6),
                    _buildRow(
                      "Distance Fee",
                      "£${(trip.distanceKm * trip.vehicle.pricing.pricePerKm).toStringAsFixed(2)}",
                    ),

                    const Divider(height: 24),

                    /// TOTAL
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Total Paid",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
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
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Reusable row
  Widget _buildRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(color: Colors.grey)),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}
