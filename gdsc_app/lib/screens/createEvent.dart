import 'package:flutter/material.dart';
import 'package:gdsc_app/screens/createEventMap.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:gdsc_app/classes/club.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:gdsc_app/classes/ClubCardData.dart';
import '../app_config.dart';
import '../utils.dart';

final serverUrl = AppConfig.serverUrl;

class CreateEventScreen extends StatefulWidget {
  final ClubCardData club;
  CreateEventScreen({required this.club});
  _CreateEventScreenState createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  final format = DateFormat("yyyy-MM-dd HH:mm");
  late DateTime selectedDateTime;

  GlobalKey<FormState> _oFormKey = GlobalKey<FormState>();
  late TextEditingController _controller1;
  String _valueChanged1 = '';
  String _valueToValidate1 = '';
  String _valueSaved1 = '';
  double latitude = 0.0;
  double longitude = 0.0;

  var eventName = TextEditingController();
  var eventDesc = TextEditingController();

  LatLng? _selectedLatLng;

  Color _orangeColor = Color(0xFFFF8050);
  late String currUserId;

  final ButtonStyle style = ElevatedButton.styleFrom(
    backgroundColor: Colors.orange,
    shape: StadiumBorder(),
    textStyle: const TextStyle(
      fontFamily: 'Garret',
      fontSize: 30,
      color: Colors.grey,
    ),
  );

  @override
  void onGetLocation() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CreateEventMapScreen()),
    );
    print("-------------");
    print(result);
    latitude = result.latitude;
    longitude = result.longitude;
  }

  Future<void> postRequest() async {
    print("post requ");
    String timeStamp = format.format(DateTime.now());
    await http.post(
      Uri.parse('$serverUrl/api/events/createEvent'),
      headers: await getHeaders(),
      body: jsonEncode(<String, dynamic>{
        "admin": [widget.club.id],
        "name": eventName.text,
        "description": eventDesc.text,
        "downloadURL": "",
        "latitude": latitude,
        "longitude": longitude,
        "timestamp": timeStamp,
        "repeat": repeatable,
      }),
    );
    Navigator.pop(context);
  }

  bool repeatable = false;

  int indexPubOrPriv = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () => Navigator.of(context).pop(),
          color: _orangeColor,
        ),
        centerTitle: true,
        title: Text(
          "Create an Event",
          style: TextStyle(
            color: Color(0xFF88898C),
            fontFamily: 'Garret',
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.6),
        child: ListView(
          children: [
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.asset(
                      'assets/ex1.jpeg',
                      height: 150,
                      width: 150,
                      fit: BoxFit.cover,
                    ),
                  ),
                  VerticalDivider(),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 35.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 40,
                            width: 170,
                            child: TextField(
                              style: TextStyle(
                                fontFamily: 'Garret',
                                color: Colors.black,
                                fontSize: 15,
                              ),
                              controller: eventName,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                hintText: "Event Title",
                                hintStyle: TextStyle(color: Colors.black),
                                contentPadding: EdgeInsets.fromLTRB(
                                  20.0,
                                  10.0,
                                  20.0,
                                  10.0,
                                ),
                              ),
                            ),
                          ),
                          Divider(),
                          SizedBox(
                            height: 110,
                            width: 170,
                            child: TextField(
                              style: TextStyle(
                                fontFamily: 'Garret',
                                color: Colors.black,
                                fontSize: 15,
                              ),
                              controller: eventDesc,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                hintText: "Event Description",
                                hintStyle: TextStyle(color: Colors.black),
                                contentPadding: EdgeInsets.fromLTRB(
                                  20.0,
                                  10.0,
                                  20.0,
                                  10.0,
                                ),
                              ),
                              maxLines: 3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.1),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: _orangeColor,
                      shape: StadiumBorder(),
                      textStyle: const TextStyle(
                        fontFamily: 'Garret',
                        fontSize: 15.0,
                        color: Colors.black,
                      ),
                    ),
                    onPressed: () {
                      onGetLocation();
                    },
                    child: const Text('Choose Location'),
                  ),
                  ToggleSwitch(
                    minWidth: 70.0,
                    cornerRadius: 50.0,
                    activeBgColors: [[_orangeColor], [_orangeColor]],
                    activeFgColor: Colors.white,
                    inactiveBgColor: Colors.grey,
                    inactiveFgColor: Colors.white,
                    initialLabelIndex: 0,
                    totalSwitches: 2,
                    labels: ['Public', 'Private'],
                    radiusStyle: true,
                    onToggle: (index) {
                      if (index == 1) {
                        indexPubOrPriv = 0;
                      } else if (index == 0) {
                        indexPubOrPriv = 1;
                      };
                    },
                  ),
                ],
              ),
            ),
            Divider(),
            RichText(
              text: TextSpan(
                text: 'Choose Date and Time',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black.withOpacity(0.6),
                  fontFamily: 'Garret',
                  fontSize: 15,
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
                      },
                    ),
                  ),
                ],
              ),
            ),
            Divider(),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      text: 'Repeatable',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black.withOpacity(0.6),
                        fontFamily: 'Garret',
                        fontSize: 30,
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: repeatable ? _orangeColor : Colors.grey,
                      padding: EdgeInsets.all(10),
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
                  )
                ],
              ),
            ),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(
                    height: 50,
                    width: 200,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: _orangeColor,
                        shape: StadiumBorder(),
                        textStyle: const TextStyle(
                          fontFamily: 'Garret',
                          fontSize: 30,
                          color: Colors.grey,
                        ),
                      ),
                      onPressed: () {
                        postRequest();
                      },
                      child: Text(
                        'post',
                        style: TextStyle(
                          fontFamily: 'Borel',
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
