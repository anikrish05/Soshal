import 'dart:ffi';
import 'dart:convert';
import 'dart:io' as i;
import 'package:flutter/material.dart';
import 'package:gdsc_app/screens/createEventMap.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:gdsc_app/classes/ClubCardData.dart';
import 'package:toggle_switch/toggle_switch.dart';
import '../app_config.dart';
import '../utils.dart';
import '../widgets/loader.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'package:gdsc_app/classes/EventCardData.dart';

final serverUrl = AppConfig.serverUrl;

class UpdateEventScreen extends StatefulWidget {
  final EventCardData event;
  UpdateEventScreen({required this.event});
  @override
  _CreateUserScreenState createState() => _CreateUserScreenState();
}
// widget.user
class _CreateUserScreenState extends State<UpdateEventScreen> {
  final newName = TextEditingController();
  final newDesc = TextEditingController();
  final clubCate = TextEditingController();

  String dateTimeString = 'Choose New Date and Time';
  final format = DateFormat("yyyy-MM-dd HH:mm");
  late DateTime selectedDateTime;

  List<int> newImageBytes = [];
  bool chooseImage = false;
  XFile? _image;

  bool chooseTime = false;

  double latitude = 0.0;
  double longitude = 0.0;

  int indexRepeatable = 1;
  Color _orangeColor = Color(0xFFFF8050);
  final ButtonStyle style =
  ElevatedButton.styleFrom(
      backgroundColor: Colors.orange,
      shape: StadiumBorder(),
      textStyle: const TextStyle(
          fontFamily: 'Borel', fontSize: 30, color: Colors.grey));

