import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import '../widgets/profileWidgets/profileHeader.dart';
import '../widgets/profileWidgets/profileWidgetButtons.dart';
import '../widgets/eventWidgets/eventCard.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with TickerProviderStateMixin{
  @override
  void onUpdateProfile() {
    print("on create event");
  }

  void onCreateClub() {
    Navigator.pushNamed(context, '/createClub');
  }



  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
  }
  @override
  void dispose() {
    super.dispose();
    tabController!.dispose();
  }
  Color _buttonColor = Color(0xFF88898C);
  Color _colorTab = Color(0xFFFF8050);
  Color _slideColor = Colors.orange;
  late TabController tabController;
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: ListView(
          children: [
            ProfileHeaderWidget(
              "../assets/logo.png",
                  () async {},
              "Adithya Kartik",
              2027,
            ),
            CreateButtonsWidget(
                onUpdateProfile,
                onCreateClub
            ),
            SizedBox(height: 16), // Add some vertical space between buttons and line
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30), // Adjust the padding as needed
              child: Container(
                height: 1,  // Set the height of the divider
                color: _buttonColor, // Set the color of the line
              ),
            ),
            SizedBox(height: 16),
            CreateCardWidget(
              onCreateEvent: onCreateEvent,
              onCreateClub: onCreateClub,
            ),
          ],
        ),
      ),
    );
  }
            buildTabBar(),// Add some vertical space between line and buttons// Include the buttons widget here
          ],
        ),
      ),
    );
  }
  Widget buildTabBar() => TabBar(
      unselectedLabelColor: _colorTab,
      indicatorSize: TabBarIndicatorSize.tab,
      indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: _colorTab),
      controller: tabController,
      tabs: [
        Tab(
          text: 'Events',
        ),
        Tab(
          text: 'Clubs',
        ),
        Tab(
          text: 'Saved',
        )
      ]
}
