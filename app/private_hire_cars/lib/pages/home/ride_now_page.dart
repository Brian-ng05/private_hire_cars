import 'package:flutter/material.dart';
import 'package:private_hire_cars/services/location_service.dart';

const backgroundColor = Color(0xfff6f7f9);

class RideNowPage extends StatefulWidget {
  const RideNowPage({super.key, required this.title});

  final String title;

  @override
  State<RideNowPage> createState() => _RideNowPageState();
}

class _RideNowPageState extends State<RideNowPage> {
  final pickupController = TextEditingController();
  final dropoffController = TextEditingController();

  String result = "";

  @override
  void dispose() {
    pickupController.dispose();
    dropoffController.dispose();
    super.dispose();
  }

  Future<void> calculate() async {
    final pickup = await geocode(pickupController.text);
    final dropoff = await geocode(dropoffController.text);

    if (pickup == null || dropoff == null) {
      setState(() {
        result = "Address not found";
      });
      return;
    }

    final km = calculateDistance(pickup, dropoff);

    setState(() {
      result = "${km.toStringAsFixed(2)} km";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: backgroundColor,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.black12),
                ),
                child: TextField(
                  controller: dropoffController,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.search),
                    hintText: "Where to?",
                    border: InputBorder.none,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              TextField(
                controller: pickupController,
                decoration: const InputDecoration(
                  hintText: "Pickup location",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: calculate,
                child: const Text("Calculate distance"),
              ),

              const SizedBox(height: 16),
              Text(result),

              const SizedBox(height: 20),

              const Text("Ride Now Page", style: TextStyle(fontSize: 22)),
            ],
          ),
        ),
      ),
    );
  }
}
