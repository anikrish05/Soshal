import 'package:flutter/material.dart';
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
import '../classes/EventCardData.dart';
import '../screens/viewOtherScreens/othereventinfo.dart';
import '../screens/viewYourOwnScreen/eventinfo.dart';
import '../utils.dart';

final serverUrl = AppConfig.serverUrl;
typedef ResetStateCallback = void Function();

class SlidingUpWidget extends StatefulWidget {
  final EventCardData eventData;
  final VoidCallback onClose;
  final User currUser; // Callback to be called when the panel is closed
  final ResetStateCallback resetStateCallback;



  SlidingUpWidget(
      {required this.eventData, required this.onClose, required this.currUser, required this.resetStateCallback,
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
          "comments": widget.eventData.comments, // Ensure comments is not null
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
              eventID: widget.eventData.id,
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
    isRSVP = widget.eventData.rsvpList.contains(widget.currUser.uid);
    comments = [];
    commentsFuture = getComments();
    getStreetName();
    if (widget.eventData.likedBy.contains(widget.currUser.uid))
    {
      thumbsUpSelected = true;
      thumbsDownSelected = false;
    }
    else if(widget.eventData.disLikedBy.contains(widget.currUser.uid))
    {
      thumbsDownSelected = true;
      thumbsUpSelected = false;
    }
    else
    {
      thumbsUpSelected = false;
      thumbsDownSelected = false;
    }
    // Reset the state callback
  }

  @override
  void didUpdateWidget(covariant SlidingUpWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.eventData.id != oldWidget.eventData.id) {
      // Marker data has changed, update the state
      isRSVP = widget.eventData.rsvpList.contains(widget.currUser.uid);
      comments = [];
      commentsFuture = getComments();
      getStreetName();
      if (widget.eventData.likedBy.contains(widget.currUser.uid))
      {
        thumbsUpSelected = true;
        thumbsDownSelected = false;
      }
      else if(widget.eventData.disLikedBy.contains(widget.currUser.uid))
      {
        thumbsDownSelected = true;
        thumbsUpSelected = false;
      }
      else
      {
        thumbsUpSelected = false;
        thumbsDownSelected = false;
      }
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
        widget.eventData.latitude, widget.eventData.longitude);
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

  void likeEvent() async
  {
    String userID = widget.currUser.uid;
    String eventID = widget.eventData.id;

    final response = await http.post(Uri.parse('$serverUrl/api/users/likeEvent'),
        headers: await getHeaders(),
        body: jsonEncode(<String, dynamic>{
          "uid": userID,
          "eventID": eventID
        }));

    final responseData = json.decode(response.body);

    print("Like: " + responseData["message"].toString());
  }

  void dislikeEvent() async
  {
    String userID = widget.currUser.uid;
    String eventID = widget.eventData.id;

    final response = await http.post(Uri.parse('$serverUrl/api/users/dislikeEvent'),
        headers: await getHeaders(),
        body: jsonEncode(<String, dynamic>{
          "uid": userID,
          "eventID": eventID
        }
    ));
    final responseData = json.decode(response.body);

    print("Dislike: " + responseData["message"].toString());
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
                        widget.eventData.downloadURL,
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
                              widget.eventData.name,
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            VerticalDivider(width: 5,),
                            GestureDetector(
                              onTap: () {
                                if (widget.currUser.eventData.contains(widget.eventData)) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EventProfilePage(event: widget.eventData),
                                    ),
                                  );
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => OtherEventProfilePage(event: widget.eventData),
                                    ),
                                  );
                                }
                              },
                              child: Icon(
                                Icons.info,
                                size: 17.5,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            Text(
                              widget.eventData.description,
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
                            Text(getFormattedDateTime(widget.eventData.time)),
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
                                        bool currentStatus = thumbsUpSelected;
                                        thumbsUpSelected = !thumbsUpSelected;

                                        // If thumbs up is selected, make thumbs down unselected
                                        if (thumbsUpSelected) {
                                          print("Thumbs Up");
                                          thumbsDownSelected = false;
                                          likeEvent();
                                        }
                                        else if(currentStatus)
                                        {
                                          thumbsUpSelected = true;
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
                                        bool currentStatus = thumbsDownSelected;
                                        thumbsDownSelected = !thumbsDownSelected;

                                        // If thumbs down is selected, make thumbs up unselected
                                        if (thumbsDownSelected) {
                                          print("Thumbs Down");
                                          thumbsUpSelected = false;
                                          dislikeEvent();
                                        }
                                        else if(currentStatus)
                                        {
                                          thumbsDownSelected = true;
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
                                        widget.eventData.rsvpList.add(widget.currUser.uid);
                                      } else {
                                        print(temp);
                                        widget.eventData.rsvpList.remove(widget.currUser.uid);
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
                              return CommentCard(comment: comments[index],currUserID: widget.currUser.uid,);
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
        eventID: widget.eventData.id,
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
          widget.eventData.comments.add(commentID);
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
    for (int i = 0; i < widget.eventData.clubInfo.length; i++) {
      if (i == widget.eventData.clubInfo.length - 1) {
        text += " ${widget.eventData.clubInfo[i].name}";
      } else {
        text += "${widget.eventData.clubInfo[i].name}, ";
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

