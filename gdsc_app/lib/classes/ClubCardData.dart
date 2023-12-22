import 'package:gdsc_app/classes/EventCardData.dart';
import 'dart:convert';
import 'package:http/http.dart';
const hostName = "10.0.2.2:3000";
class ClubCardData {
  List<String> admin;
  String category;
  String description;
  String downloadURL;
  List<String> events;
  List<String> followers; // Updated to List<String>
  String name;
  String type;
  bool verified;
  final String id;
  double rating;
  List<EventCardData> eventData = [];
  ClubCardData({
    required this.admin,
    required this.category,
    required this.description,
    required this.downloadURL,
    required this.events,
    required this.followers,
    required this.name,
    required this.type,
    required this.verified,
    required this.id,
    required this.rating
  });
  Future<void> getAllEventsForClub() async{
    for(var i=0;i<events.length;i++){

    }
  }
}
