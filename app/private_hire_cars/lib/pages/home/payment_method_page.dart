import 'package:flutter/material.dart';
import 'package:private_hire_cars/pages/home/add_card_page.dart';

class PaymentMethodPage extends StatefulWidget {
  const PaymentMethodPage({super.key});

  @override
  State<PaymentMethodPage> createState() => _PaymentMethodPageState();
}

class _PaymentMethodPageState extends State<PaymentMethodPage> {
  String selectedMethod = "CASH";

  final List<Map<String, dynamic>> methods = [
    {
      "type": "CASH",
      "title": "Cash",
      "subtitle": "Pay with cash",
      "icon": Icons.money,
    },
    {
      "type": "VISA",
      "title": "Visa",
      "subtitle": "**** **** **** 1234",
      "icon": Icons.credit_card,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        title: const Text("Payment Methods"),
        backgroundColor: Colors.white,
        elevation: 0,
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// ===== MY METHODS =====
          const Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              "My Methods",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: methods.length,
            itemBuilder: (context, index) {
              final method = methods[index];

              return methodCard(
                type: method["type"],
                title: method["title"],
                subtitle: method["subtitle"],
                icon: method["icon"],
              );
            },
          ),

          const SizedBox(height: 20),

          /// ===== ADD METHODS =====
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "Add Methods",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),

          const SizedBox(height: 10),

          GestureDetector(
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => AddCardPage()),
              );
            },

            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Row(
                children: [
                  const Icon(Icons.add_card),

                  const SizedBox(width: 15),

                  const Expanded(
                    child: Text("Add Card", style: TextStyle(fontSize: 16)),
                  ),

                  const Icon(Icons.arrow_forward_ios, size: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget methodCard({
    required String type,
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    return InkWell(
      onTap: () {
        setState(() {
          selectedMethod = type;
        });

        Navigator.pop(context, type);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          children: [
            Icon(icon),

            const SizedBox(width: 15),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(subtitle),
                ],
              ),
            ),

            /// RADIO
            Radio<String>(
              value: type,
              groupValue: selectedMethod,
              onChanged: (value) {
                if (value == null) return;

                setState(() {
                  selectedMethod = value;
                });

                Navigator.pop(context, value);
              },
            ),
          ],
        ),
      ),
    );
  }
}
