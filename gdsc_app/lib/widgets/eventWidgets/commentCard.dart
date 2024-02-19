import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gdsc_app/classes/Comment.dart';
import '../../app_config.dart';
import 'package:http/http.dart' as http;

import '../../utils.dart';

final serverUrl = AppConfig.serverUrl;

class CommentCard extends StatefulWidget {
  final Comment comment;
  final String currUserID;
  CommentCard({required this.comment, required this.currUserID});

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  bool isLiked = false;
  Color _orangeColor = Color(0xFFFF8050);
  int amountOfLikes = 0;
  String likesDisplayed = "";
  String timestamp = "";

  Widget _buildProfileImage() {
    Widget profileImage;

    if (widget.comment.user.downloadURL.isEmpty) {
      profileImage = Image.asset(
        'assets/emptyprofileimage-PhotoRoom.png-PhotoRoom.png',
        width: 40,
        height: 40,
        fit: BoxFit.cover,
      );
    } else {
      profileImage = Image.network(
        widget.comment.user.downloadURL,
        width: 40,
        height: 40,
        fit: BoxFit.cover,
      );
    }

    return ClipOval(
      child: profileImage,
    );
  }


  @override
  void initState() {
    int timestampInMilliseconds = widget.comment.timestamp;
    DateTime nodeDateTime = DateTime.fromMillisecondsSinceEpoch(timestampInMilliseconds);
    DateTime currentDateTime = DateTime.now();
    Duration difference = currentDateTime.difference(nodeDateTime);
    int likeAmount = widget.comment.likedBy.length;
    String tempString = "";
    if (difference.inDays > 0) {
      setState(() {
        tempString = "${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago";
      });
    } else if (difference.inHours > 0) {
      setState(() {
        tempString = "${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago";
      });
    } else {
      setState(() {
        tempString = "${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago";
      });
    }
    setState(() {
      isLiked = widget.comment.isLiked;
      timestamp = tempString;
      amountOfLikes = likeAmount;

      if (amountOfLikes != 0)
        {
          likesDisplayed = amountOfLikes.toString();

        }
      else
        {
          likesDisplayed = "";
        }
    });
  }

  void toggleLike() async{
    bool temp = !isLiked;
    setState(() {
      isLiked = temp;

      if (isLiked)
        {
          amountOfLikes++;
        }
      else
        {
          amountOfLikes--;
        }


      if (amountOfLikes != 0)
      {
        likesDisplayed = amountOfLikes.toString();

      }
      else
      {
        likesDisplayed = "";
      }
    });
    if(temp){
      print("Liked!");
      widget.comment.like();
      await http.post(Uri.parse('$serverUrl/api/comments/likeComment'),
      headers: await getHeaders(),
      body: jsonEncode(<String, dynamic>{
        "uid": widget.currUserID,
        "commentID": widget.comment.commentID
      }));
    }
    else{
      print("DisLiked");
      widget.comment.disLike();
      await http.post(Uri.parse('$serverUrl/api/comments/disLikeComment'),
          headers: await getHeaders(),
          body: jsonEncode(<String, dynamic>{
            "uid": widget.currUserID,
            "commentID": widget.comment.commentID
          }));
      setState(() {
        amountOfLikes = widget.comment.likedBy.length;
        if (amountOfLikes != 0)
        {
          likesDisplayed = amountOfLikes.toString();

        }
        else
        {
          likesDisplayed = "";
        }
      });
    }


  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProfileImage(),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${widget.comment.user.displayName}',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: toggleLike,
                          child: Icon(
                            isLiked ? Icons.favorite : Icons.favorite_border,
                            color: isLiked ? _orangeColor : Colors.grey,
                          ),
                        ),
                        SizedBox(width: 4),
                        Text(
                          likesDisplayed, // Change this to the actual like count
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Text(
                  widget.comment.comment,
                  style: TextStyle(color: Colors.black87, fontSize: 16),
                ),
                SizedBox(height: 8),
                Text(
                  "$timestamp",
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}
