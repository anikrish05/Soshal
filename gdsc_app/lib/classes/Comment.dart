import 'package:gdsc_app/classes/userData.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import '../app_config.dart';
import '../utils.dart';

final serverUrl = AppConfig.serverUrl;

class Comment {
  final String comment;
  final List<String> likedBy;
  final UserData user;
  final String eventID;
  bool isLiked;
  String commentID;// Updated to use UserData class

  Comment({
    required this.user,
    required this.comment,
    required this.likedBy,
    required this.eventID,
    required this.isLiked,
    required this.commentID
  });

  Future<String> add() async{
    final response = await post(
      Uri.parse('$serverUrl/api/comments/addComment'),
      headers: await getHeaders(),
      body: jsonEncode(<String, dynamic>{
        "commentData": json.encode({
          "comment": comment,
          "user": user.uid
        }),
        "eventID": eventID
      }),
    );
    return(jsonDecode(response.body)['message']);
  }

  Future<void> like() async{
    isLiked = true;

    await post(
      Uri.parse('$serverUrl/api/comments/likeComment'),
      headers: await getHeaders(),
      body: jsonEncode(<String, dynamic>{
        "uid": user.uid,
        "commentID": commentID
      }),
    );


  }
  Future<void> disLike() async{
    isLiked = false;
    await post(
      Uri.parse('$serverUrl/api/comments/disLikeComment'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "uid": user.uid,
        "commentID": commentID
      }),
    );
  }
}
