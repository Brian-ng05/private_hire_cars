import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:private_hire_cars/pages/home/select_ride_page.dart';
import 'package:private_hire_cars/services/location_service.dart';
import 'package:latlong2/latlong.dart';

const backgroundColor = Color(0xfff6f7f9);

class LocationPage extends StatefulWidget {
  const LocationPage({super.key, required this.title});
  final String title;

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  final pickupController = TextEditingController();
  final dropoffController = TextEditingController();

  double result = 0.0;

  bool isLoading = false;
  bool isLocked = false;
  bool isValidPickupTime(DateTime time) {
    final nowPlus15 = DateTime.now().add(const Duration(minutes: 15));
    return time.isAfter(nowPlus15);
  }

  /// DATE TIME STATE
  int selectedYear = DateTime.now().year;
  int selectedMonth = DateTime.now().month;
  int selectedDay = DateTime.now().day;
  int selectedHour = DateTime.now().hour;
  int selectedMinute = DateTime.now().minute;

  DateTime? finalDateTime;

  @override
  void initState() {
    super.initState();

    pickupController.addListener(_unlockAll);
    dropoffController.addListener(_unlockAll);

    /// DEFAULT TIME = NOW + 15 MINUTES
    final initial = DateTime.now().add(const Duration(minutes: 15));

    selectedYear = initial.year;
    selectedMonth = initial.month;
    selectedDay = initial.day;
    selectedHour = initial.hour;
    selectedMinute = initial.minute;

    finalDateTime = initial;
  }

  @override
  void dispose() {
    pickupController.dispose();
    dropoffController.dispose();
    super.dispose();
  }

  void _unlockAll() {
    if (isLocked) return;

    setState(() {
      result = 0;
      finalDateTime = null;
    });
  }

  bool get canSubmit =>
      pickupController.text.trim().isNotEmpty &&
      dropoffController.text.trim().isNotEmpty &&
      !isLoading &&
      !isLocked;
  Future<void> calculate() async {
    if (!canSubmit) return;

    setState(() => isLoading = true);

    try {
      final pickupResult = await geocode(pickupController.text.trim());
      final dropoffResult = await geocode(dropoffController.text.trim());

      if (pickupResult == null || dropoffResult == null) {
        throw Exception("Address not found");
      }

      final km = calculateDistance(
        pickupResult.location,
        dropoffResult.location,
      );

      setState(() {
        result = km;
        isLocked = true;
      });

      pickupController.text = pickupResult.displayName;
      dropoffController.text = dropoffResult.displayName;
    } catch (e) {
      setState(() => result = 0);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (!mounted) return;
      setState(() => isLoading = false);
    }
  }

  /// UPDATE DATE TIME WHEN USER SCROLLS
  void updateDateTime() {
    finalDateTime = DateTime(
      selectedYear,
      selectedMonth,
      selectedDay,
      selectedHour,
      selectedMinute,
    );

    setState(() {});
  }

  /// DATE HELPERS
  bool isLeapYear(int year) {
    if (year % 400 == 0) return true;
    if (year % 100 == 0) return false;
    return year % 4 == 0;
  }

  int daysInMonth(int year, int month) {
    switch (month) {
      case 2:
        return isLeapYear(year) ? 29 : 28;
      case 4:
      case 6:
      case 9:
      case 11:
        return 30;
      default:
        return 31;
    }
  }

