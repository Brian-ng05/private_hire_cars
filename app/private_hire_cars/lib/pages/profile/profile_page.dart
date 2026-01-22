import 'package:flutter/material.dart';
import 'package:private_hire_cars/pages/profile/settings_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, required this.title});
  final String title;
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return SettingPage(title: "Settings");
                  },
                ),
              );
            },
            icon: Icon(Icons.settings, size: 28, color: Colors.black87),
          ),
        ],
      ),
      body: const Center(
        child: Text("Profile Page", style: TextStyle(fontSize: 22)),
      ),
    );
  }
}
