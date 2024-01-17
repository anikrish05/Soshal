import 'package:gdsc_app/classes/ClubCardData.dart';
import 'package:gdsc_app/classes/User.dart';
import 'package:gdsc_app/classes/userData.dart';
import 'dart:convert';
import 'package:http/http.dart';
import '../app_config.dart';
import '../utils.dart';

final serverUrl = AppConfig.serverUrl;
class EventCardData {
  List<String> rsvpList;
  String name;
  String description;
  String downloadURL;
  double latitude;
  double longitude;
  List<String> comments;
  List<String> likedBy;
  List<String> disLikedBy;
  String id;
  List<String> admin;
  List<ClubCardData> clubInfo = [];
  String time;
  List<UserData> rsvpUserData = [];

  EventCardData({
    required this.rsvpList,
    required this.name,
    required this.description,
    required this.downloadURL,
    required this.latitude,
    required this.longitude,
    required this.comments,
    required this.id,
    required this.admin,
    required this.time,
    required this.likedBy,
    required this.disLikedBy
  });
  Future<void> getAllClubsForEvent() async {
    clubInfo = [];
    if (this.admin != null) {
      for (var i = 0; i < this.admin.length; i++) {
        print("loop" + i.toString());
        try {
          final clubIteration = await get(
            Uri.parse('$serverUrl/api/clubs/getClub/${this.admin[i]}'),
            headers: await getHeaders(),
          );

          if (clubIteration.statusCode == 200) {
            var clubDataResponse = jsonDecode(clubIteration.body)['message'];
            clubInfo.add(
              ClubCardData(
                  rating: clubDataResponse['avgRating'].toDouble(),
                  admin: List<String>.from((clubDataResponse['admin'] ?? []).map((event) => event.toString())),
                  category: clubDataResponse['category'],
                  description: clubDataResponse['description'],
                  downloadURL: clubDataResponse['downloadURL'],
                  events: List<String>.from((clubDataResponse['events'] ?? []).map((event) => event.toString())),
                  followers: clubDataResponse['followers'],
                  name: clubDataResponse['name'],
                  type: clubDataResponse['type'],
                  verified: clubDataResponse['verified'],
                  id: this.admin[i]
              ),
            );

            print("Club data added for ID ${this.admin[i]}");
          } else {
            print("Error fetching club data for ID ${this.admin[i]} - StatusCode: ${clubIteration.statusCode}");
          }
        } catch (error) {
          print("Error fetching club data for ID ${this.admin[i]}: $error");
        }
      }
    } else {
      print("clubIds is null");
    }
  }
  Future<void> getRSVPData() async {
    rsvpUserData = [];
    if (this.rsvpList != null) {
      for (var i = 0; i < this.rsvpList.length; i++) {
        print("loop" + i.toString());
        try {
          final userIteration = await get(
            Uri.parse('$serverUrl/api/users/getUser/${this.rsvpList[i]}'),
            headers: await getHeaders(),
          );

          if (userIteration.statusCode == 200) {
            var userDataResponse = jsonDecode(userIteration.body)['message'];
            rsvpUserData.add(
              UserData(
                  uid: userDataResponse['uid'],
                  displayName: userDataResponse['displayName'],
                  email: userDataResponse['email'],
                  following: userDataResponse['following'],
                  role: userDataResponse['role'],
                  myEvents: List<String>.from((userDataResponse['myEvents'] ?? []).map((event) => event.toString())),
                  likedEvents: List<String>.from((userDataResponse['likedEvents'] ?? []).map((event) => event.toString())),
                  dislikedEvents: List<String>.from((userDataResponse['dislikedEvents'] ?? []).map((event) => event.toString())),
                  clubIds: List<String>.from((userDataResponse['clubIds'] ?? []).map((club) => club.toString())),
                  downloadURL: userDataResponse['downloadURL'],
                  classOf: userDataResponse['classOf']),
              );

            print("User data added for uid ${this.rsvpList[i]}");
          } else {
            print("Error fetching user data for uid ${this.rsvpList[i]} - StatusCode: ${userIteration.statusCode}");
          }
        } catch (error) {
          print("Error fetching user data for uid ${this.rsvpList[i]}: $error");
        }
      }
    } else {
      print("rsvpList is null");
    }
  }
}