  List<int> get yearList {
    final currentYear = DateTime.now().year;
    return List.generate(6, (index) => currentYear + index);
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
              _buildInput(
                controller: pickupController,
                icon: Icons.circle_outlined,
                hint: "Departure?",
              ),

              const SizedBox(height: 20),

              _buildInput(
                controller: dropoffController,
                icon: Icons.pin_drop_rounded,
                hint: "Destination?",
              ),

              const SizedBox(height: 24),

              /// CONFIRM LOCATION
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

              if (result > 0.0) ...[
                Text(
                  "The distance is: $result km",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 25),

                /// DATE TIME PICKER
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      /// DAY
                      Expanded(
                        child: CupertinoPicker(
                          itemExtent: 40,
                          scrollController: FixedExtentScrollController(
                            initialItem: selectedDay - 1,
                          ),
                          onSelectedItemChanged: (index) {
                            selectedDay = index + 1;
                            updateDateTime();
                          },
                          children: List.generate(
                            daysInMonth(selectedYear, selectedMonth),
                            (index) => Center(
                              child: Text(
                                (index + 1).toString().padLeft(2, '0'),
                                style: const TextStyle(fontSize: 18),
                              ),
                            ),
                          ),
                        ),
                      ),

                      /// MONTH
                      Expanded(
                        child: CupertinoPicker(
                          itemExtent: 40,
                          scrollController: FixedExtentScrollController(
                            initialItem: selectedMonth - 1,
                          ),
                          onSelectedItemChanged: (index) {
                            selectedMonth = index + 1;

                            int maxDay = daysInMonth(
                              selectedYear,
                              selectedMonth,
                            );
                            if (selectedDay > maxDay) {
                              selectedDay = maxDay;
                            }

                            updateDateTime();
                          },
                          children: List.generate(
                            12,
                            (index) => Center(
                              child: Text(
                                (index + 1).toString().padLeft(2, '0'),
                                style: const TextStyle(fontSize: 18),
                              ),
                            ),
                          ),
                        ),
                      ),

                      /// YEAR
                      Expanded(
                        child: CupertinoPicker(
                          itemExtent: 40,
                          scrollController: FixedExtentScrollController(
                            initialItem: 0,
                          ),
                          onSelectedItemChanged: (index) {
                            selectedYear = yearList[index];

                            int maxDay = daysInMonth(
                              selectedYear,
                              selectedMonth,
                            );
                            if (selectedDay > maxDay) {
                              selectedDay = maxDay;
                            }

                            updateDateTime();
                          },
                          children: yearList
                              .map(
                                (year) => Center(
                                  child: Text(
                                    year.toString(),
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),

                      /// HOUR
                      Expanded(
                        child: CupertinoPicker(
                          itemExtent: 40,
                          scrollController: FixedExtentScrollController(
                            initialItem: selectedHour,
                          ),
                          onSelectedItemChanged: (index) {
                            selectedHour = index;
                            updateDateTime();
                          },
                          children: List.generate(
                            24,
                            (index) => Center(
                              child: Text(
                                index.toString().padLeft(2, '0'),
                                style: const TextStyle(fontSize: 18),
                              ),
                            ),
                          ),
                        ),
                      ),

                      /// MINUTE
                      Expanded(
                        child: CupertinoPicker(
                          itemExtent: 40,
                          scrollController: FixedExtentScrollController(
                            initialItem: selectedMinute,
                          ),
                          onSelectedItemChanged: (index) {
                            selectedMinute = index;
                            updateDateTime();
                          },
                          children: List.generate(
                            60,
                            (index) => Center(
                              child: Text(
                                index.toString().padLeft(2, '0'),
                                style: const TextStyle(fontSize: 18),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                if (finalDateTime != null)
                  Text(
                    "Pickup time: ${DateFormat('HH:mm - dd/MM/yyyy').format(finalDateTime!)}",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ],
          ),
        ),
      ),

      /// CHOOSE CAR
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 50),
            ),
            onPressed: (isLocked && finalDateTime != null)
                ? () {
                    if (!isValidPickupTime(finalDateTime!)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Pickup time must be at least 15 minutes from now",
                          ),
                        ),
                      );
                      return;
                    }

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SelectRidePage(
                          quantity: result,
                          departure: pickupController.text,
                          destination: dropoffController.text,
                          time: finalDateTime!,
                        ),
                      ),
                    );
                  }
                : null,
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
