import 'package:flutter/material.dart';
import 'package:gdsc_app/screens/feed.dart';
import 'package:gdsc_app/screens/login.dart';
import 'package:gdsc_app/screens/sign.dart';
import 'package:gdsc_app/screens/search.dart';
import 'package:gdsc_app/screens/profile.dart';
import 'package:gdsc_app/widgets/appBar.dart';

import 'package:gdsc_app/classes/user.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'app_config.dart';


// Define the color as a global variable
Color _orangeColor = Color(0xFFFF8050);

void main() async {
  await dotenv.load(fileName: ".env");
  await AppConfig.loadEnvironment();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/login',
    routes: {
      '/login': (context) => LoginScreen(),
      '/feed': (context) => MyApp(),
      '/sign': (context) => SignUpScreen(),
      '/profile': (context) => ProfileScreen(),
      '/home': (context) => Home(),
      '/search': (context) => SearchScreen(),
    },
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  User user = User();
  int selectedIndex = 0;
  List screens = [
    MyApp(),
    SearchScreen(),
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
        selectedIconTheme: IconThemeData(color: _orangeColor, size: 40), // Use the global variable here
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: '', // Remove the label
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: '', // Remove the label
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '', // Remove the label
          ),
        ],
        currentIndex: selectedIndex,
        onTap: onClicked,
      ),
    );
  }
}
