import 'package:gdsc_app/classes/EventCardData.dart';
import 'package:gdsc_app/classes/userData.dart';
import 'dart:convert';
import 'package:http/http.dart';
import '../app_config.dart';

final serverUrl = AppConfig.serverUrl;
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
  List<UserData> followerDeclinedData = [];
  List<UserData> followerActionRequired = [];
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
    eventData = [];
    if (this.events != null) {
      for (var i = 0; i < this.events.length; i++) {
        print("loop" + i.toString());
        try {
          final eventIteration = await get(
            Uri.parse('$serverUrl/api/events/getEvent/${this.events[i]}'),
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

  Future<void> getFollowerData() async {
    followerData = [];
    followerDeclinedData = [];
    followerActionRequired = [];
    followers.forEach((uid, type) async {
      try {
        final response = await get(
          Uri.parse('$serverUrl/api/users/getUser/$uid'),
        );
        if (response.statusCode == 200) {
          // If the server returns a 200 OK response, parse the response body
          var userData = json.decode(response.body)['message'];
          if(type == "Accepted"){
            followerData.add(UserData(
                uid: uid,
                displayName: userData['displayName'],
                email: userData['email'],
                following: userData['following'],
                role: userData['role'],
                myEvents: List<String>.from((userData['myEvents'] ?? []).map((event) => event.toString())),
                clubIds: List<String>.from((userData['clubIds'] ?? []).map((club) => club.toString())),
                downloadURL: userData['downloadURL'],
                classOf: userData['classOf'])
            );
          }
          else if(type == "Denied"){
            followerDeclinedData.add(UserData(
                uid: uid,
                displayName: userData['displayName'],
                email: userData['email'],
                following: userData['following'],
                role: userData['role'],
                myEvents: List<String>.from((userData['myEvents'] ?? []).map((event) => event.toString())),
                clubIds: List<String>.from((userData['clubIds'] ?? []).map((club) => club.toString())),
                downloadURL: userData['downloadURL'],
                classOf: userData['classOf'])
            );
          }
          else if(type == "Requested"){
            followerActionRequired.add(UserData(
                uid: uid,
                displayName: userData['displayName'],
                email: userData['email'],
                following: userData['following'],
                role: userData['role'],
                myEvents: List<String>.from((userData['myEvents'] ?? []).map((event) => event.toString())),
                clubIds: List<String>.from((userData['clubIds'] ?? []).map((club) => club.toString())),
                downloadURL: userData['downloadURL'],
                classOf: userData['classOf'])
            );
          }
          // Process the userData as needed
          print('User data for ID $uid: $userData');
        } else {
          // If the server did not return a 200 OK response,
          // throw an exception or handle the error accordingly
          throw Exception('Failed to load user data for ID $uid');
        }
      } catch (error) {
        // Handle the error, you can log it or perform other actions
        print('Error fetching user data for ID $uid: $error');
      }
    });
  }

}
