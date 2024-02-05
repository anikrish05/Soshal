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
import '../app_config.dart';
import '../utils.dart';

final serverUrl = AppConfig.serverUrl;
typedef ResetStateCallback = void Function();

class SlidingUpWidget extends StatefulWidget {
  final MarkerData markerData;
  final VoidCallback onClose;
  final User currUser; // Callback to be called when the panel is closed
  final ResetStateCallback resetStateCallback;



  SlidingUpWidget(
      {required this.markerData, required this.onClose, required this.currUser, required this.resetStateCallback,
      });

  @override
  _SlidingUpWidgetState createState() => _SlidingUpWidgetState();
}

class _SlidingUpWidgetState extends State<SlidingUpWidget> {
  // List to store comments
  List<Comment> comments = [];
  bool isRSVP = false;
  final format = DateFormat("yyyy-MM-dd HH:mm");
  bool thumbsUpSelected = false;
  bool thumbsDownSelected = false;
  Color _orangeColor = Color(0xFFFF8050);
  Color _greyColor = Color(0xFFD3D3D3);

  String locationText = "Loading...";
  // Controller for the comment text field
  TextEditingController commentController = TextEditingController();

  late Future<void> commentsFuture;

  Future<void> getComments() async {
    try {
      final response = await http.post(
        Uri.parse(
            '$serverUrl/api/comments/getCommentDataForEvent'),
        headers: await getHeaders(),
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
            print("jhdfjekdfkjewqhd");
            print(data['timestamp']);
            return Comment(
              commentID: data['commentID'],
              isLiked: data['likedBy'].contains(widget.currUser.uid),
              comment: data['comment'],
              eventID: widget.markerData.eventID,
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
    print("IN INIT STATE");
    print(widget.markerData.isRSVP);
    isRSVP = widget.markerData.isRSVP;
    comments = [];
    commentsFuture = getComments();
    getStreetName();

    // Reset the state callback
  }

  @override
  void didUpdateWidget(covariant SlidingUpWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.markerData.eventID != oldWidget.markerData.eventID) {
      // Marker data has changed, update the state
      isRSVP = widget.markerData.isRSVP;
      comments = [];
      commentsFuture = getComments();
      getStreetName();
    }
  }
  @override
  void dispose() {
    commentController.dispose();
    // Clear any other resources or state variables
    super.dispose();
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
                        /*
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
                        */
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
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      // Toggle thumbs up state
                                      setState(() {
                                        thumbsUpSelected = !thumbsUpSelected;

                                        // If thumbs up is selected, make thumbs down unselected
                                        if (thumbsUpSelected) {
                                          thumbsDownSelected = false;
                                        }
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: thumbsUpSelected ? _orangeColor : _greyColor,
                                      ),
                                      padding: EdgeInsets.all(8), // Adjust padding as needed
                                      child: Icon(
                                        Icons.thumb_up,
                                        color: thumbsUpSelected ? Colors.white : Colors.white,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10), // Adjust spacing as needed
                                  GestureDetector(
                                    onTap: () {
                                      // Toggle thumbs down state
                                      setState(() {
                                        thumbsDownSelected = !thumbsDownSelected;

                                        // If thumbs down is selected, make thumbs up unselected
                                        if (thumbsDownSelected) {
                                          thumbsUpSelected = false;
                                        }
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: thumbsDownSelected ? _orangeColor : _greyColor,
                                      ),
                                      padding: EdgeInsets.all(8), // Adjust padding as needed
                                      child: Icon(
                                        Icons.thumb_down,
                                        color: thumbsDownSelected ? Colors.white : Colors.white,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10), // Adjust spacing as needed
                                  ElevatedButton(
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
                                      primary: isRSVP ? Colors.white : _orangeColor, // Set primary color based on isRSVP
                                      side: BorderSide(color: isRSVP ? _orangeColor : Colors.transparent, width: 2), // Add orange outline if isRSVP is true
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                    child: textRSVP(),
                                  ),
                                ],
                              )
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
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
                        fontSize: 14,
                        color: Colors.white.withOpacity(.9),
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
        timestamp: DateTime.now().millisecondsSinceEpoch,
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
          likedEvents: widget.currUser.likedEvents,
          dislikedEvents: widget.currUser.dislikedEvents,
          friendGroups: widget.currUser.friendGroups,
            interestedTags: widget.currUser.friendGroups
        ),
      );

      try {
        // Add the comment to Firestore
        String commentID = await newComment.add();

        // Update the commentID and add to the UI
        setState(() {
          widget.markerData.comments.add(commentID);
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
      return RichText(
        text: TextSpan(
          style: DefaultTextStyle.of(context).style,
          children: <TextSpan>[
            TextSpan(text: "rsvp'd", style: TextStyle(fontFamily: 'Borel', color: _orangeColor, fontWeight: FontWeight.bold)),
          ],
        ),
      );
    }
    else {
      return RichText(
        text: TextSpan(
          style: DefaultTextStyle.of(context).style,
          children: <TextSpan>[
            TextSpan(
                text: 'rsvp',
                style: TextStyle(fontFamily: 'Borel', color: Colors.white, fontWeight: FontWeight.bold))
          ],
        ),
      );    }
  }
}

