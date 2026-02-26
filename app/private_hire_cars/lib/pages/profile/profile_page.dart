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
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F6FA),
        title: Text(widget.title),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingPage(title: "Settings"),
                ),
              );
            },
            icon: const Icon(Icons.settings, size: 26),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _profileHeader(),
            const SizedBox(height: 16),
            _loyaltyPoints(),
            const SizedBox(height: 16),
            _infoSection(),
            const SizedBox(height: 16),
            _paymentSection(),
          ],
        ),
      ),
    );
  }
}

Widget _profileHeader() {
  return Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(
      children: [
        const CircleAvatar(
          radius: 36,
          backgroundColor: Colors.black12,
          child: Icon(Icons.person, size: 42, color: Colors.black54),
        ),
        const SizedBox(height: 12),
        const Text(
          "John Doe",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        const Text("johndoe@gmail.com", style: TextStyle(color: Colors.grey)),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {},
            child: const Text(
              "Edit Profile",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _loyaltyPoints() {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Loyalty Points",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.amber.shade100,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text(
            "235 pts",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    ),
  );
}

Widget _infoSection() {
  return _sectionCard(
    title: "Personal Information",
    children: [
      _infoTile("Full Name", "John Doe"),
      _infoTile("Email", "johndoe@gmail.com"),
      _infoTile("Phone Number", "+84********"),
      _infoTile("Address", "Da Nang"),
    ],
  );
}

Widget _paymentSection() {
  return _sectionCard(
    title: "Payment Methods",
    children: [
      _infoTile("Visa", ""),
      _infoTile("Paypal", ""),
      _infoTile("Add Payment Method", ""),
    ],
  );
}

Widget _sectionCard({required String title, required List<Widget> children}) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        ...children,
      ],
    ),
  );
}

Widget _infoTile(String title, String value) {
  return Column(
    children: [
      InkWell(
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontSize: 15)),
              Row(
                children: [
                  if (value.isNotEmpty)
                    Text(value, style: const TextStyle(color: Colors.grey)),
                  const SizedBox(width: 6),
                  const Icon(Icons.arrow_forward_ios, size: 14),
                ],
              ),
            ],
          ),
        ),
      ),
      const Divider(height: 1),
    ],
  );
}
