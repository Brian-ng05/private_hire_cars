import 'package:flutter/material.dart';
import 'package:private_hire_cars/classes/homePage/service_card.dart';
import 'package:private_hire_cars/pages/home/location_page.dart';
import 'package:private_hire_cars/pages/home/meet_and_greet.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff6f7f9),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Hello, Brian!",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 6),

              Row(
                children: const [
                  Icon(Icons.location_on, size: 18),
                  SizedBox(width: 4),
                  Text("Son Tra, Da Nang", style: TextStyle(fontSize: 15)),
                ],
              ),

              const SizedBox(height: 18),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.black12),
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    icon: Icon(Icons.search),
                    hintText: "Where to?",
                    border: InputBorder.none,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              const Text(
                "Services",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 16),

              GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: 1.5,
                children: [
                  ServiceCard(
                    icon: Icons.directions_car,
                    title: "Airport & Hotel transfer",
                    subtitle: "Pick up at airport",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const LocationPage(title: "Transport"),
                        ),
                      );
                    },
                  ),

                  ServiceCard(
                    icon: Icons.flight,
                    title: "Meet & Greet",
                    subtitle: "",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const MeetAndGreet(title: "Transport"),
                        ),
                      );
                    },
                  ),
                  ServiceCard(
                    icon: Icons.route_outlined,
                    title: "Intercity",
                    subtitle: "Local/Long distance",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const LocationPage(title: "Transport"),
                        ),
                      );
                    },
                  ),
                  ServiceCard(
                    icon: Icons.access_time,
                    title: "Daily hire",
                    subtitle: "Car and driver",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const LocationPage(title: "Transport"),
                        ),
                      );
                    },
                  ),
                ],
              ),

              const SizedBox(height: 30),

              const Text(
                "Discount",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 16),

              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  "https://images.unsplash.com/photo-1549924231-f129b911e442",
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
