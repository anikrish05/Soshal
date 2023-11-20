import 'package:flutter/material.dart';
import 'package:gdsc_app/screens/feed.dart';
import 'package:gdsc_app/screens/login.dart';
import 'package:gdsc_app/screens/sign.dart';
import 'package:gdsc_app/screens/createUser.dart';
import 'package:gdsc_app/screens/createClub.dart';
import 'package:gdsc_app/screens/profile.dart';

import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:gdsc_app/widgets/appBar.dart';

void main() => runApp(MaterialApp(
  initialRoute: '/login',
  routes: {
    '/login': (context) => LoginScreen(),
    '/feed': (context) => MyApp(),
    '/sign': (context) => SignUpScreen(),
    '/createUser': (context) => CreateUserScreen(),
    '/createClub': (context) => CreateClubScreen(),
    '/profile': (context) => ProfileScreen(),
  },
));



