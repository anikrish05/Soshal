import 'package:gdsc_app/classes/ClubCardData.dart';
import 'package:gdsc_app/classes/User.dart';
import 'package:gdsc_app/classes/userData.dart';
import 'dart:convert';
import 'package:http/http.dart';
const hostName = "10.0.2.2:3000";
class EventCardData {
  List<String> rsvpList;
  String name;
  String description;
  String downloadURL;
  double latitude;
  double longitude;
  double rating;
  List<String> comments;
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
    required this.rating,
    required this.comments,
    required this.id,
    required this.admin,
    required this.time
  });
  Future<void> getAllClubsForEvent() async {
    if (this.admin != null) {
      for (var i = 0; i < this.admin.length; i++) {
        print("loop" + i.toString());
        try {
          final clubIteration = await get(
            Uri.parse('http://$hostName/api/clubs/getClub/${this.admin[i]}'),
          );

          if (clubIteration.statusCode == 200) {
            var clubDataResponse = jsonDecode(clubIteration.body)['message'];
            print("HIII");
            print(clubDataResponse);
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
    if (this.rsvpList != null) {
      for (var i = 0; i < this.rsvpList.length; i++) {
        print("loop" + i.toString());
        try {
          final userIteration = await get(
            Uri.parse('http://$hostName/api/users/getUser/${this.rsvpList[i]}'),
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
                  clubIds: List<String>.from((userDataResponse['clubIds'] ?? []).map((club) => club.toString())),
                  downloadURL: userDataResponse['downloadURL'],
                  classOf: userDataResponse['classOf'])
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
