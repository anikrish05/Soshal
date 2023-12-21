import 'package:flutter/material.dart';
import 'package:gdsc_app/screens/createUser.dart';
import 'package:image_picker/image_picker.dart';
import '../widgets/profileWidgets/profileHeader.dart';
import '../widgets/profileWidgets/profileWidgetButtons.dart';
import '../widgets/eventWidgets/eventCard.dart';
import '../widgets/clubWidgets/clubCard.dart';
import 'package:gdsc_app/classes/ClubCardData.dart';
import 'package:gdsc_app/classes/user.dart';
import '../widgets/loader.dart';
import 'createClub.dart';
import 'dart:async';
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

  Future<bool> getAllEventsClubs() async {
    return user.getClubAndEventData();
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      user.downloadURL = pickedFile.path;
      setState(() {});
      // Perform any additional actions, e.g., upload the image to a server
    }
  }

  FutureOr onGoBack(dynamic value) {
    setState(() {});
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
                future: getAllEventsClubs(),
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
          image: user.downloadURL == "" ? "assets/emptyprofileimage-PhotoRoom.png-PhotoRoom.png" : user.downloadURL,
          onClicked: _pickImage,
          name: user.displayName,
          graduationYear: user.classOf,
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
            child: Text(
              'Events',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            )        ),
        Tab(
            child: Text(
              'Clubs',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            )
        ),
      ],
      indicatorPadding: EdgeInsets.symmetric(horizontal: 16),
    );
  }

  Widget getDataTabs() => SizedBox(
    height: MediaQuery.of(context).size.height,
    child: TabBarView(
      children: [
        ListView.builder(
            itemCount: user.eventData.length,
            itemBuilder: (context, index){
              return EventCardWidget(event: user.eventData[index]);
            }
        ),
        ListView.builder(
          itemCount: user.clubData.length ~/ 2 + (user.clubData.length % 2),
          itemBuilder: (BuildContext context, int index) {
            int firstIndex = index * 2;
            int secondIndex = firstIndex + 1;

            return index == user.clubData.length ~/ 2
                ? Center(
              child: ClubCardWidget(club: user.clubData[firstIndex]),
            )
                : Row(
              children: <Widget>[
                ClubCardWidget(club: user.clubData[firstIndex]),
                if (secondIndex < user.clubData.length)
                  ClubCardWidget(club: user.clubData[secondIndex]),
              ],
            );
          },
        ),
      ],
      controller: tabController,
    ),
  );


  @override
  void onCreateClub() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CreateClubScreen(user.uid)),
    ).then(onGoBack);
  }


  void onUpdateProfile(){
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CreateUserScreen(user:user)),
    ).then(onGoBack);
  }
}

