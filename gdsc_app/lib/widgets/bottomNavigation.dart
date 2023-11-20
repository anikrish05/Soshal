import 'package:flutter/material.dart';
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
    if(_selectedIndex==0){
      Navigator.pushNamed(context, '/feed');
    }
    else if(_selectedIndex==2){
      Navigator.pushNamed(context, '/profile');
    }
  }
}