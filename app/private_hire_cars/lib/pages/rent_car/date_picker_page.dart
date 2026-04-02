import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:private_hire_cars/pages/rent_car/select_car_rent_page.dart';
import 'package:private_hire_cars/services/location_service.dart';

const backgroundColor = Color(0xfff6f7f9);

class DateRangePage extends StatefulWidget {
  const DateRangePage({super.key, required this.title});
  final String title;

  @override
  State<DateRangePage> createState() => _DateRangePageState();
}

class _DateRangePageState extends State<DateRangePage> {
  /// LOCATION
  final locationController = TextEditingController();
  final FocusNode locationFocus = FocusNode();

  bool isLoadingLocation = false;

  /// PICKUP
  int pYear = DateTime.now().year;
  int pMonth = DateTime.now().month;
  int pDay = DateTime.now().day;
  int pHour = DateTime.now().hour;

  /// RETURN
  int rYear = DateTime.now().year;
  int rMonth = DateTime.now().month;
  int rDay = DateTime.now().day;
  int rHour = DateTime.now().hour;

  DateTime? pickupDateTime;
  DateTime? returnDateTime;

  @override
  void initState() {
    super.initState();

    /// AUTO COMPLETE ON UNFOCUS
    locationFocus.addListener(() {
      if (!locationFocus.hasFocus) {
        _autoCompleteLocation();
      }
    });

    final now = DateTime.now().add(const Duration(hours: 2));
    pickupDateTime = now;

    pYear = now.year;
    pMonth = now.month;
    pDay = now.day;
    pHour = now.hour;

    final r = now.add(const Duration(hours: 12));
    returnDateTime = r;

    rYear = r.year;
    rMonth = r.month;
    rDay = r.day;
    rHour = r.hour;
  }

  @override
  void dispose() {
    locationController.dispose();
    locationFocus.dispose();
    super.dispose();
  }

