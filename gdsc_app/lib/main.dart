import 'package:flutter/material.dart';
import 'package:gdsc_app/screens/feed.dart';
import 'package:gdsc_app/screens/login.dart';
import 'package:gdsc_app/screens/sign.dart';
import 'package:gdsc_app/screens/createUser.dart';
import 'package:gdsc_app/screens/createClub.dart';
import 'package:gdsc_app/screens/profile.dart';
import 'package:gdsc_app/widgets/appBar.dart';
import 'package:http/http.dart';
import 'dart:async';
import 'dart:convert';
import 'package:gdsc_app/classes/user.dart';


import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:gdsc_app/widgets/appBar.dart';

void main() => runApp(MaterialApp(
  initialRoute: '/createClub',
  routes: {
    '/login': (context) => LoginScreen(),
    '/feed': (context) => MyApp(),
    '/sign': (context) => SignUpScreen(),
    '/createUser': (context) => CreateUserScreen(),
    '/createClub': (context) => CreateClubScreen(),
    '/profile': (context) => ProfileScreen(),
    '/home': (context) => Home(),
  },
));

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  User user = User();
  int selectedIndex = 0;
  List screens = [
    MyApp(),
    ProfileScreen(),
    ProfileScreen()
  ];
  void onClicked(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    isUserSignedIn();
  }
  void isUserSignedIn() async {
    user.isUserSignedIn().then((check){
      if(check){
        user.initUserData();
      }
      else{
        Navigator.pushNamed(context, '/login');
      }
    });

  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      body: Center(
        child: screens.elementAt(selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 40,
        selectedIconTheme: IconThemeData(color: Colors.orange, size: 40),
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.grey),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: selectedIndex, //New
        onTap: onClicked,
      ),
    );
  }
}



