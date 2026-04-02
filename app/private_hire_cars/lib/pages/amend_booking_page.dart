import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:private_hire_cars/classes/vehicles/vehicle.dart';
import 'package:private_hire_cars/classes/vehicles/vehicle_card.dart';
import 'package:private_hire_cars/classes/vehicles/sort_type.dart';
import 'package:private_hire_cars/services/vehicles/get_car_quote.dart';

const backgroundColor = Color(0xfff6f7f9);

class AmendBookingPage extends StatefulWidget {
  const AmendBookingPage({
    super.key,
    required this.initialPickup,
    required this.initialVehicle,
    required this.quantity,
  });

  final DateTime initialPickup;
  final Vehicle initialVehicle;
  final double quantity;

  @override
  State<AmendBookingPage> createState() => _AmendBookingPageState();
}

class _AmendBookingPageState extends State<AmendBookingPage> {
  bool editTime = false;
  bool editVehicle = false;

  late DateTime pickupTime;
  late Vehicle selectedVehicle;

  List<Vehicle> vehicles = [];
  bool isLoading = true;

  SortType currentSort = SortType.priceAsc;

  late int day;
  late int month;
  late int hour;
  late int minute;

  @override
  void initState() {
    super.initState();

    pickupTime = DateTime.now();
    selectedVehicle = widget.initialVehicle;

    day = pickupTime.day;
    month = pickupTime.month;
    hour = pickupTime.hour;
    minute = pickupTime.minute;

    loadVehicles();
  }

  double get estimatedPrice {
    return selectedVehicle.pricing.baseFare +
        (widget.quantity * selectedVehicle.pricing.pricePerKm);
  }

  bool isValidPickupTime(DateTime time) {
    final min = DateTime.now().add(const Duration(minutes: 15));
    return time.isAfter(min);
  }

  Future<void> loadVehicles() async {
    setState(() => isLoading = true);

    try {
      vehicles = await LocalVehicleService.getVehicles(sort: currentSort);
    } catch (e) {
      debugPrint(e.toString());
    }

    if (!mounted) return;
    setState(() => isLoading = false);
  }

  void updateTime() {
    setState(() {
      pickupTime = DateTime(pickupTime.year, month, day, hour, minute);
    });
  }

  int daysInMonth(int y, int m) {
    if (m == 2) {
      return (y % 4 == 0 && y % 100 != 0) || y % 400 == 0 ? 29 : 28;
    }
    if ([4, 6, 9, 11].contains(m)) return 30;
    return 31;
  }

  void showError(String msg) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.red));
  }

  Widget buildTimePicker() {
    return Container(
      height: 170,
      margin: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        children: [
          const SizedBox(height: 10),
          Text(
            DateFormat('HH:mm dd/MM').format(pickupTime),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: CupertinoPicker(
                    itemExtent: 40,
                    scrollController: FixedExtentScrollController(
                      initialItem: day - 1,
                    ),
                    onSelectedItemChanged: (i) {
                      day = i + 1;
                      updateTime();
                    },
                    children: List.generate(
                      daysInMonth(pickupTime.year, month),
                      (i) => Center(child: Text("${i + 1}")),
                    ),
                  ),
                ),
                Expanded(
                  child: CupertinoPicker(
                    itemExtent: 40,
                    scrollController: FixedExtentScrollController(
                      initialItem: month - 1,
                    ),
                    onSelectedItemChanged: (i) {
                      month = i + 1;
                      updateTime();
                    },
                    children: List.generate(
                      12,
                      (i) => Center(child: Text("${i + 1}")),
                    ),
                  ),
                ),
                Expanded(
                  child: CupertinoPicker(
                    itemExtent: 40,
                    scrollController: FixedExtentScrollController(
                      initialItem: hour,
                    ),
                    onSelectedItemChanged: (i) {
                      hour = i;
                      updateTime();
                    },
                    children: List.generate(
                      24,
                      (i) => Center(child: Text(i.toString().padLeft(2, '0'))),
                    ),
                  ),
                ),
                Expanded(
                  child: CupertinoPicker(
                    itemExtent: 40,
                    scrollController: FixedExtentScrollController(
                      initialItem: minute,
                    ),
                    onSelectedItemChanged: (i) {
                      minute = i;
                      updateTime();
                    },
                    children: List.generate(
                      60,
                      (i) => Center(child: Text(i.toString().padLeft(2, '0'))),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void handleSave() {
    if (editTime && !isValidPickupTime(pickupTime)) {
      showError("Pickup time must be at least 15 minutes from now");
      return;
    }

    if (editVehicle && selectedVehicle == widget.initialVehicle) {
      showError("Please select a different vehicle");
      return;
    }

    if (!editTime && !editVehicle) {
      showError("No changes selected");
      return;
    }

    Navigator.pop(context, {
      "pickup": editTime ? pickupTime : null,
      "vehicle": editVehicle ? selectedVehicle : null,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text("Amend Booking"),
        backgroundColor: backgroundColor,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        CheckboxListTile(
                          value: editTime,
                          onChanged: (v) => setState(() => editTime = v!),
                          title: const Text("Change Pickup Time"),
                        ),
                        if (editTime) buildTimePicker(),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        CheckboxListTile(
                          value: editVehicle,
                          onChanged: (v) => setState(() => editVehicle = v!),
                          title: const Text("Change Vehicle"),
                        ),

                        if (editVehicle)
                          isLoading
                              ? const Padding(
                                  padding: EdgeInsets.all(20),
                                  child: CircularProgressIndicator(),
                                )
                              : SizedBox(
                                  height: 260,
                                  child: ListView.builder(
                                    itemCount: vehicles.length,
                                    itemBuilder: (_, i) {
                                      final vehicle = vehicles[i];
                                      final isSelected =
                                          selectedVehicle == vehicle;

                                      return GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            selectedVehicle = vehicle;
                                          });
                                        },
                                        child: Container(
                                          margin: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 8,
                                          ),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
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
                                      );
                                    },
                                  ),
                                ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Estimated Price",
                          style: TextStyle(color: Colors.white70),
                        ),
                        Text(
                          "£${estimatedPrice.toStringAsFixed(2)}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.black,
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: handleSave,
                child: const Text("Save Changes"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
