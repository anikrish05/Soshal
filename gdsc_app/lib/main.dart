import 'package:flutter/material.dart';
import 'package:gdsc_app/screens/login.dart';
import 'package:gdsc_app/screens/feed.dart';
import 'package:gdsc_app/screens/sign.dart';

void main() => runApp(MaterialApp(
  initialRoute: '/login',
  routes: {
    '/login': (context) => LoginScreen(),
    '/feed': (context) => MyApp(),
    '/sign': (context) => SignUpScreen(),
  },
));

