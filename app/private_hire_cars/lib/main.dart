import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:private_hire_cars/pages/login_page.dart';
import 'package:private_hire_cars/data/constants.dart';
import 'package:private_hire_cars/data/notifiers.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    innitThemeMode();
    super.initState();
  }

  void innitThemeMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool? repeat = prefs.getBool(KConstants.themeModeKey);
    isDarkModeNotifier.value = repeat ?? false;
  }

  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isDarkModeNotifier,
      builder: (context, isDarkMode, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: LoginPage(title: 'Private Hire Car'),
        );
      },
    );
  }
}
