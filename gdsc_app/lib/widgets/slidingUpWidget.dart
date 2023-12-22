import 'package:flutter/material.dart';
import 'package:gdsc_app/classes/MarkerData.dart';
import 'package:gdsc_app/classes/Comment.dart';
import 'package:gdsc_app/classes/userData.dart';
import 'package:gdsc_app/classes/user.dart';
import 'package:geocoding/geocoding.dart';
import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';

import 'package:gdsc_app/widgets/eventWidgets/commentCard.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SlidingUpWidget extends StatefulWidget {
  final MarkerData markerData;
  final VoidCallback onClose;
  final User currUser; // Callback to be called when the panel is closed

  SlidingUpWidget(
      {required this.markerData, required this.onClose, required this.currUser});

  @override
  _SlidingUpWidgetState createState() => _SlidingUpWidgetState();
}

class _SlidingUpWidgetState extends State<SlidingUpWidget> {
  // List to store comments
  List<Comment> comments = [];
  bool isRSVP = false;
  final format = DateFormat("yyyy-MM-dd HH:mm");

  String locationText = "Loading...";
  // Controller for the comment text field
  TextEditingController commentController = TextEditingController();

  late Future<void> commentsFuture;

  Future<void> getComments() async {
    try {
      final response = await http.post(
        Uri.parse(
            'http://10.0.2.2:3000/api/comments/getCommentDataForEvent'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          "comments": widget.markerData.comments ?? [], // Ensure comments is not null
        }),
      );

      if (response.statusCode == 200) {
        print("response code");
        print(jsonDecode(response.body)['message']);
        // Parse the response and update the comments list
        List<dynamic>? responseData =
        jsonDecode(response.body)['message'];
        if (responseData != null) {
          List<Comment> newComments = responseData.map((data) {
            return Comment(
              commentID: data['commentID'],
              isLiked: data['likedBy'].contains(widget.currUser.uid),
              comment: data['comment'],
              eventID: widget.markerData.eventID,
              likedBy: List<String>.from(data['likedBy']),
              user: UserData(
                classOf: data['userData']['classOf'],
                uid: data['userData']['uid'],
                displayName: data['userData']['displayName'],
                email: data['userData']['email'],
                following:
                List<String>.from(data['userData']['following']),
                role: data['userData']['role'],
                downloadURL: data['userData']['downloadURL'],
                myEvents:
                List<String>.from(data['userData']['myEvents']),
                clubIds:
                List<String>.from(data['userData']['clubsOwned']),
              ),
            );
          }).toList();
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
    // Assign the future directly without calling getComments
    commentsFuture = getComments();
    setState(() {
      isRSVP = widget.markerData.isRSVP;
    });
    getStreetName();
  }

  Future<void> getStreetName() async {
    print("in get street name");
    List<Placemark> placemarks = await placemarkFromCoordinates(
        widget.markerData.latitude, widget.markerData.longitude);
    Placemark place = placemarks[0];
    String tempText = "${place.street}";
    setState(() {
      locationText = tempText;
    });
  }

  String getFormattedDateTime(String dateTimeString) {
    DateTime dateTime = format.parse(dateTimeString);
    String formattedDateTime =
    DateFormat.MMMd().add_jm().format(dateTime); // e.g., Feb 2, 7:30 PM
    return formattedDateTime;
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
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            Text(
                              widget.markerData.description,
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.normal),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Row(
                              children: List.generate(
                                5,
                                    (index) => Padding(
                                  padding: EdgeInsets.only(right: 4),
                                  child: Icon(Icons.star,
                                      color: Colors.grey, size: 16),
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
                            Text(locationText),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.access_time),
                            Padding(padding: EdgeInsets.only(right: 4)),
                            Text(getFormattedDateTime(widget.markerData.time)),
                          ],
                        ),
                        SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            margin: EdgeInsets.only(bottom: 2, right: 40),
                            child: ElevatedButton(
                              onPressed: () {
                                bool temp = !isRSVP;
                                setState(() {
                                  isRSVP = temp;
                                });
                                if (temp) {
                                  print(temp);
                                  widget.markerData.rsvp();
                                } else {
                                  print(temp);
                                  widget.markerData.unRsvp();
                                }
                                // Add RSVP button logic
                              },
                              style: ElevatedButton.styleFrom(
                                primary: isRSVP
                                    ? Color(0xFFFF8050)
                                    : Color(0xFFB2BEB5),
                                textStyle: TextStyle(
                                  fontFamily: 'Borel',
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: textRSVP(),
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
                      fillColor: Color(0xFFB2BEB5),
                      hintStyle: TextStyle(
                        fontFamily: 'Borel',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      contentPadding:
                      EdgeInsets.symmetric(vertical: -5, horizontal: 10),
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
                          addComment();
                        },
                        icon: Icon(Icons.send, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Comment section with scrollbar
            KeyedSubtree(
              key: UniqueKey(), // Use UniqueKey to force a rebuild when the key changes
              child: FutureBuilder<void>(
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
                              return CommentCard(comment: comments[index]);
                            },
                          ),
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> addComment() async {
    print(widget.currUser.uid);
    String text = commentController.text.trim();

    if (text.isNotEmpty) {
      Comment newComment = Comment(
        commentID: "temporary",
        isLiked: false,
        comment: text,
        likedBy: [],
        eventID: widget.markerData.eventID,
        user: UserData(
          classOf: widget.currUser.classOf,
          uid: widget.currUser.uid,
          displayName: widget.currUser.displayName,
          email: widget.currUser.email,
          following: widget.currUser.following,
          role: widget.currUser.role,
          downloadURL: widget.currUser.downloadURL,
          myEvents: widget.currUser.myEvents,
          clubIds: widget.currUser.clubIds,
        ),
      );

      try {
        // Add the comment to Firestore
        String commentID = await newComment.add();

        // Update the commentID and add to the UI
        setState(() {
          newComment.commentID = commentID;
          comments.add(newComment);
          commentController.clear();
        });
      } catch (error) {
        print('Error adding comment: $error');
      }
    }
  }

  Widget clubText() {
    String text = "By: ";
    for (int i = 0; i < widget.markerData.clubs.length; i++) {
      if (i == widget.markerData.clubs.length - 1) {
        text += " ${widget.markerData.clubs[i].name}";
      } else {
        text += "${widget.markerData.clubs[i].name}, ";
      }
    }
    return (Text(text));
  }

  Widget textRSVP() {
    if (isRSVP) {
      return Text("rsvp'd");
    } else {
      return Text("rsvp");
    }
  }
}
