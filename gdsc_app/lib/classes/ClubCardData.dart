import 'package:gdsc_app/classes/EventCardData.dart';
import 'package:gdsc_app/classes/userData.dart';
import 'dart:convert';
import 'package:http/http.dart';
const hostName = "10.0.2.2:3000";
class ClubCardData {
  List<String> admin;
  String category;
  String description;
  String downloadURL;
  List<String> events;
  Map<String, dynamic> followers; // Updated to List<String>
  String name;
  String type;
  bool verified;
  final String id;
  double rating;
  List<EventCardData> eventData = [];
  List<UserData> followerData = [];
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
  Future<void> getALlEventsForClub() async {
    if (this.events != null) {
      for (var i = 0; i < this.events.length; i++) {
        print("loop" + i.toString());
        try {
          final eventIteration = await get(
            Uri.parse('http://$hostName/api/events/getEvent/${this.events[i]}'),
          );

          if (eventIteration.statusCode == 200) {
            var eventDataResponse = jsonDecode(eventIteration.body)['message'];
            eventData.add(
              EventCardData(
                time: eventDataResponse['timestamp'],
                rsvpList: List<String>.from((eventDataResponse['rsvpList'] ?? []).map((rsvp) => rsvp.toString())),
                name: eventDataResponse['name'],
                admin: List<String>.from((eventDataResponse['admin'] ?? []).map((admin) => admin.toString())),
                description: eventDataResponse['description'],
                downloadURL: eventDataResponse['downloadURL'],
                latitude: eventDataResponse['latitude'],
                longitude: eventDataResponse['longitude'],
                rating: eventDataResponse['rating'].toDouble(),
                comments: List<String>.from((eventDataResponse['comments'] ?? []).map((comment) => comment.toString())),
                id: this.events[i],
              ),
            );

            print("Event data added for ID ${this.events[i]}");
          } else {
            print("Error fetching event data for ID ${this.events[i]} - StatusCode: ${eventIteration.statusCode}");
          }
        } catch (error) {
          print("Error fetching event data for ID ${this.events[i]}: $error");
        }
      }
    } else {
      print("myEvents is null");
    }
  }

}
