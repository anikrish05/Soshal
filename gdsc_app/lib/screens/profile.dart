import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import '../widgets/profileWidgets/profileHeader.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: ListView(
          children: [
            ProfileHeaderWidget(
              "../assets/logo.png",
              () async{}
            )
          ],
        ),
      ),
    );
  }
}