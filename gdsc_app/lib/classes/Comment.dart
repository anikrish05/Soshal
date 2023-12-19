import 'package:gdsc_app/classes/userData.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
const hostName = "10.0.2.2:3000";

class Comment {
  final String comment;
  final List<String> likedBy;
  final UserData user;
  final String eventID;// Updated to use UserData class

  Comment({
    required this.user,
    required this.comment,
    required this.likedBy,
    required this.eventID
  });

  Future<void> add() async{
    print("hello");
    final response = await post(
      Uri.parse('http://$hostName/api/comments/addComment'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "commentData": json.encode({
          "comment": comment,
          "user": user.uid
        }),
        "eventID": eventID
      }),
    );
  }
}
