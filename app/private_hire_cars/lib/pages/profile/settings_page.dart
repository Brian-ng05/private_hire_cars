import 'package:flutter/material.dart';
import 'package:private_hire_cars/data/notifiers.dart';
import 'package:private_hire_cars/pages/login_page.dart';
import 'package:private_hire_cars/services/storage_service.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key, required this.title});

  final String title;

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        leading: BackButton(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),

      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                /// Nội dung cài đặt
                Expanded(
                  child: ListView(
                    children: [
                      _buildItem(Icons.notifications, 'Notifications'),
                      _buildItem(Icons.language, 'Language'),
                      _buildItem(Icons.info_outline, 'About us'),
                      _buildItem(Icons.chat_bubble_outline, 'Contact us'),
                    ],
                  ),
                ),

                /// Nút Logout
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      onPressed: () async {
                        await StorageService.clearUser();
                        selectedPageNotifier.value = 0;

                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                const LoginPage(title: "Private Hire Car"),
                          ),
                          (route) => false,
                        );
                      },
                      icon: const Icon(Icons.logout),
                      label: const Text("Log out"),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildItem(IconData icon, String title) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: Colors.black),
          title: Text(title),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {},
        ),
        const Divider(height: 1),
      ],
    );
  }
}
