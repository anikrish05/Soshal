import 'package:flutter/material.dart';
import 'package:gdsc_app/screens/feed.dart';
import 'package:gdsc_app/screens/login.dart';
import 'package:gdsc_app/screens/sign.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:gdsc_app/widgets/appBar.dart';

void main() => runApp(MaterialApp(
  initialRoute: '/login',
  routes: {
    '/login': (context) => LoginScreen(),
    '/feed': (context) => MyApp(),
    '/sign': (context) => SignUpScreen(),
  },
));


class NavBottomWidget extends StatefulWidget {
  @override
  _NavBottomWidgetState createState() => _NavBottomWidgetState();
}

class _NavBottomWidgetState extends State<NavBottomWidget> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
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
      currentIndex: _selectedIndex, //New
      onTap: _onItemTapped,
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}



