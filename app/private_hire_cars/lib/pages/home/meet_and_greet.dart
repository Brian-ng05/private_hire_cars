import 'package:flutter/material.dart';

class MeetAndGreet extends StatefulWidget {
  const MeetAndGreet({super.key, required this.title});

  final String title;
  @override
  State<MeetAndGreet> createState() => _MeetAndGreetState();
}

class _MeetAndGreetState extends State<MeetAndGreet> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title), centerTitle: true),
      body: const Center(
        child: Text("Meet & Greet", style: TextStyle(fontSize: 22)),
      ),
    );
  }
}
