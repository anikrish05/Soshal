import 'package:gdsc_app/classes/EventCardData.dart';
import 'package:gdsc_app/classes/userData.dart';
import 'dart:convert';
import 'package:http/http.dart';
import '../app_config.dart';
import '../utils.dart';

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
  List<String> tags;
  List<EventCardData> eventData = [];
  List<List<dynamic>> followerData = [];
  List<List<dynamic>> followerDeclinedData = [];
  List<List<dynamic>> followerActionRequired = [];
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
    required this.rating,
    required this.tags
  });
  Future<void> getALlEventsForClub() async {
    eventData = [];
    if (this.events != null) {
      for (var i = 0; i < this.events.length; i++) {
        print("loop" + i.toString());
        try {
          final eventIteration = await get(
            Uri.parse('$serverUrl/api/events/getEvent/${this.events[i]}'),
            headers: await getHeaders(),
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
                comments: List<String>.from((eventDataResponse['comments'] ?? []).map((comment) => comment.toString())),
                id: this.events[i],
                likedBy: List<String>.from((eventDataResponse['likedBy'] ?? []).map((likedBy) => likedBy.toString())),
                disLikedBy: List<String>.from((eventDataResponse['disLikedBy'] ?? []).map((disLikedBy) => disLikedBy.toString())),
                tags: List<String>.from((eventDataResponse['tags'] ?? []).map((tag) => tag.toString())),

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
    followers.forEach((uid, dataArr) async {
      try {
        final response = await get(
          Uri.parse('$serverUrl/api/users/getUser/$uid'),
          headers: await getHeaders(),
        );
        if (response.statusCode == 200) {
          // If the server returns a 200 OK response, parse the response body
          var userData = json.decode(response.body)['message'];
          if (dataArr[0] == "Accepted") {
            followerData.add([
              UserData(
                uid: uid,
                displayName: userData['displayName'],
                email: userData['email'],
                following: userData['following'],
                role: userData['role'],
                myEvents: List<String>.from((userData['myEvents'] ?? []).map((event) => event.toString())),
                clubIds: List<String>.from((userData['clubIds'] ?? []).map((club) => club.toString())),
                downloadURL: userData['downloadURL'],
                classOf: userData['classOf'],
                likedEvents: List<String>.from((userData['likedEvents'] ?? []).map((event) => event.toString())),
                dislikedEvents: List<String>.from((userData['dislikedEvents'] ?? []).map((event) => event.toString())),
                friendGroups: List<String>.from((userData['friendGroups'] ?? []).map((friend) => friend.toString())),
                interestedTags: List<String>.from((userData['tags'] ?? []).map((tag) => tag.toString())),


              ),
              dataArr[1],
            ]);
          }

          else if(dataArr[0] == "Denied"){
            followerDeclinedData.add([
              UserData(
                uid: uid,
                displayName: userData['displayName'],
                email: userData['email'],
                following: userData['following'],
                role: userData['role'],
                myEvents: List<String>.from((userData['myEvents'] ?? []).map((event) => event.toString())),
                clubIds: List<String>.from((userData['clubIds'] ?? []).map((club) => club.toString())),
                downloadURL: userData['downloadURL'],
                classOf: userData['classOf'],
                likedEvents: List<String>.from((userData['likedEvents'] ?? []).map((event) => event.toString())),
                dislikedEvents: List<String>.from((userData['dislikedEvents'] ?? []).map((event) => event.toString())),
                friendGroups: List<String>.from((userData['friendGroups'] ?? []).map((friend) => friend.toString())),
                interestedTags: List<String>.from((userData['interestedTags'] ?? []).map((tag) => tag.toString())),


              ),
              dataArr[1],
            ]);
          }
          else if(dataArr[0] == "Requested"){
            print("IN REQUESTEDDDD");
            followerActionRequired.add([
              UserData(
                uid: uid,
                displayName: userData['displayName'],
                email: userData['email'],
                following: userData['following'],
                role: userData['role'],
                myEvents: List<String>.from((userData['myEvents'] ?? []).map((event) => event.toString())),
                clubIds: List<String>.from((userData['clubIds'] ?? []).map((club) => club.toString())),
                downloadURL: userData['downloadURL'],
                classOf: userData['classOf'],
                likedEvents: List<String>.from((userData['likedEvents'] ?? []).map((event) => event.toString())),
                dislikedEvents: List<String>.from((userData['dislikedEvents'] ?? []).map((event) => event.toString())),
                friendGroups: List<String>.from((userData['friendGroups'] ?? []).map((friend) => friend.toString())),
                interestedTags: List<String>.from((userData['interestedTags'] ?? []).map((tag) => tag.toString())),

              ),
              dataArr[1],
            ]);
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

  Future<void> acceptUser(String uid) async {
    try {
      final response = await post(
        Uri.parse('$serverUrl/api/clubs/acceptUser'),
        headers: await getHeaders(),
        body: jsonEncode(<String, String>{
          "clubId": id,
          "uid": uid,
        }),
      );

      if (response.statusCode == 200) {
        followers[uid] = "Accepted";
        // Request was successful, you might want to handle the response here
      } else {
        // Request failed, handle the error or throw an exception
        throw Exception('Failed to accept user: ${response.statusCode}');
      }
    } catch (error) {
      // Handle exceptions thrown during the asynchronous operation
      print('Error in acceptUser: $error');
      throw Exception('Failed to accept user: $error');
    }
  }

  Future<void> denyUser(String uid) async {
    try {
      final response = await post(
        Uri.parse('$serverUrl/api/clubs/denyUser'),
        headers: await getHeaders(),
        body: jsonEncode(<String, String>{
          "clubId": id,
          "uid": uid,
        }),
      );

      if (response.statusCode == 200) {
        followers[uid] = "Denied";
        // Request was successful, you might want to handle the response here
      } else {
        // Request failed, handle the error or throw an exception
        throw Exception('Failed to deny user: ${response.statusCode}');
      }
    } catch (error) {
      // Handle exceptions thrown during the asynchronous operation
      print('Error in denyUser: $error');
      throw Exception('Failed to deny user: $error');
    }
  }

}
