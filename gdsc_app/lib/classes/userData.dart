import 'package:gdsc_app/classes/ClubCardData.dart';
import 'package:gdsc_app/classes/EventCardData.dart';

import 'dart:convert';
import 'package:http/http.dart';
const hostName = "10.0.2.2:3000";

class UserData {
  final String uid;
  String displayName;
  final String email;
  List<String> following;
  String role;
  String downloadURL;
  List<String> myEvents;
  List<String> clubIds;
  List<ClubCardData> clubData = [];
  int classOf;
  List<EventCardData> eventData = [];

  UserData({required this.uid, required this.displayName, required this.email, required this.following,
    required this.role, required this.myEvents, required this.clubIds, required this.downloadURL, required this.classOf
  });

  Future<void> getClubData() async {
    if (this.clubIds != null) {
      for (var i = 0; i < this.clubIds.length; i++) {
        print("loop" + i.toString());
        try {
          final clubIteration = await get(
            Uri.parse('http://$hostName/api/clubs/getClub/${this.clubIds[i]}'),
          );

          if (clubIteration.statusCode == 200) {
            var clubDataResponse = jsonDecode(clubIteration.body)['message'];
            print("HIII");
            print(clubDataResponse);
            clubData.add(
              ClubCardData(
                rating: clubDataResponse['avgRating'].toDouble(),
                  admin: List<String>.from((clubDataResponse['admin'] ?? []).map((event) => event.toString())),
                  category: clubDataResponse['category'],
                  description: clubDataResponse['description'],
                  downloadURL: clubDataResponse['downloadURL'],
                  events: List<String>.from((clubDataResponse['events'] ?? []).map((event) => event.toString())),
                  followers: List<String>.from((clubDataResponse['followers'] ?? []).map((follower) => follower.toString())),
                  name: clubDataResponse['name'],
                  type: clubDataResponse['type'],
                  verified: clubDataResponse['verified'],
                  id: this.clubIds[i]
              ),
            );

            print("Club data added for ID ${this.clubIds[i]}");
          } else {
            print("Error fetching club data for ID ${this.clubIds[i]} - StatusCode: ${clubIteration.statusCode}");
          }
        } catch (error) {
          print("Error fetching club datqa for ID ${this.clubIds[i]}: $error");
        }
      }
    } else {
      print("clubIds is null");
    }
  }

  Future<void> getEventData() async {
    print(this.myEvents);
    if (this.myEvents != null) {
      for (var i = 0; i < this.myEvents.length; i++) {
        print("loop" + i.toString());
        try {
          final eventIteration = await get(
            Uri.parse('http://$hostName/api/events/getEvent/${this.myEvents[i]}'),
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
                  id: this.myEvents[i],
              ),
            );

            print("Event data added for ID ${this.myEvents[i]}");
          } else {
            print("Error fetching event data for ID ${this.myEvents[i]} - StatusCode: ${eventIteration.statusCode}");
          }
        } catch (error) {
          print("Error fetching event data for ID ${this.myEvents[i]}: $error");
        }
      }
    } else {
      print("myEvents is null");
    }
  }

  Future<void> getClubAndEventData() async{
    await getClubData();
    await getEventData();
  }

}