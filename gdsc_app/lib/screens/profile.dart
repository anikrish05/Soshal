import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import '../widgets/profileWidgets/profileHeader.dart';
import '../widgets/profileWidgets/profileWidgetButtons.dart';
import '../widgets/eventWidgets/eventCard.dart';
import '../widgets/clubWidgets/clubCard.dart';
import 'package:gdsc_app/classes/ClubCardData.dart';
import 'package:gdsc_app/classes/user.dart';
import '../widgets/loader.dart';
import 'package:gdsc_app/screens/createClub.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with TickerProviderStateMixin {
  Color _buttonColor = Color(0xFF88898C);
  Color _slideColor = Colors.orange;
  Color _colorTab = Color(0xFFFF8050);
  User user = User();
  late TabController tabController;
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    isUserSignedIn();
  }

  @override
  void dispose() {
    super.dispose();
    tabController.dispose();
  }

  dynamic isUserSignedIn() async {
    user.isUserSignedIn().then((check) async {
      if (!check) {
        Navigator.pushNamed(context, '/login');
      }
    });
  }

  Future<bool> getData() async {
    return user.initUserData();
  }

  Future<bool> getClubs() async {
    return user.getClubData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: FutureBuilder<bool>(
          future: getData(),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return FutureBuilder<bool>(
                future: getClubs(),
                builder: (BuildContext context, AsyncSnapshot<bool> clubsSnapshot) {
                  if (clubsSnapshot.connectionState == ConnectionState.done) {
                    return buildProfileUI();
                  } else {
                    return LoaderWidget();
                  }
                },
              );
            } else {
              return LoaderWidget();
            }
          },
        ),
      ),
    );
  }

  Widget buildProfileUI() {
    return ListView(
      children: [
        ProfileHeaderWidget(
          user.downloadURL == "" ? "../assets/logo.png" : user.downloadURL,
              () async {},
          user.displayName,
          2027,
        ),
        CreateButtonsWidget(
          onUpdateProfile,
          onCreateClub,
        ),
        SizedBox(height: 16),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Container(
            height: 1,
            color: _buttonColor,
          ),
        ),
        SizedBox(height: 16),
        buildTabBar(),
        Padding(padding: EdgeInsets.all(8)),
        getDataTabs(),
      ],
    );
  }

  Widget buildTabBar() {
    return TabBar(
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
      ],
      indicatorPadding: EdgeInsets.symmetric(horizontal: 16),
    );
  }

  Widget getDataTabs() => SizedBox(
    height: MediaQuery.of(context).size.height,
    child: TabBarView(
      children: [
        ListView(
          children: [
            EventCardWidget(),
            EventCardWidget(),
          ],
        ),
        ListView.builder(
          itemCount: user.clubData.length,
          itemBuilder: (BuildContext context, int index) {
            return ClubCardWidget(club: user.clubData[index]);
          },
        )
      ],
      controller: tabController,
    ),
  );

  @override
  void onUpdateProfile() {
    print("on create event");
  }

  @override
  void onCreateClub() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CreateClubScreen(user.uid)),
    );
  }
}
