import 'package:flutter/material.dart';

class AirportPage extends StatefulWidget {
  const AirportPage({super.key, required this.title});

  final String title;
  @override
  State<AirportPage> createState() => _AirportPageState();
}

class _AirportPageState extends State<AirportPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title), centerTitle: true),
      body: const Center(
        child: Text("Air Page", style: TextStyle(fontSize: 22)),
      ),
    );
  }
}
