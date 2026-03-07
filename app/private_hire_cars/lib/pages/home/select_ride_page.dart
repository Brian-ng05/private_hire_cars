import 'package:flutter/material.dart';
import 'package:private_hire_cars/classes/vehicles/sort_type.dart';
import 'package:private_hire_cars/classes/vehicles/vehicle.dart';
import 'package:private_hire_cars/classes/vehicles/vehicle_card.dart';
import 'package:private_hire_cars/services/vehicles/get_car_quote.dart';
import 'package:private_hire_cars/pages/home/review_booking_page.dart';

const backgroundColor = Color(0xfff6f7f9);

class SelectRidePage extends StatefulWidget {
  const SelectRidePage({
    super.key,
    required this.quantity,
    required this.departure,
    required this.destination,
    required this.time,
  });

  final double quantity;
  final String departure;
  final String destination;
  final DateTime? time;

  @override
  State<SelectRidePage> createState() => _SelectRidePageState();
}

IconData _getIcon(SortType type) {
  switch (type) {
    case SortType.priceAsc:
      return Icons.arrow_upward;

    case SortType.priceDesc:
      return Icons.arrow_downward;

    case SortType.capacityAsc:
      return Icons.people_alt_outlined;

    case SortType.capacityDesc:
      return Icons.people;
  }
}

class _SelectRidePageState extends State<SelectRidePage> {
  SortType currentSort = SortType.priceAsc;
  List<Vehicle> vehicles = [];
  bool isLoading = true;

  Vehicle? selectedVehicle;
  @override
  void initState() {
    super.initState();
    loadVehicles();
  }

  // Future<void> loadVehicles() async {
  //   setState(() => isLoading = true);

  //   try {
  //     vehicles = await LocalVehicleService.getVehicles(
  //       quantity: widget.quantity,
  //       sort: currentSort,
  //     );
  //   } catch (e) {
  //     debugPrint(e.toString());
  //   }

  //   if (!mounted) return;
  //   setState(() => isLoading = false);
  // }

  Future<void> loadVehicles() async {
    setState(() => isLoading = true);

    try {
      vehicles = await LocalVehicleService.getVehicles(sort: currentSort);
      debugPrint('loaded ${vehicles.length} vehicles: $vehicles');
    } catch (e, st) {
      debugPrint('vehicle load failed: $e\n$st');
    }

    if (!mounted) return;
    setState(() => isLoading = false);
  }

  void changeSort(SortType sort) {
    setState(() {
      currentSort = sort;
      selectedVehicle = null;
    });
    loadVehicles();
  }

  void selectVehicle(Vehicle vehicle) {
    setState(() {
      selectedVehicle = vehicle;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text("Select Ride"),
        centerTitle: true,
        backgroundColor: backgroundColor,
        elevation: 0,
      ),

      body: Column(
        children: [
          /// ===== FILTER BAR =====
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            alignment: Alignment.centerLeft,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: SortType.values.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (_, i) {
                final e = SortType.values[i];

                return ChoiceChip(
                  avatar: Icon(_getIcon(e), size: 18, color: Colors.black),
                  label: Text(e.label),
                  selected: e == currentSort,
                  onSelected: (_) => changeSort(e),
                  showCheckmark: false,
                  backgroundColor: backgroundColor,
                );
              },
            ),
          ),

          /// ===== LIST =====
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: vehicles.length,
                    itemBuilder: (_, i) {
                      final vehicle = vehicles[i];
                      final isSelected = selectedVehicle == vehicle;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: GestureDetector(
                          onTap: () => selectVehicle(vehicle),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isSelected
                                    ? Colors.black
                                    : Colors.transparent,
                                width: 2,
                              ),
                            ),
                            child: VehicleCard(
                              vehicle: vehicle,
                              distanceKm: widget.quantity,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),

      /// ===== REVIEW BUTTON =====
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Colors.black,
              minimumSize: const Size(double.infinity, 50),
            ),
            onPressed: selectedVehicle == null
                ? null
                : () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ReviewOrderPage(
                          quantity: widget.quantity,
                          departure: widget.departure,
                          destination: widget.destination,
                          time: widget.time,
                          vehicle: selectedVehicle!,
                        ),
                      ),
                    );
                  },
            child: const Text("Review Order"),
          ),
        ),
      ),
    );
  }
}
