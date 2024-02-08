import 'package:gdsc_app/classes/ClubCardData.dart';
import 'package:gdsc_app/classes/User.dart';
import 'package:gdsc_app/classes/userData.dart';
import 'dart:convert';
import 'package:http/http.dart';
import '../app_config.dart';
import '../utils.dart';
import 'package:gdsc_app/classes/comment.dart';

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
  List<String> tags;
  String id;
  List<String> admin;
  List<ClubCardData> clubInfo = [];
  String time;
  List<UserData> rsvpUserData = [];
  List<Comment> commentData = [];
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
    required this.disLikedBy,
    required this.tags
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
                  description: clubDataResponse['description'],
                  downloadURL: clubDataResponse['downloadURL'],
                  events: List<String>.from((clubDataResponse['events'] ?? []).map((event) => event.toString())),
                  tags: List<String>.from((clubDataResponse['tags'] ?? []).map((tag) => tag.toString())),
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
                  friendGroups: List<String>.from((userDataResponse['friendGroups'] ?? []).map((friend) => friend.toString())),
                  interestedTags: List<String>.from((userDataResponse['interestedTags'] ?? []).map((tag) => tag.toString())),
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
    Future<void> getComments() async {
    try {
      final response = await post(
        Uri.parse(
            '$serverUrl/api/comments/getCommentDataForEvent'),
        headers: await getHeaders(),
        body: jsonEncode(<String, dynamic>{
          "comments": comments, // Ensure comments is not null
        }),
      );

      if (response.statusCode == 200) {
        print("response code");
        print(jsonDecode(response.body)['message']);
        // Parse the response and update the comments list
        List<dynamic>? responseData =
        jsonDecode(response.body)['message'];
        if (responseData != null) {
          commentData= responseData.map((data) {
            print("jhdfjekdfkjewqhd");
            print(data['timestamp']);
            return Comment(
              commentID: data['commentID'],
              isLiked: data['likedBy'].contains(""),//TODO: Replace with user's uid
              comment: data['comment'],
              eventID: id,
              likedBy: List<String>.from(data['likedBy']),
              timestamp: data['timestamp'],
              user: UserData(
                classOf: data['userData']['classOf'],
                uid: data['userData']['uid'],
                displayName: data['userData']['displayName'],
                email: data['userData']['email'],
                following:
                data['userData']['following'],
                role: data['userData']['role'],
                downloadURL: data['userData']['downloadURL'],
                myEvents:
                List<String>.from(data['userData']['myEvents']),
                clubIds:
                List<String>.from(data['userData']['clubsOwned']),
                likedEvents:
                List<String>.from(data['userData']['likedEvents']),
                dislikedEvents:
                List<String>.from(data['userData']['dislikedEvents']),
                friendGroups:
                List<String>.from(data['userData']['friendGroups']),
                interestedTags:
                List<String>.from(data['userData']['interestedTags']),
              ),
            );
          }).toList();
        } else {
          print('Response data is null');
        }
      } else {
        print('Failed to fetch comments: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching comments: $e');
    }
  }

  Future<Comment?> addComment(UserData currUser, String text) async {
    if (text.isNotEmpty) {
      Comment newComment = Comment(
        commentID: "temporary",
        isLiked: false,
        comment: text,
        likedBy: [],
        timestamp: DateTime.now().millisecondsSinceEpoch,
        eventID: id,
        user: currUser
      );

      try {
        // Add the comment to Firestore
        String commentID = await newComment.add();
        newComment.commentID = commentID;
        return newComment;
        // Update the commentID and add to the UI

      } catch (error) {
        print('Error adding comment: $error');
        return null;
      }
    }
    return null;
  }

}
