import 'package:gdsc_app/classes/user.dart';
import 'package:gdsc_app/classes/ClubCardData.dart';

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import '../app_config.dart';
import '../utils.dart';

final serverUrl = AppConfig.serverUrl;
class MarkerData {
  final String title;
  final String description;
  final String time;
  final String image;
  final List<dynamic> comments;
  final String eventID;
  final User user;
  bool isRSVP;
  final double latitude;
  final double longitude;
  final List<ClubCardData> clubs;
  MarkerData({required this.title, required this.description, required this.time, required this.image, required this.comments, required this.eventID,
    required this.user, required this.isRSVP, required this.latitude, required this.longitude, required this.clubs
  });


  Future<void> rsvp() async{
    print("rsvp");
    isRSVP = !isRSVP;
    await post(
      Uri.parse('$serverUrl/api/users/RSVP'),
      headers: await getHeaders(),
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
      Uri.parse('$serverUrl/api/users/deRSVP'),
      headers: await getHeaders(),
      body: jsonEncode(<String, dynamic>{
        "uid": user.uid,
        "eventID": eventID
      }),
    );
  }
}