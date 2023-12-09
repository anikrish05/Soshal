import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../widgets/profileWidgets/profileHeader.dart';
import '../widgets/profileWidgets/profileWidgetButtons.dart';
import '../widgets/eventWidgets/eventCard.dart';
import 'package:gdsc_app/classes/user.dart';
import '../widgets/loader.dart';
import 'package:gdsc_app/screens/createClub.dart';
import 'dart:io';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with TickerProviderStateMixin {
  File? image;
  late TabController tabController;
  Color _colorTab = Color(0xFFFF8050);
  User user = User();

  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
    isUserSignedIn();
  }

  void dispose() {
    super.dispose();
    tabController!.dispose();
  }

  dynamic isUserSignedIn() async {
    user.isUserSignedIn().then((check) async {
      if (check) {
        print("hello");
        Future<bool> check = user.initUserData();
      } else {
        Navigator.pushNamed(context, '/login');
      }
    });
  }

  Future<bool> getData() async {
    return (user.initUserData());
  }

  void onUpdateProfile() {
    print("on create event");
  }

  void onCreateClub() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CreateClubScreen(user.uid)),
    );
  }

  void onImagePicked() async {
    setState(() {});
    await Future.delayed(Duration.zero);
    final res = await user.updateProfilePic(this.image!);
  }


  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemp = File(image.path);
      onImagePicked(); // Trigger the callback to re-render ProfileHeaderWidget
      setState(() => this.image = imageTemp);
    } catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: FutureBuilder<bool>(
          future: getData(),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (snapshot.hasData) {
              return ListView(
                children: [
                  ProfileHeaderWidget(
                    image: this.image,
                    onClicked: () async {
                      pickImage();
                    },
                    name: user.displayName,
                    graduationYear: 2027,
                    onImagePicked: onImagePicked,
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
                      color: Colors.grey[300],
                    ),
                  ),
                  SizedBox(height: 16),
                  buildTabBar(),
                  Padding(padding: EdgeInsets.all(8)),
                  CreateCardWidget(),
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
    indicatorPadding: EdgeInsets.symmetric(horizontal: 16),
  );
}
