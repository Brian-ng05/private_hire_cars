import 'package:flutter/material.dart';
import 'package:private_hire_cars/classes/vehicles/sort_type.dart';
import 'package:private_hire_cars/classes/vehicles/vehicle.dart';
import 'package:private_hire_cars/pages/rent_car/review_rent_order_page.dart';
import 'package:private_hire_cars/pages/rent_car/vehicle_card_rent.dart';
import 'package:private_hire_cars/services/vehicles/get_car_quote.dart';

const backgroundColor = Color(0xfff6f7f9);

class SelectCarRentPage extends StatefulWidget {
  const SelectCarRentPage({
    super.key,
    required this.pickupTime,
    required this.returnTime,
    required this.location,
  });

  final DateTime pickupTime;
  final DateTime returnTime;
  final String location;

  @override
  State<SelectCarRentPage> createState() => _SelectCarRentPageState();
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

class _SelectCarRentPageState extends State<SelectCarRentPage> {
  SortType currentSort = SortType.priceAsc;
  List<Vehicle> vehicles = [];
  bool isLoading = true;

  Vehicle? selectedVehicle;

  int get durationHours {
    return widget.returnTime.difference(widget.pickupTime).inHours;
  }

  @override
  void initState() {
    super.initState();
    loadVehicles();
  }

  Future<void> loadVehicles() async {
    setState(() => isLoading = true);

    try {
      vehicles = await LocalVehicleService.getVehicles(sort: currentSort);
      debugPrint('loaded ${vehicles.length} vehicles');
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
          /// ===== FILTER =====
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
                            child: VehicleCardRent(
                              vehicle: vehicle,
                              durationHours: durationHours,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),

      /// ===== BUTTON =====
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
                        builder: (_) => ReviewRentOrderPage(
                          pickupTime: widget.pickupTime,
                          returnTime: widget.returnTime,
                          vehicle: selectedVehicle,
                          durationHours: durationHours,
                          rentPrice: selectedVehicle!.pricing.pricePerKm,
                          location: widget.location,
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
