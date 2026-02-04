import 'package:flutter/material.dart';
import 'package:private_hire_cars/classes/vehicles/sort_type.dart';
import 'package:private_hire_cars/classes/vehicles/vehicle.dart';
import 'package:private_hire_cars/classes/vehicles/vehicle_card.dart';
import 'package:private_hire_cars/services/vehicles/get_car_quote.dart';

const backgroundColor = Color(0xfff6f7f9);

class SelectRidePage extends StatefulWidget {
  const SelectRidePage({super.key, required this.quantity});

  final double quantity;

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

  @override
  void initState() {
    super.initState();
    loadVehicles();
  }

  Future<void> loadVehicles() async {
    setState(() => isLoading = true);

    try {
      vehicles = await VehicleApi.getVehicles(
        serviceId: 5,
        quantity: widget.quantity,
        sort: currentSort,
      );
    } catch (e) {
      debugPrint(e.toString());
    }

    if (!mounted) return;
    setState(() => isLoading = false);
  }

  void changeSort(SortType sort) {
    setState(() => currentSort = sort);
    loadVehicles();
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
                  avatar: Icon(_getIcon(e), size: 18),
                  label: Text(e.label),
                  selected: e == currentSort,
                  onSelected: (_) => changeSort(e),
                  showCheckmark: false,
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
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: VehicleCard(vehicle: vehicles[i]),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