  @override
  void onGetLocation() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CreateEventMapScreen()),
    );
    latitude = result.latitude;
    longitude = result.longitude;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(leading: BackButton(
            onPressed: () => Navigator.of(context).pop(),
            color: Colors.orange),
            centerTitle: true,
            title: Text("Update Event Details",
              style: TextStyle(
                color: Color(0xFF88898C),
              ),),
            backgroundColor: Colors.white
        ),
        body:
        Padding(
            padding: EdgeInsets.all(16.6),
            child: ListView(
              children: [
                Container(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              GestureDetector(
                                child: _image == null
                                    ? profilePicture()
                                    : CircleAvatar(
                                  radius: 60,
                                  backgroundImage: FileImage(i.File(_image!.path)),
                                ),
                              ),
                                Positioned(
                                right: 0,
                                bottom: 0,
                                child: GestureDetector(
                                  onTap: () {
                                    _pickImage();
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
                              )
                            ],
                          ),
                          RichText(
                            text: TextSpan(
                              text: 'Change Event Name',
                              style: TextStyle(fontWeight: FontWeight.bold,
                                  color: Colors.black.withOpacity(0.6),
                                  fontFamily: 'Borel',
                                  fontSize: 15),
                            ),
                          ),
                          TextField(
                            controller: newName,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0)),
                              hintText: widget.event.name,
                              contentPadding: EdgeInsets.fromLTRB(
                                  20.0, 10.0, 20.0, 10.0),
                            ),
                          ),
                          Divider(),
                          RichText(
                            text: TextSpan(
                              text: 'Change Event Description',
                              style: TextStyle(fontWeight: FontWeight.bold,
                                  color: Colors.black.withOpacity(0.6),
                                  fontFamily: 'Borel',
                                  fontSize: 15),
                            ),
                          ),
                          TextField(
                            controller: newDesc,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0)),
                              hintText: widget.event.description,
                              contentPadding: EdgeInsets.fromLTRB(
                                  20.0, 10.0, 20.0, 10.0),
                            ),
                          ),
                          Divider(),
                          Row(
                              children:[
                                RichText(
                                  text: TextSpan(
                                    text: 'Repeat Event?',
                                    style: TextStyle(fontWeight: FontWeight.bold,
                                        color: Colors.black.withOpacity(0.6),
                                        fontFamily: 'Borel',
                                        fontSize: 15),
                                  ),
                                ),
                                VerticalDivider(),
                                ToggleSwitch(
                                  minWidth: 77.5,
                                  cornerRadius: 20.0,
                                  activeBgColors: [
                                    [_orangeColor],
                                    [_orangeColor]
                                  ],
                                  activeFgColor: Colors.white,
                                  inactiveBgColor: Colors.grey,
                                  inactiveFgColor: Colors.white,
                                  initialLabelIndex: 0,
                                  totalSwitches: 2,
                                  labels: ['No', 'Yes'],
                                  radiusStyle: true,
                                  onToggle: (index) {
                                    if (index == 1) {
                                      indexRepeatable = 0;
                                    } else if (index == 0) {
                                      indexRepeatable = 1;
                                    }
                                  },
                                ),
                              ]
                          ),
                          Divider(height: 15,),
                          Center(
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                MaterialStateProperty.all<Color>(_orangeColor),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                    side: BorderSide.none,
                                  ),
                                ),
                              ),
                              onPressed: () {
                                onGetLocation();
                              },
                              child: const Text('Choose New Location'),
                            )
                          ),
                          Divider(height: 15,),
                          Container(
                            height: 50,
                            width: 280.0,
                            child: DateTimeField(
                              validator: (value) {
                                if (dateTimeString.compareTo('Choose Date and Time') == 0) {
                                  return 'Please enter a date-time.';
                                } else if (selectedDateTime.compareTo(DateTime.now()) < 0){
                                  return "Please enter a future date-time.";
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                icon: Icon(Icons.calendar_month_outlined),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20.0)),
                                hintText: dateTimeString,
                                contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                              ),
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
                                      dateTimeString = selectedDateTime.toString();
                                    });
                                    chooseTime = true;
                                    return selectedDateTime;
                                  }
                                }
                              },
                            ),
                          ),
                          Divider(),
                          Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                SizedBox(
                                  height: 50,
                                  width: 200,
                                  child:
                                  ElevatedButton(
                                    style: style,
                                    onPressed: () {
                                      submitEdit();
                                    },
                                    child: const Text('Update'),
                                  ),
                                )
                              ],
                            ),
                          )
                        ]
                    )
                )
              ],
            )
        )
    );
  }

  Widget profilePicture(){
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

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery);

    if (pickedFile != null) {
      // Read the image file as bytes
      chooseImage = true;
      newImageBytes = await pickedFile.readAsBytes();

      setState(() {
        _image = pickedFile;
      });
      // Send the bytes to the server

    }

    print("Succesfully chose picture");
  }

  void sendImageToServer(List<int> imageBytes) async {
    try {
      final response = await http.post(
        Uri.parse('$serverUrl/api/events/updateEventImage'),
        headers: await getHeaders(),
        body: jsonEncode(<String, dynamic>{
          "image": imageBytes,
          "id": widget.event.id
        }),
      );


      if (response.statusCode == 200) {
        print('Image uploaded successfully');

      } else {
        print('Failed to upload image. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error uploading image: $error');
    }

  }

  void submitEdit() async
  {

    bool repeatable = false;
    if (indexRepeatable == 0) {
      repeatable = true;
    }
    else {
      repeatable = false;
    }

    String newEventName = "";
    String newEventDesc = "";
    if (newName.text == "")
    {
      newEventName = widget.event.name;
    }
    else
    {
      newEventName = newName.text;
    }

    if (newDesc.text == "")
    {
      newEventDesc = widget.event.description;
    }
    else
    {
      newEventDesc = newDesc.text;
    }

    double newLatitude;
    double newLongitude;

    if (latitude == 0.0)
      {
        newLatitude = widget.event.latitude;
      }
    else
      {
        newLatitude = latitude;
      }

    if (longitude == 0.0)
    {
      newLongitude = widget.event.longitude;
    }
    else
    {
      newLongitude = longitude;
    }

    String timeStamp = "";



    if (chooseTime)
      {
        timeStamp = format.format(DateTime.now());
      }
    else
      {
        timeStamp = widget.event.time;
      }



    Navigator.pop(context, [newEventName, newEventDesc, newLatitude, newLongitude,
    repeatable,timeStamp,widget.event.id,newImageBytes]);


  }

}