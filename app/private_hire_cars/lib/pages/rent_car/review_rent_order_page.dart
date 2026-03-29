import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:private_hire_cars/classes/vehicles/vehicle.dart';
import 'package:private_hire_cars/data/notifiers.dart';
import 'package:private_hire_cars/pages/home/coupon_page.dart';
import 'package:private_hire_cars/pages/home/payment_method_page.dart';
import 'package:private_hire_cars/pages/widget_tree.dart';
import 'package:private_hire_cars/services/auth/auth_services.dart';

class ReviewRentOrderPage extends StatefulWidget {
  const ReviewRentOrderPage({
    super.key,
    required this.pickupTime,
    required this.returnTime,
    required this.vehicle,
    required this.durationHours,
    required this.rentPrice,
    required this.location,
  });

  final DateTime pickupTime;
  final DateTime returnTime;
  final Vehicle? vehicle;
  final int durationHours;
  final double rentPrice;
  final String location;

  @override
  State<ReviewRentOrderPage> createState() => _ReviewRentOrderPageState();
}

class _ReviewRentOrderPageState extends State<ReviewRentOrderPage> {
  double discountPercent = 15;
  String selectedPaymentMethod = "Cash";

  @override
  Widget build(BuildContext context) {
    final originalPrice =
        widget.vehicle!.pricing.baseFare +
        (widget.durationHours * widget.vehicle!.pricing.pricePerKm * 5);
    final finalPrice = originalPrice - (originalPrice * discountPercent / 100);

    final oldPriceText = originalPrice.toStringAsFixed(2);
    final newPriceText = finalPrice.toStringAsFixed(2);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Review Rental"),
        backgroundColor: Colors.white,
        elevation: 0,
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// ===== RENTAL DETAILS =====
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Rental details",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 20),

                  /// LOCATION
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.location_on_outlined),

                      const SizedBox(width: 12),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Pickup Location",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),

                            const SizedBox(height: 4),

                            Text(
                              widget.location,
                              style: const TextStyle(
                                color: Color.fromARGB(255, 52, 52, 52),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  /// PICKUP TIME
                  Row(
                    children: [
                      const Icon(Icons.login_outlined),

                      const SizedBox(width: 12),

                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Pickup",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),

                            Text(
                              DateFormat(
                                'HH:mm - dd/MM/yyyy',
                              ).format(widget.pickupTime),
                              style: const TextStyle(
                                color: Color.fromARGB(255, 52, 52, 52),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),

                  /// RETURN TIME
                  Row(
                    children: [
                      const Icon(Icons.logout_outlined),

                      const SizedBox(width: 12),

                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Return",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),

                            Text(
                              DateFormat(
                                'HH:mm - dd/MM/yyyy',
                              ).format(widget.returnTime),
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

              /// ===== DURATION =====
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.timer_outlined),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Total Duration",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          "${widget.durationHours} hours",
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
                        widget.vehicle!.imageUrl,
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
                        "${widget.vehicle?.name} / Capacity: ${widget.vehicle?.capacity}",
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

              /// ===== PAYMENT METHODS =====
              const Text(
                "Payment Methods",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),

              GestureDetector(
                onTap: () async {
                  final String? method = await Navigator.push<String>(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const PaymentMethodPage(),
                    ),
                  );

                  if (method != null) {
                    setState(() {
                      selectedPaymentMethod = method;
                    });
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Row(
                    children: [
                      const Icon(Icons.wallet_outlined),
                      const SizedBox(width: 10),

                      Expanded(
                        child: Text(
                          selectedPaymentMethod,
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
                  onPressed: () async {
                    try {
                      await AuthService.sendBookingEmail(
                        email: "nguyenbao12122005@gmail.com",
                        departure:
                            "Pickup: ${DateFormat('HH:mm dd/MM/yyyy').format(widget.pickupTime)}",
                        destination:
                            "Return: ${DateFormat('HH:mm dd/MM/yyyy').format(widget.returnTime)}",
                        carName: widget.vehicle!.name,
                        capacity: widget.vehicle!.capacity,
                        datetime: "${widget.durationHours} hours",
                      );

                      selectedPageNotifier.value = 1;

                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const WidgetTree()),
                        (route) => false,
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(e.toString()),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  child: const Text(
                    "Book Rental",
                    style: TextStyle(fontSize: 16),
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
