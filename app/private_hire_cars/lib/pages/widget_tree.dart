import 'package:private_hire_cars/data/notifiers.dart';
import 'package:private_hire_cars/pages/home/home_page.dart';
import 'package:private_hire_cars/pages/notifications_page.dart';
import 'package:private_hire_cars/pages/profile/profile_page.dart';
import 'package:private_hire_cars/pages/trips_page.dart';
import 'package:private_hire_cars/widgets/navbar_widget.dart';
import 'package:flutter/material.dart';

List<Widget> pages = [
  HomePage(title: "Private Hire Car"),
  TripsPage(title: "My Trip"),
  NotificationsPage(title: "Notifications"),
  ProfilePage(title: "Profile"),
];

class WidgetTree extends StatelessWidget {
  const WidgetTree({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder(
        valueListenable: selectedPageNotifier,
        builder: (context, selectedPage, child) {
          return pages.elementAt(selectedPage);
        },
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [Divider(height: 0, thickness: 0.5), NavbarWidget()],
      ),
    );
  }
}
