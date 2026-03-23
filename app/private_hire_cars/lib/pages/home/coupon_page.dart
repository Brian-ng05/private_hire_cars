import 'package:flutter/material.dart';

class CouponsPage extends StatefulWidget {
  const CouponsPage({super.key});

  @override
  State<CouponsPage> createState() => _CouponsPageState();
}

class _CouponsPageState extends State<CouponsPage> {
  String selectedCoupon = "WELCOME15";

  final List<Map<String, dynamic>> coupons = [
    {
      "code": "WELCOME15",
      "description": "15% Off for Online Booking",
      "discount": 15.0,
    },
    {"code": "SAVE10", "description": "10% Off Any Booking", "discount": 10.0},
    {"code": "SAVE5", "description": "5% Off", "discount": 5.0},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        title: const Text("Coupons"),
        backgroundColor: Colors.white,
        elevation: 0,
      ),

      body: Column(
        children: [
          /// ===== SEARCH =====
          Padding(
            padding: const EdgeInsets.all(20),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search coupon code",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
          ),

          /// ===== COUPON LIST =====
          Expanded(
            child: ListView.separated(
              itemCount: coupons.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, index) {
                final coupon = coupons[index];

                final String code = coupon["code"] as String;
                final String description = coupon["description"] as String;
                final double discount = (coupon["discount"] as num).toDouble();

                return couponCard(
                  code: code,
                  description: description,
                  discount: discount,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget couponCard({
    required String code,
    required String description,
    required double discount,
  }) {
    return InkWell(
      onTap: () {
        selectedCoupon = code;
        Navigator.pop<double>(context, discount);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          children: [
            const Icon(Icons.local_offer_outlined),

            const SizedBox(width: 15),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    code,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),

                  Text(description),
                ],
              ),
            ),

            /// RADIO BUTTON
            Radio<String>(
              value: code,
              groupValue: selectedCoupon,
              onChanged: (value) {
                if (value == null) return;

                selectedCoupon = value;
                Navigator.pop<double>(context, discount);
              },
            ),
          ],
        ),
      ),
    );
  }
}
