import 'package:flutter/material.dart';
import 'package:gdsc_app/classes/EventCardData.dart';
import 'package:gdsc_app/classes/user.dart';
import 'package:gdsc_app/classes/userData.dart';
import 'package:gdsc_app/screens/createEventMap.dart';
import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../widgets/loader.dart';
import '../../widgets/profileWidgets/rsvpCard.dart';

class OtherEventProfilePage extends StatefulWidget {
  final EventCardData event;

  OtherEventProfilePage({required this.event});

  @override
  State<OtherEventProfilePage> createState() => _OtherEventProfilePageState();
}

class _OtherEventProfilePageState extends State<OtherEventProfilePage>
    with SingleTickerProviderStateMixin {
  late DateTime selectedDateTime;
  Color _colorTab = Color(0xFFFF8050);

  String locationText = "Loading...";
  bool isEditing = false;
  late TabController tabController;
  late TextEditingController eventNameController;
  late TextEditingController eventDescController;
  final format = DateFormat("yyyy-MM-dd HH:mm");
  bool thumbsUpSelected = false;
  bool thumbsDownSelected = false;
  bool isLoaded = false;

  double latitude = 0.0;
  double longitude = 0.0;

  @override
  void dispose() {
    tabController.dispose(); // Dispose of the tabController at the end
    super.dispose();
  }

  Future<void> loadRSVPs() async {
    await widget.event.getRSVPData();
    if (isLoaded == false) {
      setState(() {
        isLoaded = true;
      });
    }
  }
  Future<void> postRequest() async {
    print("post request");
    String timeStamp = format.format(DateTime.now());
    await http.post(
      Uri.parse('http://10.0.2.2:3000/api/events/createEvent'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "name": widget.event.name,
        "description": widget.event.description,
        "downloadURL": "",
        "latitude": latitude,
        "longitude": longitude,
        "timestamp": timeStamp,
        "repeat": repeatable,
      }),
    );
    Navigator.pop(context);
  }

  String getFormattedDateTime(String dateTimeString) {
    DateTime dateTime = format.parse(dateTimeString);
    String formattedDateTime =
    DateFormat.MMMd().add_jm().format(dateTime); // e.g., Feb 2, 7:30 PM
    return formattedDateTime;
  }



  @override
  void initState() {
    super.initState();
    print("event info.dart, initstate");
    locationText = "Loading...";
    tabController = TabController(length: 1, vsync: this);
    eventNameController = TextEditingController(text: widget.event.name);
    eventDescController = TextEditingController(text: widget.event.description);

    // Fetch location information asynchronously
    loadStreetName();
    loadRSVPs();
  }

  Future<void> loadStreetName() async {
    print("in load street name");
    List<Placemark> placemarks = await placemarkFromCoordinates(
        widget.event.latitude, widget.event.longitude);
    Placemark place = placemarks[0];
    String tempText = "${place.street}";
    setState(() {
      locationText = tempText;
    });
    // Trigger a rebuild after setting the location text
    rebuild();
  }

  // Function to trigger a rebuild
  void rebuild() {
    if (mounted) {
      setState(() {});
    }
  }

  Color _orangeColor = Color(0xFFFF8050);
  Color _greyColor = Color(0xFFD3D3D3);
  bool repeatable = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () => Navigator.of(context).pop(),
          color: _orangeColor,
        ),
        backgroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          ListView(
            children: [
              SizedBox(height: 16),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(width: 16),
                          profilePicture(),
                        ],
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${widget.event.name}',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 5),
                            Row(
                              children: [
                                Row(
                                    children: [
                                      for (int i = 0; i < 5; i++)
                                        Icon(
                                          Icons.star,
                                          color: Colors.grey,
                                          size: 16,
                                        )
                                    ]
                                ),
                                SizedBox(width: 7),
                              ],
                            ),
                            SizedBox(height: 5),
                            Text(
                              '${widget.event.description}',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            // SizedBox(height: 5),
                            //     Row(
                            //       children: [
                            //         Icon(Icons.location_on),
                            // Text(
                            //   locationText,
                            //   style: TextStyle(
                            //     fontSize: 15,
                            //     fontWeight: FontWeight.normal,
                            //   ),
                            // )
                            //       ],
                            //     ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(Icons.access_time),
                                Text(
                                  ' ${getFormattedDateTime(widget.event.time)}',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Row(
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
                                SizedBox(width: 10),
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
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  )
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: _orangeColor, // Orange box color
                    borderRadius: BorderRadius.circular(20), // Curved edges
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        'RSVP List',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white, // Set text color to white
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              buildTabContent(),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildTabContent() {
    if (isLoaded == false) {
      return LoaderWidget();
    } else {
      if (widget.event.rsvpUserData.isNotEmpty) {
        return SizedBox(
          height: MediaQuery.of(context).size.height,
          child: (
              ListView.builder(
                itemCount: widget.event.rsvpUserData.length,
                itemBuilder: (context, index) {
                  return RsvpCard(
                      user: widget.event.rsvpUserData[index]
                  );
                },
              )),
        );
      } else {
        // Display a message when there is no RSVP data
        return Center(
          child: Text('No RSVPs yet.'),
        );
      }
    }
  }






  Widget profilePicture() {
    if (widget.event.downloadURL != "") {
      return CircleAvatar(
        radius: 60,
        backgroundImage: NetworkImage(widget.event.downloadURL),
      );
    } else {
      return CircleAvatar(
        radius: 60,
        backgroundImage: NetworkImage(
            'https://cdn.shopify.com/s/files/1/0982/0722/files/6-1-2016_5-49-53_PM_1024x1024.jpg?7174960393118038727'),
      );
    }
  }







}