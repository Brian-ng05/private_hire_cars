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

  bool isLoading = false;
  bool isLocked = false;

  @override
  void initState() {
    super.initState();

    pickupController.addListener(_unlockButton);
    dropoffController.addListener(_unlockButton);
  }

  @override
  void dispose() {
    pickupController.dispose();
    dropoffController.dispose();
    super.dispose();
  }

  // ================= HELPER =================
  void _unlockButton() {
    setState(() {
      isLocked = false;
      result = "";
    });
  }

  bool get canSubmit =>
      pickupController.text.isNotEmpty &&
      dropoffController.text.isNotEmpty &&
      !isLoading &&
      !isLocked;

  // ================= API CALL =================
  Future<void> calculate() async {
    if (!canSubmit) return;

    setState(() => isLoading = true);

    try {
      final distance = await DistanceApi.calculateDistance(
        pickupController.text.trim(),
        dropoffController.text.trim(),
      );

      setState(() {
        result = "${distance.distanceKm.toStringAsFixed(2)} km";
        isLocked = true;
      });
    } catch (e) {
      setState(() {
        result = e.toString();
      });
    } finally {
      if (!mounted) return;
      setState(() => isLoading = false);
    }
  }

  // ================= UI =================
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
              /// PICKUP
              _buildInput(
                controller: pickupController,
                icon: Icons.circle_outlined,
                hint: "Departure?",
              ),

              const SizedBox(height: 20),

              /// DROPOFF
              _buildInput(
                controller: dropoffController,
                icon: Icons.pin_drop_rounded,
                hint: "Destination?",
              ),

              const SizedBox(height: 24),

              /// CONFIRM BUTTON
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: canSubmit ? calculate : null,
                child: isLoading
                    ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text("Confirm location"),
              ),

              const SizedBox(height: 20),

              /// RESULT CARD
              if (result.isNotEmpty)
                Text(
                  "The distance is: $result",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
            ],
          ),
        ),
      ),

      /// BOTTOM BUTTON
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 50),
            ),
            onPressed: isLocked ? () {} : null,
            child: const Text("Choose a car"),
          ),
        ),
      ),
    );
  }

  Widget _buildInput({
    required TextEditingController controller,
    required IconData icon,
    required String hint,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.black12),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          icon: Icon(icon),
          hintText: hint,
          border: InputBorder.none,
        ),
      ),
    );
  }
}
