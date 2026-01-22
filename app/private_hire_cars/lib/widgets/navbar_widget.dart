import 'package:flutter/material.dart';
import 'package:private_hire_cars/data/notifiers.dart';

class NavbarWidget extends StatelessWidget {
  const NavbarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: selectedPageNotifier,
      builder: (context, selectedPage, _) {
        return NavigationBarTheme(
          data: NavigationBarThemeData(
            backgroundColor: Colors.white,

            iconTheme: WidgetStateProperty.resolveWith<IconThemeData>((states) {
              return const IconThemeData(size: 28, color: Colors.black87);
            }),
          ),
          child: NavigationBar(
            selectedIndex: selectedPage,
            onDestinationSelected: (int index) {
              selectedPageNotifier.value = index;
            },
            destinations: const [
              NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
              NavigationDestination(
                icon: Icon(Icons.car_rental_rounded),
                label: 'My Trips',
              ),
              NavigationDestination(
                icon: Icon(Icons.notifications),
                label: 'Notifications',
              ),
              NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
            ],
          ),
        );
      },
    );
  }
}
