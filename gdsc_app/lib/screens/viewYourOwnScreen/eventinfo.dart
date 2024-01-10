import 'package:flutter/material.dart';
import 'package:gdsc_app/classes/EventCardData.dart';
import 'package:gdsc_app/classes/user.dart';
import 'package:gdsc_app/screens/createEventMap.dart';
import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../utils.dart';
import '../../widgets/loader.dart';

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
    List<Placemark> placemarks = await placemarkFromCoordinates(
        widget.event.latitude, widget.event.longitude);
    Placemark place = placemarks[0];
    String tempText = "${place.street}";
    setState(() {
      locationText = tempText;
    });
  }

  Future<void> postRequest() async {
    print("post requ");
    String timeStamp = format.format(DateTime.now());
    await http.post(
      Uri.parse('http://10.0.2.2:3000/api/events/createEvent'),
      headers: await getHeaders(),
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
    String formattedDateTime = DateFormat.MMMd().add_jm().format(dateTime);
    return formattedDateTime;
  }

  Future<void> getRSVPData() async {
    await widget.event.getRSVPData();
    print("HELLOOOOOOO");
    print(widget.event.rsvpUserData);
  }

  @override
  void initState() {
    super.initState();
    print("event info.dart, initstate");
    print(widget.event.rsvpUserData);
    tabController = TabController(length: 1, vsync: this);
    eventNameController =
        TextEditingController(text: widget.event.name);
    eventDescController =
        TextEditingController(text: widget.event.description);
    getStreetName();
    setState(() {
      locationText = "Loading...";
    });
  }

  void onGetLocation() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CreateEventMapScreen()),
    );
    print("-------------");
    print(result);
    latitude = result.latitude;
    longitude = result.longitude;
    List<Placemark> placemarks = await placemarkFromCoordinates(
        latitude, longitude);
    Placemark place = placemarks[0];
    String tempText = "${place.street}";
    setState(() {
      locationText = tempText;
    });
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
                                    ),
                                ],
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
                          SizedBox(height: 12),
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
                          SizedBox(height: 12),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isEditing = true;
                              });
                              _showEditSheet(context);
                            },
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      isEditing = true;
                                    });
                                    _showEditSheet(context);
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
                                SizedBox(width: 16),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Divider(
                color: Colors.grey,
                thickness: 1,
                indent: 24,
                endIndent: 24,
              ),
              SizedBox(height: 16),
              buildTabBar(),
              SizedBox(height: 16),
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

  void _showEditSheet(BuildContext context) {
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
              color: _orangeColor,
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
                              decoration: InputDecoration(labelText: 'Event Name'),
                              maxLines: null,
                            ),
                            TextField(
                              controller: eventDescController,
                              decoration: InputDecoration(labelText: 'Event Description'),
                              maxLines: null,
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              height: 40,
                              width: 160,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _orangeColor,
                                  shape: StadiumBorder(),
                                  textStyle: const TextStyle(fontFamily: 'Garret', fontSize: 15.0, color: Colors.black),
                                ),
                                onPressed: () {
                                  onGetLocation();
                                },
                                child: const Text('Choose Location'),
                              ),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16.0),
                                child: Container(
                                  child: TextButton(
                                    style: TextButton.styleFrom(
                                      backgroundColor: repeatable ? _orangeColor : Colors.grey,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                    child: Text(
                                      repeatable ? 'ON' : 'OFF',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        repeatable = !repeatable;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ),
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 295.0,
                                child: DateTimeField(
                                  format: format,
                                  onShowPicker: (context, currentValue) async {
                                    final dateTime = await showDatePicker(
                                      context: context,
                                      firstDate: DateTime(2000),
                                      initialDate: currentValue ?? DateTime.now(),
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
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
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
                      fontFamily: 'Borel',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text('save'),
                ),
              ),
            ],
          ),
        );
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

  Widget buildTabBar() {
    return TabBar(
      unselectedLabelColor: _colorTab,
      indicatorSize: TabBarIndicatorSize.tab,
      indicator: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: _colorTab,
      ),
      controller: tabController,
      tabs: [
        Tab(
          child: Text(
            'RSVP List',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ],
      indicatorPadding: EdgeInsets.symmetric(horizontal: 16),
    );
  }

  Widget buildTabContent() {
    return FutureBuilder<void>(
      future: getRSVPData(),
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return LoaderWidget();
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else {
          return SizedBox(
            height: MediaQuery.of(context).size.height,
            child: TabBarView(
              children: [
                ListView.builder(
                  itemCount: widget.event.rsvpUserData.length,
                  itemBuilder: (context, index) {
                    return Center(
                        child:
                        Text(widget.event.rsvpUserData[index].displayName));
                  },
                ),
              ],
              controller: tabController,
            ),
          );
        }
      },
    );
  }
}
