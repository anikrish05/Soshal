import 'package:gdsc_app/classes/user.dart';
import 'package:gdsc_app/classes/ClubCardData.dart';

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
const hostName = "10.0.2.2:3000";
class MarkerData {
  final String title;
  final String description;
  final String time;
  final String image;
  final List<dynamic> comments;
  final String eventID;
  final User user;
  double rating;
  bool isRSVP;
  final double latitude;
  final double longitude;
  final List<ClubCardData> clubs;
  MarkerData({required this.title, required this.description, required this.time, required this.image, required this.comments, required this.eventID,
    required this.user, required this.rating, required this.isRSVP, required this.latitude, required this.longitude, required this.clubs
  });


  Future<void> rsvp() async{
    print("rsvp");
    isRSVP = !isRSVP;
    await post(
      Uri.parse('http://$hostName/api/users/RSVP'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "uid": user.uid,
        "eventID": eventID
      }),
    );
  }
  Future<void> unRsvp() async{
    print("unRSVP");
    isRSVP = !isRSVP;
    await post(
      Uri.parse('http://$hostName/api/users/deRSVP'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "uid": user.uid,
        "eventID": eventID
      }),
    );
  }
}