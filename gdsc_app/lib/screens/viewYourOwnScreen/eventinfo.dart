import 'package:flutter/material.dart';
import 'package:gdsc_app/classes/EventCardData.dart';
import 'package:gdsc_app/classes/user.dart';
import 'package:gdsc_app/classes/userData.dart';
import 'package:gdsc_app/screens/CreateScreens/createEventMap.dart';
import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../widgets/loader.dart';
import '../../widgets/profileWidgets/rsvpCard.dart';
import '../../widgets/profileWidgets/rsvpCard.dart';

class EventProfilePage extends StatefulWidget {
  final EventCardData event;

  EventProfilePage({required this.event});

  @override
  State<EventProfilePage> createState() => _EventProfilePageState();
}

class _EventProfilePageState extends State<EventProfilePage>
    with SingleTickerProviderStateMixin {
  late DateTime selectedDateTime;
  Color _colorTab = Color(0xFFFF8050);

  String locationText = "Loading...";
  bool isEditing = false;
  late TabController tabController;
  late TextEditingController eventNameController;
  late TextEditingController eventDescController;
  final format = DateFormat("yyyy-MM-dd HH:mm");

  double latitude = 0.0;
  double longitude = 0.0;

  @override
  void dispose() {
    tabController.dispose(); // Dispose of the tabController at the end
    super.dispose();
  }
  Future<void> getStreetName() async {
    print("in get street name");
    List<Placemark> placemarks =
    await placemarkFromCoordinates(widget.event.latitude, widget.event.longitude);
    Placemark place = placemarks[0];
    String tempText = "${place.street}";
    setState(() {
      locationText = tempText;
    });
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
    print(widget.event.rsvpUserData);
    tabController = TabController(length: 1, vsync: this);
    eventNameController = TextEditingController(text: widget.event.name);
    eventDescController = TextEditingController(text: widget.event.description);
    getStreetName();
    setState(() {
      locationText = "Loading...";
    });
  }
/*
  void onGetLocation() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CreateEventMapScreen()),
    );
    print("-------------");
    print(result);
    latitude = result.latitude;
    longitude = result.longitude;
    List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
    Placemark place = placemarks[0];
    String tempText = "${place.street}";
    setState(() {
      locationText = tempText;
    });
  }
*/


  Color _orangeColor = Color(0xFFFF8050);
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
                      SizedBox(height: 5),
                          Row(
                            children: [
                              Icon(Icons.location_on),
                              Text(
                                (locationText),
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

                      ],
                    ),
                    )
                  ],
                )
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'RSVP List',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
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
    return FutureBuilder<void>(
      future: widget.event.getRSVPData(),
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        print("CALLING FUNC");

        if (snapshot.connectionState == ConnectionState.waiting) {
          return LoaderWidget(); // or any loading indicator
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else {
          print("hello");
          print(widget.event.rsvpUserData);

          // Display RSVP data
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
      },
    );
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
