import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import '../widgets/profileWidgets/profileHeader.dart';
import '../widgets/profileWidgets/profileWidgetButtons.dart';
import '../widgets/eventWidgets/eventCard.dart';
import 'package:gdsc_app/classes/user.dart';
import '../widgets/loader.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with TickerProviderStateMixin{
  @override
  void onUpdateProfile() {
    print("on create event");
  }

  @override
  void onCreateClub() {
    Navigator.pushNamed(context, '/createClub');
  }

  Color _buttonColor = Color(0xFF88898C);
  Color _slideColor = Colors.orange;
  Color _colorTab = Color(0xFFFF8050);
  User user = User();
  late TabController tabController;
  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
    isUserSignedIn();

  }
  @override
  void dispose() {
    super.dispose();
    tabController!.dispose();
  }

  dynamic isUserSignedIn() async {
    user.isUserSignedIn().then((check) async {
      if(check){
        print("hello");
        Future<bool> check = user.initUserData();
      }
      else{
        Navigator.pushNamed(context, '/login');
      }
    });
  }
  Future<bool> getData() async{
    return(user.initUserData());
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: FutureBuilder<bool>(
          future: getData(),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot)
    {
      if (snapshot.hasData){
        return (
            ListView(
              children: [
                ProfileHeaderWidget(
                  user.downloadURL == "" ? "../assets/logo.png" : user
                      .downloadURL,
                      () async {},
                  user.displayName,
                  2027,
                ),
                CreateButtonsWidget(
                    onUpdateProfile,
                    onCreateClub
                ),
                SizedBox(height: 16),
                // Add some vertical space between buttons and line
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  // Adjust the padding as needed
                  child: Container(
                    height: 1, // Set the height of the divider
                    color: _buttonColor, // Set the color of the line
                  ),
                ),
                SizedBox(height: 16),
                buildTabBar(),
                Padding(padding: EdgeInsets.all(8)),
                CreateCardWidget(),
                // Add some vertical space between line and buttons// Include the buttons widget here
              ],
            )
        );
    }
      else{
        return(
            LoaderWidget()
        );
      }
          }
        ),
      ),
    );
  }
  Widget buildTabBar() => TabBar(
    unselectedLabelColor: _colorTab,
    indicatorSize: TabBarIndicatorSize.tab,
    indicator: BoxDecoration(
      borderRadius: BorderRadius.circular(50),
      color: _colorTab,
    ),
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
      ),
    ],
    indicatorPadding: EdgeInsets.symmetric(horizontal: 16), // Adjust the padding as needed
  );

}