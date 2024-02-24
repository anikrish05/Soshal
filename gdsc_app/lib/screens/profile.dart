import 'package:flutter/material.dart';
import 'package:gdsc_app/classes/userData.dart';
import 'package:gdsc_app/screens/createUser.dart';
import 'package:gdsc_app/screens/login.dart';
import 'package:image_picker/image_picker.dart';
import '../utils.dart';
import '../widgets/profileWidgets/profileHeader.dart';
import '../widgets/profileWidgets/profileWidgetButtons.dart';
import '../widgets/eventWidgets/eventCard.dart';
import '../widgets/clubWidgets/clubCard.dart';
import 'createClub.dart';
import 'dart:async';
import '../widgets/loader.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart' as http_parser;
import '../app_config.dart';
import 'package:gdsc_app/screens/sign.dart';




final serverUrl = AppConfig.serverUrl;

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with TickerProviderStateMixin {
  Color _buttonColor = Color(0xFF88898C);
  Color _slideColor = Colors.orange;
  Color _orangeColor = Color(0xFFFF8050);
  Color _colorTab = Color(0xFFFF8050);
  UserData? user;
  late TabController tabController;
  String newName = "";
  int newGradYr = 0;

  Future<void> getUser() async {
      final response = await http.get(
        Uri.parse('$serverUrl/api/users/userData'),
        headers: await getHeaders(),
      );
      var data = jsonDecode(response.body)['message'];
      UserData tempUser = UserData(
        classOf: data['classOf'],
        uid: data['uid'],
        displayName: data['displayName'],
        email: data['email'],
        following: data['following'],
        role: data['role'],
        myEvents: List<String>.from((data['myEvents'] ?? []).map((event) => event.toString())),
        clubIds: List<String>.from((data['clubsOwned'] ?? []).map((clubID) => clubID.toString())),
        downloadURL: data['downloadURL'],
        likedEvents: List<String>.from((data['likedEvents'] ?? []).map((event) => event.toString())),
        dislikedEvents: List<String>.from((data['dislikedEvents'] ?? []).map((event) => event.toString())),
        friendGroups: List<String>.from((data['friendGroups'] ?? []).map((friend) => friend.toString())),
        interestedTags: List<String>.from((data['interestedTags'] ?? []).map((tag) => tag.toString())),


      );
      user = tempUser;
    await user!.getClubAndEventData();
  }

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    tabController.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      // Read the image file as bytes
      List<int> imageBytes = await pickedFile.readAsBytes();

      // Send the bytes to the server
      await sendImageToServer(imageBytes);
    }
  }

  Future<void> sendImageToServer(List<int> imageBytes) async {
    try {
      final response = await http.post(
        Uri.parse('$serverUrl/api/users/updateProfileImage'),
        headers: await getHeaders(),
        body: jsonEncode(<String, dynamic>{
          "image": imageBytes,
          "uid": user!.uid, // Replace with the actual user ID
        }),
      );

      if (response.statusCode == 200) {
        print('Image uploaded successfully');
        setState(() {});
      } else {
        print('Failed to upload image. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error uploading image: $error');
    }
  }


  FutureOr onGoBack(dynamic value) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: FutureBuilder<void>(
          future: getUser(),
          builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Stack(
                children: [
                  buildProfileUI(),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: IconButton(
                      icon: Icon(
                          Icons.settings,
                          size: 30,
                          color: Colors.grey
                      ),
                      onPressed: () {
                        // Add your settings icon functionality here
                        _showSettingsDialog(context);
                      },
                    ),
                  ),
                ],
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
    double imageSize = 150;
    return ListView(
      children: [
        GestureDetector(
          onScaleUpdate: (details) {
            setState(() {
              imageSize = 100.0 * details.scale.clamp(.8, 10.0);
            });
          },
          child: ProfileHeaderWidget(
            image: user!.downloadURL == "" ? "assets/emptyprofileimage-PhotoRoom.png-PhotoRoom.png" : user!.downloadURL,
            onClicked: _pickImage,
            name: user!.displayName,
            graduationYear: user!.classOf,
            imageSize: user!.downloadURL == "" ? 150.0 : 110.0,
          ),
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
            )),
        Tab(
            child: Text(
              'Clubs',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            )),
      ],
      indicatorPadding: EdgeInsets.symmetric(horizontal: 16),
    );
  }

  Widget getDataTabs() => SizedBox(
    height: MediaQuery.of(context).size.height,
    child: TabBarView(
      children: [
        SingleChildScrollView(
          child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: user!.eventData.length,
              itemBuilder: (context, index) {
                return EventCardWidget(event: user!.eventData[index], isOwner: false);
              }),
        ),
        SingleChildScrollView(
          child: ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: user!.clubData.length ~/ 2 + (user!.clubData.length % 2),
            itemBuilder: (BuildContext context, int index) {
              int firstIndex = index * 2;
              int secondIndex = firstIndex + 1;

              return index == user!.clubData.length ~/ 2
                  ? Center(
                child: ClubCardWidget(club: user!.clubData[firstIndex], isOwner: true, currUser: user!),
              )
                  : Row(
                children: <Widget>[
                  ClubCardWidget(club: user!.clubData[firstIndex], isOwner: true, currUser: user!),
                  if (secondIndex < user!.clubData.length)
                    ClubCardWidget(club: user!.clubData[secondIndex], isOwner: true, currUser: user!),
                ],
              );
            },
          ),
        ),
      ],
      controller: tabController,
    ),
  );

  @override
  void onCreateClub(){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CreateClubScreen(user!.uid)),
    ).then(onGoBack);


  }

  void onUpdateProfile() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CreateUserScreen(user: user!)),
    );

    try {
      newGradYr = result[0];
      newName = result[1];
      String userID = result[2];
      List<String> newTags = result[3];
      print("New Name: $newName");
      print("New Grad Year: $newGradYr");
      final updateProfileData = {
        'displayName': newName,
        'classOf': newGradYr,
        'uid': userID,
        'interestedTags': newTags,
      };
      final response = await http.post(
        Uri.parse('$serverUrl/api/users/updateProfile'),
        headers: await getHeaders(),
        body: jsonEncode(updateProfileData),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print(responseData['message']); // Assuming the server responds with a JSON object containing a 'message' property
      } else {
        print('Error: ${response.statusCode}');
        print(response.body);
      }
    } catch (error) {
      print('Error: $error');
    }

    getUser();
    setState(() {});
  }

  void _showSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: Text(
              "Settings",
              style: TextStyle(
                color: _orangeColor,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 2, vertical: 2), // Adjust the vertical padding to change the size
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 6),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  onPrimary: _orangeColor,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                    side: BorderSide(color: _orangeColor, width: 1),
                  ),
                  textStyle: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 1),
                  child: Text("Sign out"),
                ),
              ),
              SizedBox(height: 2),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pushNamed(context, '/sign');
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  onPrimary: _orangeColor,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                    side: BorderSide(color: _orangeColor, width: 1),
                  ),
                  textStyle: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 1),
                  child: Text("Delete Account"),
                ),
              ),
              SizedBox(height: 5), // Added extra space
            ],
          ),
          actions: [
            Align(
              alignment: Alignment.centerRight, // Align the button to the center right
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  "Close",
                  style: TextStyle(
                    color: _orangeColor,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

}
