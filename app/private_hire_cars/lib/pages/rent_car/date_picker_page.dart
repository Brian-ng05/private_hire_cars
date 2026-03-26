import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:private_hire_cars/pages/rent_car/select_car_rent_page.dart';

const backgroundColor = Color(0xfff6f7f9);

class DateRangePage extends StatefulWidget {
  const DateRangePage({super.key, required this.title});
  final String title;

  @override
  State<DateRangePage> createState() => _DateRangePageState();
}

class _DateRangePageState extends State<DateRangePage> {
  int pYear = DateTime.now().year;
  int pMonth = DateTime.now().month;
  int pDay = DateTime.now().day;
  int pHour = DateTime.now().hour;

  int rYear = DateTime.now().year;
  int rMonth = DateTime.now().month;
  int rDay = DateTime.now().day;
  int rHour = DateTime.now().hour;

  DateTime? pickupDateTime;
  DateTime? returnDateTime;

  @override
  void initState() {
    super.initState();

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

  /// VALIDATE
  bool isValidPickup(DateTime dt) =>
      dt.isAfter(DateTime.now().add(const Duration(hours: 2)));

  bool isValidRange() =>
      returnDateTime!.difference(pickupDateTime!).inHours >= 12;

  bool get canContinue => isValidPickup(pickupDateTime!) && isValidRange();

  /// CHECK HOUR (FIXED)
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

  /// UPDATE PICKUP (FIXED)
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

  /// UPDATE RETURN (FIXED)
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
            Expanded(
              child: Center(
                child: Text(
                  "DAY",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  "MONTH",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  "HOUR",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
            ),
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
              onPressed: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SelectCarRentPage(
                      pickupTime: pickupDateTime!,
                      returnTime: returnDateTime!,
                    ),
                  ),
                ),
              },
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
