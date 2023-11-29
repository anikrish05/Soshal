import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import '../widgets/profileWidgets/profileHeader.dart';
import '../widgets/profileWidgets/profileWidgetButtons.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void onCreateEvent() {
    print("on create event");
  }

  @override
  void onCreateClub() {
    print("on create club");
  }

  Color _buttonColor = Color(0xFF88898C);

  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: ListView(
          children: [
            ProfileHeaderWidget(
              "../assets/logo.png",
                  () async {},
              "Aditi Namble",
              2027,
            ),
            CreateButtonsWidget(
              onCreateEvent: () {
                // Add logic to handle "Create Event" button press
                print('Create Event button pressed');
              },
              onCreateClub: () {
                // Add logic to handle "Create Club" button press
                print('Create Club button pressed');
              },
            ),
            SizedBox(height: 16), // Add some vertical space between buttons and line
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30), // Adjust the padding as needed
              child: Container(
                height: 1,  // Set the height of the divider
                color: _buttonColor, // Set the color of the line
              ),
            ),
          ],
        ),
      ),
    );
  }
}
