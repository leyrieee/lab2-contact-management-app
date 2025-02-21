import 'package:flutter/material.dart';

/// A widget that displays application information.
///
/// This screen shows basic app info:
/// * App Name and Version
/// * Student Name and ID
/// * Course Name
/// * App Description
class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("About")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Contact Management App",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text("Version 1.0"),
            Text("Developed by Valerie Maame Abena Ackon"),
            Text("Student ID: 79812025"),
            Text("CS443: Mobile App Development"),
            Text("A simple contact management app.")
          ],
        ),
      ),
    );
  }
}
