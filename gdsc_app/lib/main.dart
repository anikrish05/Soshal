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
import 'package:firebase_core/firebase_core.dart';

import 'package:firebase_messaging/firebase_messaging.dart';

import 'firebase_api.dart';

// Define the color as a global variable
Color _orangeColor = Color(0xFFFF8050);

void main() async {
  await dotenv.load(fileName: ".env");
  await AppConfig.loadEnvironment();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseApi().initNotifications();

  runApp(
    MaterialApp(
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
    ),
  );
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
    //isUserSignedIn();
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
            icon: ImageIcon(AssetImage('assets/newMap.png'),
              size: 40, // Adjust width as needed
            ),
            label: '', // Remove the label
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/newSearch.png'),
              size: 40,
            ),// Adjust width as needed
            label: '',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/newPerson.png'),
              size: 40,
            ),
            label: '', // Remove the label
          ),
        ],
        currentIndex: selectedIndex,
        onTap: onClicked,
      ),
    );
  }
}