  /// AUTO COMPLETE LOCATION
  Future<void> _autoCompleteLocation() async {
    final text = locationController.text.trim();
    if (text.isEmpty) return;

    setState(() => isLoadingLocation = true);

    try {
      final result = await geocode(text);

      if (result == null) {
        throw Exception("Location not found");
      }

      setState(() {
        locationController.text = result.displayName;
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Location error: $e")));
    } finally {
      if (!mounted) return;
      setState(() => isLoadingLocation = false);
    }
  }

  /// VALIDATE
  bool isValidPickup(DateTime dt) =>
      dt.isAfter(DateTime.now().add(const Duration(hours: 2)));

  bool isValidRange() =>
      returnDateTime!.difference(pickupDateTime!).inHours >= 12;

  bool get canContinue =>
      locationController.text.trim().isNotEmpty &&
      isValidPickup(pickupDateTime!) &&
      isValidRange();

  /// VALID HOUR
  bool isValidHour({required bool isPickup, required int h}) {
    DateTime dt;

    if (isPickup) {
      dt = DateTime(pYear, pMonth, pDay, h);
      return dt.isAfter(DateTime.now().add(const Duration(hours: 2)));
    } else {
      dt = DateTime(rYear, rMonth, rDay, h);
      return dt.difference(pickupDateTime!).inHours >= 12;
    }
  }

  /// UPDATE PICKUP
  void updatePickup() {
    pickupDateTime = DateTime(pYear, pMonth, pDay, pHour);

    final min = DateTime.now().add(const Duration(hours: 2));

    if (pickupDateTime!.isBefore(min)) {
      pickupDateTime = min;
    }

    pYear = pickupDateTime!.year;
    pMonth = pickupDateTime!.month;
    pDay = pickupDateTime!.day;
    pHour = pickupDateTime!.hour;

    final minReturn = pickupDateTime!.add(const Duration(hours: 12));

    if (returnDateTime!.isBefore(minReturn)) {
      returnDateTime = minReturn;

      rYear = minReturn.year;
      rMonth = minReturn.month;
      rDay = minReturn.day;
      rHour = minReturn.hour;
    }

    setState(() {});
  }

  /// UPDATE RETURN
  void updateReturn() {
    returnDateTime = DateTime(rYear, rMonth, rDay, rHour);

    final minReturn = pickupDateTime!.add(const Duration(hours: 12));

    if (returnDateTime!.isBefore(minReturn)) {
      returnDateTime = minReturn;
    }

    rYear = returnDateTime!.year;
    rMonth = returnDateTime!.month;
    rDay = returnDateTime!.day;
    rHour = returnDateTime!.hour;

    setState(() {});
  }

  int daysInMonth(int y, int m) {
    if (m == 2) {
      return (y % 4 == 0 && y % 100 != 0) || y % 400 == 0 ? 29 : 28;
    }
    if ([4, 6, 9, 11].contains(m)) return 30;
    return 31;
  }

  /// LOCATION FIELD UI
  Widget buildLocationField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.black12),
      ),
      child: TextField(
        controller: locationController,
        focusNode: locationFocus,
        decoration: InputDecoration(
          icon: const Icon(Icons.location_on),
          hintText: "Pickup location?",
          border: InputBorder.none,
          suffixIcon: isLoadingLocation
              ? const Padding(
                  padding: EdgeInsets.all(10),
                  child: SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
              : null,
        ),
      ),
    );
  }

  /// PICKER UI
  Widget buildPicker({
    required bool isPickup,
    required int y,
    required int m,
    required int d,
    required int h,
    required Function(int) onDay,
    required Function(int) onMonth,
    required Function(int) onHour,
  }) {
    Widget item(String text, bool enabled, bool selected) {
      return Center(
        child: Text(
          text,
          style: TextStyle(
            fontSize: selected ? 20 : 16,
            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
            color: enabled ? Colors.black : Colors.grey.shade400,
          ),
        ),
      );
    }

    return Column(
      children: [
        const Row(
          children: [
            Expanded(child: Center(child: Text("DAY"))),
            Expanded(child: Center(child: Text("MONTH"))),
            Expanded(child: Center(child: Text("HOUR"))),
          ],
        ),
        const SizedBox(height: 5),
        Container(
          height: 120,
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
                    initialItem: d - 1,
                  ),
                  onSelectedItemChanged: onDay,
                  children: List.generate(
                    daysInMonth(y, m),
                    (i) => item(
                      (i + 1).toString().padLeft(2, '0'),
                      true,
                      i + 1 == d,
                    ),
                  ),
                ),
              ),

              /// MONTH
              Expanded(
                child: CupertinoPicker(
                  itemExtent: 40,
                  scrollController: FixedExtentScrollController(
                    initialItem: m - 1,
                  ),
                  onSelectedItemChanged: onMonth,
                  children: List.generate(
                    12,
                    (i) => item(
                      (i + 1).toString().padLeft(2, '0'),
                      true,
                      i + 1 == m,
                    ),
                  ),
                ),
              ),

              /// HOUR
              Expanded(
                child: CupertinoPicker(
                  itemExtent: 40,
                  scrollController: FixedExtentScrollController(initialItem: h),
                  onSelectedItemChanged: (i) {
                    if (!isValidHour(isPickup: isPickup, h: i)) return;
                    onHour(i);
                  },
                  children: List.generate(24, (i) {
                    final enabled = isValidHour(isPickup: isPickup, h: i);
                    return item(i.toString().padLeft(2, '0'), enabled, i == h);
                  }),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: backgroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            /// LOCATION
            buildLocationField(),
            const SizedBox(height: 25),

            /// PICKUP
            const Text(
              "Pickup time",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            buildPicker(
              isPickup: true,
              y: pYear,
              m: pMonth,
              d: pDay,
              h: pHour,
              onDay: (i) {
                pDay = i + 1;
                updatePickup();
              },
              onMonth: (i) {
                pMonth = i + 1;
                updatePickup();
              },
              onHour: (i) {
                pHour = i;
                updatePickup();
              },
            ),

            const SizedBox(height: 25),

            /// RETURN
            const Text(
              "Return time",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            buildPicker(
              isPickup: false,
              y: rYear,
              m: rMonth,
              d: rDay,
              h: rHour,
              onDay: (i) {
                rDay = i + 1;
                updateReturn();
              },
              onMonth: (i) {
                rMonth = i + 1;
                updateReturn();
              },
              onHour: (i) {
                rHour = i;
                updateReturn();
              },
            ),

            const Spacer(),

            Text(
              "${DateFormat('HH:mm dd/MM').format(pickupDateTime!)}  →  ${DateFormat('HH:mm dd/MM').format(returnDateTime!)}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 15),

            FilledButton(
              onPressed: canContinue
                  ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SelectCarRentPage(
                            pickupTime: pickupDateTime!,
                            returnTime: returnDateTime!,
                            location: locationController.text,
                          ),
                        ),
                      );
                    }
                  : null,
              style: FilledButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text("Choose a car"),
            ),
          ],
        ),
      ),
    );
  }
}
