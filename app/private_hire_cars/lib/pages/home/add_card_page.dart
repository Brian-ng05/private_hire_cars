import 'package:flutter/material.dart';

class AddCardPage extends StatefulWidget {
  const AddCardPage({super.key});

  @override
  State<AddCardPage> createState() => _AddCardPageState();
}

class _AddCardPageState extends State<AddCardPage> {
  String selectedMethod = "PAYPAL";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// ===== HEADER =====
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      "Your card",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                /// ===== TITLE =====
                const Text(
                  "Payment methods",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),

                const SizedBox(height: 5),

                const Text(
                  "Card details",
                  style: TextStyle(color: Colors.grey),
                ),

                const SizedBox(height: 15),

                /// ===== RADIO =====
                Row(
                  children: [
                    Row(
                      children: [
                        Radio<String>(
                          value: "CREDIT",
                          groupValue: selectedMethod,
                          onChanged: (value) {
                            setState(() {
                              selectedMethod = value!;
                            });
                          },
                        ),
                        const Text("Credit Card"),
                      ],
                    ),

                    const SizedBox(width: 20),

                    Row(
                      children: [
                        Radio<String>(
                          value: "PAYPAL",
                          groupValue: selectedMethod,
                          onChanged: (value) {
                            setState(() {
                              selectedMethod = value!;
                            });
                          },
                        ),
                        const Text("Paypal"),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                /// ===== CARD IMAGE =====
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    "assets/images/card.png",
                    height: 220,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),

                const SizedBox(height: 25),

                /// ===== FORM =====
                buildField("Full Name"),
                const SizedBox(height: 15),

                buildField("Card number"),
                const SizedBox(height: 15),

                Row(
                  children: [
                    Expanded(child: buildField("Expiry date")),
                    const SizedBox(width: 15),
                    Expanded(child: buildField("CVC")),
                  ],
                ),

                const SizedBox(height: 40),

                /// ===== BUTTON =====
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "Confirm",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// ===== INPUT FIELD =====
  Widget buildField(String hint) {
    return TextField(
      decoration: InputDecoration(
        hintText: hint,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 15,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
