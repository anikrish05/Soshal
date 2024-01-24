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
import 'package:gdsc_app/screens/editEvent.dart';
import '../../app_config.dart';
import '../../utils.dart';
import '../../widgets/loader.dart';
import '../../widgets/profileWidgets/rsvpCard.dart';

final serverUrl = AppConfig.serverUrl;

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
        "downloadURL": widget.event.downloadURL,
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
    print(widget.event.rsvpUserData);
    tabController = TabController(length: 1, vsync: this);
    eventNameController = TextEditingController(text: widget.event.name);
    eventDescController = TextEditingController(text: widget.event.description);

    // Fetch location information asynchronously
    loadStreetName();
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
                            SizedBox(height: 12),
                            GestureDetector(
                                onTap:(){
                                  setState(() {
                                    isEditing = true;
                                  });
                                  onUpdateEvent();
                                },
                                child:Row(
                                  children: [
                                    GestureDetector(
                                        onTap: (){
                                          setState(() {
                                            isEditing = true;
                                          });
                                          onUpdateEvent();
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: _orangeColor,
                                          ),
                                          child: Icon(Icons.edit, color: Colors.white),
                                        )
                                    ),
                                    SizedBox(width: 16),
                                  ],
                                )
                            )

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
                        '➤➤➤  RSVP List  ➤➤➤',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              buildTabContent(),
            ],
          ),
          if (isEditing)
            Positioned.fill(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    isEditing = false;
                  });
                },
              ),
            ),
        ],
      ),
    );
  }

  void _showEditSheet(BuildContext context){
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return Scaffold(
              appBar: AppBar(
                leading: BackButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      setState(() {
                        isEditing = false;
                      });
                    },
                    color: _orangeColor
                ),
                backgroundColor: Colors.white,
              ),
              body: Column(
                children: [
                  Expanded(
                      child: SingleChildScrollView(
                          physics: AlwaysScrollableScrollPhysics(),
                          child: Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    profilePicture(),
                                    Positioned(
                                      right: 0,
                                      bottom: 0,
                                      child: GestureDetector(
                                        onTap: () {
                                          // Add your logic for editing the profile picture here
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: _orangeColor,
                                          ),
                                          child: Icon(Icons.edit, color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 16),
                                Column(
                                  children: [
                                    TextField(
                                      controller: eventNameController,
                                      decoration: InputDecoration(labelText: "Event Name"),
                                      maxLines: null,
                                    ),
                                    TextField(
                                      controller: eventDescController,
                                      decoration: InputDecoration(labelText: "Event Description"),
                                      maxLines: null,
                                    )
                                  ],
                                ),
                                SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    // SizedBox(
                                    //   height: 40,
                                    //   width: 160,
                                    //   child: ElevatedButton(
                                    //     style: ElevatedButton.styleFrom(
                                    //       backgroundColor: _orangeColor,
                                    //       shape: StadiumBorder(),
                                    //       textStyle: const TextStyle(fontfamily: 'Garret', fontSize: 15.0, color: Colors.black),
                                    //     ),
                                    //     onPressed: () {
                                    //       onGetLocation();
                                    //     },
                                    //     child: const Text('Choose Location'),
                                    //   ),
                                    // ),
                                    SizedBox(width: 15),
                                    Expanded(
                                      child: Center(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            RichText(
                                              text: TextSpan(
                                                text: "Repeat: ",
                                                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 16),
                                              ),
                                            ),
                                            SizedBox(width: 8),
                                            Expanded(
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(horizontal: 16.0),
                                                child: InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      repeatable = !repeatable;
                                                    });
                                                  },
                                                  child: Container(
                                                    child: ToggleButtons(
                                                      borderColor: Colors.transparent,
                                                      selectedBorderColor: Colors.transparent,
                                                      borderRadius: BorderRadius.circular(20.0),
                                                      borderWidth: 0.0,
                                                      onPressed: (int index) {},
                                                      isSelected: [!repeatable, repeatable],
                                                      children: [
                                                        ColorFiltered(
                                                          colorFilter: ColorFilter.mode(
                                                            repeatable ? _orangeColor : Colors.grey,
                                                            BlendMode.srcIn,
                                                          ),
                                                          child: Padding(
                                                            padding: const EdgeInsets.all(8.0),
                                                            child: Text('Off'),
                                                          ),
                                                        ),
                                                        ColorFiltered(
                                                          colorFilter: ColorFilter.mode(
                                                            repeatable ? Colors.grey : _orangeColor,
                                                            BlendMode.srcIn,
                                                          ),
                                                          child: Padding(
                                                            padding: const EdgeInsets.all(8.0),
                                                            child: Text('On'),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(height: 16),
                                Center(
                                  child: RichText(
                                    text: TextSpan(
                                      text: 'Choose Date and Time',
                                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontFamily: 'Garret', fontSize: 15),
                                    ),
                                  ),
                                ),
                                Container(
                                    child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                              width: 295.0,
                                              child: DateTimeField(
                                                  format: format,
                                                  onShowPicker: (context, currentValue) async {
                                                    final dateTime = await showDatePicker(
                                                      context: context,
                                                      initialDate: currentValue ?? DateTime.now(),
                                                      firstDate: DateTime(2000),
                                                      lastDate: DateTime(2101),
                                                    );
                                                    if (dateTime != null) {
                                                      final timeOfDay = await showTimePicker(
                                                        context: context,
                                                        initialTime: TimeOfDay.fromDateTime(
                                                          currentValue ?? DateTime.now(),
                                                        ),
                                                      );
                                                      if (timeOfDay != null) {
                                                        setState(() {
                                                          selectedDateTime = DateTime(
                                                            dateTime.year,
                                                            dateTime.month,
                                                            dateTime.day,
                                                            timeOfDay.hour,
                                                            timeOfDay.minute,
                                                          );
                                                        });
                                                        return selectedDateTime;
                                                      }
                                                    }
                                                    return null;
                                                  }
                                              )
                                          )
                                        ]
                                    )
                                )
                              ],
                            ),
                          )
                      )
                  ),
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            isEditing = false;
                            widget.event.name = eventNameController.text;
                            widget.event.description = eventDescController.text;
                          });
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _orangeColor,
                          textStyle: TextStyle(
                            fontFamily: "Borel",
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Text('save'),
                      )
                  )
                ],
              )
          );
        }
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
            print("HII");
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


  void onUpdateEvent() async
  {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UpdateEventScreen(event: widget.event!)),
    );

    List<int> newImageBytes = result[7];
    final eventData = {
      "name": result[0],
      "description": result[1],
      "latitude": result[2],
      "longitude": result[3],
      "timestamp": result[5],
      "repeat": result[4],
      "id": result[6]
    };

    setState(() {

      widget.event.name = result[0];
      widget.event.description = result[1];
      widget.event.latitude = result[2];
      widget.event.longitude = result[3];
      widget.event.time = result[5];
    });



    try {
      final response = await http.post(
        Uri.parse('$serverUrl/api/events/updateEvent'),
        headers: await getHeaders(),
        body: jsonEncode(eventData),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print(responseData['message']); // Assuming the server responds with a JSON object containing a 'message' property
      } else {
        print('Error: ${response.statusCode}');
        print(response.body);
      }
    } catch (error) {
      print('Error: $error');
    }


    final response = await http.post(
      Uri.parse('$serverUrl/api/events/updateEventImage'),
      headers: await getHeaders(),
      body: jsonEncode(<String, dynamic>{
        "image": result[7],
        "id": result[6]
      }),
    );

  }




}
