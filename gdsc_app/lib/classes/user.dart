// classes/User.dart

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:gdsc_app/classes/ClubCardData.dart';
import '../app_config.dart';

import '../utils.dart';
import 'EventCardData.dart';

final serverUrl = AppConfig.serverUrl;
class User {
  String uid = "";
  String displayName = "";
  String downloadURL = "";
  String email = "";
  Map<String, dynamic> following = {};
  String role = "";
  List<String> myEvents = [];
  List<EventCardData> eventData = [];
  List<ClubCardData> clubData = [];
  List<String> clubIds = [];
  int classOf = 0;

  Future<bool> isUserSignedIn() async {
    final response = await get(Uri.parse('$serverUrl/api/users/signedIn'),
      headers: await getHeaders(),
    );
    print(jsonDecode(response.body));
    if ((jsonDecode(response.body))['message'] == false) {
      return false;
    }
    return true;
  }

  Future<bool> initUserData() async {
    final response = await get(Uri.parse('$serverUrl/api/users/userData'),
      headers: await getHeaders(),
    );
    var data = jsonDecode(response.body)['message'];
    this.uid = data['uid'];
    this.displayName = data['displayName'];
    this.downloadURL = data['downloadURL'];
    this.email = data['email'];
    this.following = data['following'];
    this.role = data['role'];
    this.myEvents = List<String>.from(data['myEvents'] ?? []);
    this.clubIds = List<String>.from(data['clubsOwned'] ?? []);
    this.classOf = data['classOf'];

    return true;
  }

  Future<void> getClubData() async {
    if (this.clubIds != null) {
      for (var i = 0; i < this.clubIds.length; i++) {
        print("loop" + i.toString());
        try {
          final clubIteration = await get(
            Uri.parse('$serverUrl/api/clubs/getClub/${this.clubIds[i]}'),
            headers: await getHeaders(),
          );

          if (clubIteration.statusCode == 200) {
            var clubDataResponse = jsonDecode(clubIteration.body)['message'];
            clubData.add(
              ClubCardData(
                admin: List<String>.from((clubDataResponse['admin'] ?? []).map((event) => event.toString())),
                category: clubDataResponse['category'],
                description: clubDataResponse['description'],
                downloadURL: clubDataResponse['downloadURL'],
                events: List<String>.from((clubDataResponse['events'] ?? []).map((event) => event.toString())),
                followers: clubDataResponse['followers'],
                name: clubDataResponse['name'],
                type: clubDataResponse['type'],
                verified: clubDataResponse['verified'],
                id: this.clubIds[i],
                rating: clubDataResponse['avgRating'].toDouble(),
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
            Uri.parse('$serverUrl/api/events/getEvent/${this.myEvents[i]}'),
            headers: await getHeaders(),
          );

          if (eventIteration.statusCode == 200) {
            var eventDataResponse = jsonDecode(eventIteration.body)['message'];
            List<ClubCardData> clubInfo = [];
            /*
            for(int i =0;i<eventDataResponse['clubInfo']; i++){
              clubInfo.add(
              ClubCardData(
                admin: List<String>.from((eventDataResponse['clubInfo']['admin'] ?? []).map((event) => event.toString())),
                category: eventDataResponse['clubInfo']['category'],
                description: eventDataResponse['clubInfo']['description'],
                downloadURL: eventDataResponse['clubInfo']['downloadURL'],
                events: List<String>.from((eventDataResponse['clubInfo']['events'] ?? []).map((event) => event.toString())),
                followers: List<String>.from((eventDataResponse['clubInfo']['followers'] ?? []).map((follower) => follower.toString())),
                name: eventDataResponse['clubInfo']['name'],
                type: eventDataResponse['clubInfo']['type'],
                verified: eventDataResponse['clubInfo']['verified'],
                id: eventDataResponse['clubInfo']['id'],
                rating: eventDataResponse['clubInfo']['avgRating'].toDouble(),
              ),
              );

            }
            */
            eventData.add(
              EventCardData(
                time: eventDataResponse['name']['timestamp'],
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

  Future<bool> getClubAndEventData() async{
    await getClubData();
    await getEventData();
    return true;
  }

  Future<bool> signIn(String email, String password) async {
    print("in SignIn");
    final response = await post(
      Uri.parse('$serverUrl/api/users/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "email": email,
        "password": password
      }),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}