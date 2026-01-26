import 'package:flutter/material.dart';
import '../../data/home_data.dart'; // Make sure this path is correct based on your folder structure

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // We removed _selectedIndex because 'WidgetTree' handles navigation now.

  // --- MOCK DATA ---
  final List<ServiceItem> services = [
    ServiceItem(id: '1', title: 'Ride now', subtitle: 'Book a trip', icon: Icons.directions_car_filled_outlined, route: '/booking'),
    ServiceItem(id: '2', title: 'Airport', subtitle: 'Pick up at airport', icon: Icons.flight_takeoff, route: '/booking'),
    ServiceItem(id: '3', title: 'Intercity', subtitle: 'Long distance', icon: Icons.location_city, route: '/booking'),
    ServiceItem(id: '4', title: 'Daily hire', subtitle: 'Car and driver', icon: Icons.schedule, route: '/booking'),
  ];

  final List<PromotionItem> promotions = [
    PromotionItem(id: '101', title: 'Lunar New Year', discountCode: 'LNY2025', discountAmount: '20% OFF', backgroundColor: Colors.redAccent, route: '/promo-details'),
    PromotionItem(id: '102', title: 'First Ride', discountCode: 'WELCOME', discountAmount: '50% OFF', backgroundColor: Colors.blueAccent, route: '/promo-details'),
    PromotionItem(id: '103', title: 'Weekend', discountCode: 'WEEKEND', discountAmount: '10% OFF', backgroundColor: Colors.green, route: '/promo-details'),
  ];

  @override
  Widget build(BuildContext context) {
    // Note: We use Scaffold here to set the white background, 
    // but we DO NOT add an AppBar or BottomNavigationBar.
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- HEADER SECTION (Replaces the standard AppBar) ---
              // We use the design's "Hello User" instead of widget.title
              const Text(
                "Hello, User!",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              Row(
                children: const [
                  Icon(Icons.location_on_outlined, size: 16, color: Colors.black),
                  SizedBox(width: 5),
                  Text(
                    "Son Tra, Da Nang",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // --- SEARCH BAR ---
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.grey.shade300),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    hintText: "Where to?",
                    prefixIcon: Icon(Icons.search, color: Colors.black),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 15),
                  ),
                ),
              ),
              const SizedBox(height: 25),

              // --- DYNAMIC SERVICES GRID ---
              const Text(
                "Services",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              Wrap(
                spacing: 15,
                runSpacing: 15,
                children: services.map((service) {
                  return _buildServiceCard(
                    icon: service.icon,
                    title: service.title,
                    subtitle: service.subtitle,
                    onTap: () {
                      print("User clicked ${service.title}");
                      // In the future, you might use your team's router here
                      // Navigator.pushNamed(context, service.route);
                    },
                  );
                }).toList(),
              ),

              const SizedBox(height: 25),

              // --- DYNAMIC DISCOUNT SECTION ---
              const Text(
                "Discount",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              SizedBox(
                height: 180,
                child: PageView.builder(
                  controller: PageController(viewportFraction: 0.9),
                  itemCount: promotions.length,
                  itemBuilder: (context, index) {
                    final promo = promotions[index];
                    return _buildDiscountBanner(
                      promo.backgroundColor,
                      promo.title,
                      promo.discountAmount,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- HELPER WIDGETS ---

  Widget _buildServiceCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    double cardWidth = (MediaQuery.of(context).size.width - 40 - 15) / 2;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        hoverColor: Colors.grey.shade200,
        splashColor: Colors.grey.shade300,
        child: Container(
          width: cardWidth,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 40, color: Colors.black),
              const SizedBox(height: 10),
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDiscountBanner(Color color, String title, String discount) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          Positioned(
            left: 20,
            top: 40,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text(
                  discount,
                  style: const TextStyle(
                    color: Colors.yellow,
                    fontWeight: FontWeight.w900,
                    fontSize: 32,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    "BOOK NOW & SAVE",
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}