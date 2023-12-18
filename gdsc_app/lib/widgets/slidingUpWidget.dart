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

  late Future<void> commentsFuture = Future.value();

  Future<void> getComments() async {
    print("IN GET COMMENTS");
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:3000/api/comments/getCommentDataForEvent'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          "comments": widget.markerData.comments ?? [], // Ensure comments is not null
        }),
      );

      if (response.statusCode == 200) {
        print("reponse code");
        print(jsonDecode(response.body)['message']);
        // Parse the response and update the comments list
        List<dynamic>? responseData = jsonDecode(response.body)['message'];
        if (responseData != null) {
          List<Comment> newComments = responseData.map((data) {
            print(data['comment']);
            return Comment(
              comment: data['comment'],
              likedBy: List<String>.from(data['likedBy']),
              user: UserData(
                uid: data['userData']['uid'],
                displayName: data['userData']['displayName'],
                email: data['userData']['email'],
                following: List<String>.from(data['userData']['following']),
                role: data['userData']['role'],
                myEvents: List<String>.from(data['userData']['myEvents']),
                clubIds: List<String>.from(data['userData']['clubsOwned']),
              ),
            );
          }).toList();
          print("in comment");
          print(newComments);
          setState(() {
            comments = newComments;
          });
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

  @override
  void initState() {
    super.initState();
    // Call the asynchronous method to fetch comments
    commentsFuture = getComments();
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
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Text("By: Adithya "),
                            SizedBox(width: 8),
                            Row(
                              children: List.generate(
                                5,
                                    (index) => Padding(
                                  padding: EdgeInsets.only(right: 4),
                                  child: Icon(Icons.star, color: Colors.grey, size: 16),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.location_on),
                            Padding(padding: EdgeInsets.only(right: 4)),
                            Text(widget.markerData.location),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.access_time),
                            Padding(padding: EdgeInsets.only(right: 4)),
                            Text(widget.markerData.time),
                          ],
                        ),
                        SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            margin: EdgeInsets.only(bottom: 2, right: 40),
                            child: ElevatedButton(
                              onPressed: () {
                                // Add RSVP button logic
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Colors.grey,
                                textStyle: TextStyle(
                                  fontFamily: 'Borel',
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: Text('rsvp'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              color: Colors.grey,
              thickness: 1,
              indent: 50,
              endIndent: 50,
            ),
            // Text field for adding comments
            Padding(
              padding: const EdgeInsets.only(right: 40, left: 40),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  height: 40,
                  child: TextField(
                    controller: commentController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'add comments',
                      filled: true,
                      fillColor: Colors.grey,
                      hintStyle: TextStyle(
                        fontFamily: 'Borel',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 1, horizontal: 10),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      border: InputBorder.none,
                      suffixIcon: IconButton(
                        onPressed: () {
                          //addComment(); // Function to add the comment
                        },
                        icon: Icon(Icons.send, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            // Comment section with scrollbar
            FutureBuilder<void>(
              future: commentsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return Expanded(
                    child: Scrollbar(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        reverse: true,
                        child: ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: comments.length,
                          itemBuilder: (context, index) {
                            if (comments.isEmpty) {
                              return Container();
                            } else {
                              return CommentCard(comment: comments[index]);
                            }
                          },
                        ),
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
