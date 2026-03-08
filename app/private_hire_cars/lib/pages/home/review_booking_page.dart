import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:private_hire_cars/classes/vehicles/vehicle.dart';
import 'package:private_hire_cars/data/notifiers.dart';
import 'package:private_hire_cars/pages/home/coupon_page.dart';
import 'package:private_hire_cars/pages/widget_tree.dart';

class ReviewOrderPage extends StatefulWidget {
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
  State<ReviewOrderPage> createState() => _ReviewOrderPageState();
}

class _ReviewOrderPageState extends State<ReviewOrderPage> {
  double discountPercent = 15; // mặc định WELCOME15

  @override
  Widget build(BuildContext context) {
    final originalPrice =
        widget.vehicle.pricing.baseFare +
        (widget.quantity * widget.vehicle.pricing.pricePerKm);

    final finalPrice = originalPrice - (originalPrice * discountPercent / 100);

    final oldPriceText = originalPrice.toStringAsFixed(2);
    final newPriceText = finalPrice.toStringAsFixed(2);

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
              /// ===== BOOKING DETAILS =====
              Column(
                children: [
                  Container(
                    width: double.infinity,
                    child: const Text(
                      "Booking details",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

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
                              widget.departure,
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
                              widget.destination,
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

                        if (widget.time != null)
                          Text(
                            DateFormat('HH:mm dd/MM/yyyy').format(widget.time!),
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

              /// ===== COUPONS =====
              const Text(
                "Apply Coupons",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),

              GestureDetector(
                onTap: () async {
                  final double? discount = await Navigator.push<double>(
                    context,
                    MaterialPageRoute(builder: (_) => const CouponsPage()),
                  );

                  if (discount != null) {
                    setState(() {
                      discountPercent = discount;
                    });
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Row(
                    children: [
                      const Icon(Icons.local_offer_outlined),
                      const SizedBox(width: 10),

                      Expanded(
                        child: Text(
                          "${discountPercent.toInt()}% Off for Online Booking",
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),

                      const Icon(Icons.arrow_forward_ios, size: 16),
                    ],
                  ),
                ),
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
              /// PRICE ROW
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Total",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  Row(
                    children: [
                      /// NEW PRICE
                      Text(
                        "£$newPriceText",
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(width: 10),

                      /// OLD PRICE
                      Text(
                        "£$oldPriceText",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 20),

              /// BOOK BUTTON
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
