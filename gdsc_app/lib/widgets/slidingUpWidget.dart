import 'package:flutter/material.dart';
import 'package:gdsc_app/classes/MarkerData.dart';
import 'package:gdsc_app/classes/Comment.dart';
import 'package:gdsc_app/classes/userData.dart';

import 'package:gdsc_app/widgets/eventWidgets/commentCard.dart';

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SlidingUpWidget extends StatefulWidget {
  final MarkerData markerData;
  final VoidCallback onClose; // Callback to be called when the panel is closed

  SlidingUpWidget({required this.markerData, required this.onClose});

  @override
  _SlidingUpWidgetState createState() => _SlidingUpWidgetState();
}

class _SlidingUpWidgetState extends State<SlidingUpWidget> {
  // List to store comments
  List<Comment> comments = [];

  // Controller for the comment text field
  TextEditingController commentController = TextEditingController();

  Future<void> getComments() async {
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:3000/api/comments/getCommentDataForEvent'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          "comments": widget.markerData.comments,
        }),
      );

      if (response.statusCode == 200) {
        // Parse the response and update the comments list
        List<dynamic> responseData = jsonDecode(response.body);
        List<Comment> newComments = responseData.map((data) {
          UserData tempUser = UserData(uid: data['userData']['uid'],
              displayName: data['userData']['displayName'],
              email: data['userData']['email'],
              following: data['userData']['following'],
              role: data['userData']['role'],
              myEvents: data['userData']['myEvents'],
              clubIds: data['userData']['clubIds']
          );
          return Comment(comment: data['comment'], likedBy: data['likedBy'], user: tempUser);
        }).toList();

        setState(() {
          comments = newComments;
        });
      } else {
        print('Failed to fetch comments: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching comments: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    // Call the asynchronous method to fetch comments
    getComments();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        width: MediaQuery.of(context).size.width * 1.0,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 12),
              child: Container(
                height: 4,
                width: 100,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 12),
                    width: 125,
                    height: 125,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        widget.markerData.image,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Text(
                              widget.markerData.title,
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            Text(
                              widget.markerData.description,
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
                            ),
                          ],
                        ),
                        // ... (rest of your UI code)

                        // Comment section with scrollbar
                        Expanded(
                          child: Scrollbar(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              reverse: true,
                              child: ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: comments.length,
                                itemBuilder: (context, index) {
                                  return CommentCard(comment: comments[index]);
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /*
  void addComment() {
    String text = commentController.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        comments.add(Comment(username: 'User', text: text));
        commentController.clear();
      });
    }
  }
   */
}
