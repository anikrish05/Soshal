import 'dart:ffi';
import 'dart:io' as i;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gdsc_app/screens/createEventMap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:map_location_picker/generated/l10n.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:gdsc_app/classes/club.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:gdsc_app/classes/ClubCardData.dart';
import '../app_config.dart';
import '../utils.dart';
import '../widgets/loader.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart';

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
  final TextEditingController _controller1 = TextEditingController();
  String dateTimeString = 'Choose Date and Time';
  double latitude = 0.0;
  double longitude = 0.0;
  List<ClubCardData> clubs = [];
  Set<ClubCardData> selectedAdmins = {};

  var eventName = TextEditingController();
  var eventDesc = TextEditingController();

  List<int> newImageBytes = [];
  bool chooseImage = false;
  XFile? _image;

  Color _orangeColor = Color(0xFFFF8050);

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
    latitude = result.latitude;
    longitude = result.longitude;
  }

  Future<List> retrieveAutocomplete(String input) async {
    try {
      final places = FlutterGooglePlacesSdk("AIzaSyAWwQQQ-Wj3Tb-7huiw8CdoI9krTsNF4UA");
      final predictions = await places.findAutocompletePredictions(input);
      List<AutocompletePrediction> predictionsList = predictions.predictions;
      return predictionsList;
    } on Exception catch (e) {
      print(e);
      return ["John Lewis College", "Porter College", "Kresge College", "Cowell College", "Stevenson College", "Oakes College", "Merrill College", "Crown College"];
    }
  }

  void toggleSelectedAdmin(ClubCardData selection) {
    if (selectedAdmins.contains(selection)) {
      selectedAdmins.remove(selection);
      debugPrint("$selection removed from admin list.");
    } else {
      selectedAdmins.add(selection);
      debugPrint("$selection added as admin.");
    }
  }

  Future<void> getAdmin() async {
    clubs = [];
    final response = await http.get(
        Uri.parse('http://10.0.2.2:3000/api/clubs/getAllClubs'),
        headers: await getHeaders());
    if (response.statusCode == 200) {
      // Parse and update the user list
      final responseData = jsonDecode(response.body)['message'];

      for (int i = 0; i < responseData.length; i++) {
        try {
          ClubCardData newClub = ClubCardData(
            admin: List<String>.from((responseData[i]['admin'] ?? [])
                .map((event) => event.toString())),
            description: responseData[i]["description"] ?? "",
            downloadURL: responseData[i]["downloadURL"] ?? "",
            events: List<String>.from((responseData[i]['events'] ?? [])
                .map((event) => event.toString())),
            tags: List<String>.from((responseData[i]['tags'] ?? [])
                .map((tag) => tag.toString())),
            followers: responseData[i]["followers"] ?? {},
            name: responseData[i]["name"] ?? "",
            type: responseData[i]["type"] ?? "",
            verified: responseData[i]["verified"] ?? false,
            id: responseData[i]["id"] ?? "",
            rating: responseData[i]["rating"] ?? 0.0,
          );
          clubs.add(newClub);
        } catch (identifier) {
          print("$identifier : Failed to add club");
        }
      }
    } else {
      // Handle the error
      print('Request failed with status: ${response.statusCode}');
    }
  }

  FutureOr sendImageToServer(List<int> imageBytes, String id) async {
    try {
      final response = await http.post(
        Uri.parse('$serverUrl/api/events/updateEventImage'),
        headers: await getHeaders(),
        body: jsonEncode(<String, dynamic>{
          "image": imageBytes,
          "id": id
        }),
      );

      print(id);

      if (response.statusCode == 200) {
        print('Image uploaded successfully');
        setState(() {});
      } else {
        print('Failed to upload image. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error uploading image: $error');
    }

    setState(() {

    });
  }

  Future<void> postRequest() async {
    String timeStamp = format.format(DateTime.now());
    List<String> adminsAsList = selectedAdmins.map((club) => club.id).toList();
    if (!adminsAsList.contains(widget.club.id)) {
      adminsAsList.add(widget.club.id);
    }
    final response = await http.post(
      Uri.parse('$serverUrl/api/events/createEvent'),
      headers: await getHeaders(),
      body: jsonEncode(<String, dynamic>{
        "admin": adminsAsList,
        "name": eventName.text,
        "description": eventDesc.text,
        "latitude": latitude,
        "longitude": longitude,
        "timestamp": timeStamp,
        "repeat": repeatable,
        "tags": [],
      }),
    );

    var responseData = json.decode(response.body);
    await sendImageToServer(newImageBytes, responseData["message"].toString());
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
      body: FutureBuilder<void>(
        future: getAdmin(),
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return buildPage();
          } else {
            return LoaderWidget();
          }
        },
      ),
    );
  }

  Widget buildPage() {
    return Form(
      key: _oFormKey,
      child: Padding(
        padding: EdgeInsets.all(18),
        child: ListView(
          children: [
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: _pickImage,
                    child: _image == null
                        ? ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.asset('assets/ex1.jpeg',
                          height: 150, width: 150, fit: BoxFit.cover),
                    )
                        : ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.file(
                          i.File(_image!.path),
                          width: 150.0,
                          height: 150.0,
                          fit: BoxFit.cover,

                        )
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
                          TextFormField(
                            style: TextStyle(
                              fontFamily: 'Garret',
                              color: Colors.black,
                              fontSize: 15,
                            ),
                            controller: eventName,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a title.';
                              }
                              return null;
                            },
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
                          Divider(height: 25,),
                          TextFormField(
                            style: TextStyle(
                              fontFamily: 'Garret',
                              color: Colors.black,
                              fontSize: 15,
                            ),
                            controller: eventDesc,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter text.';
                              }
                              return null;
                            },
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
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(height: 25,),
            Container(
              width: 295.0,
              child: MultiSelectDialogField(
                buttonText: Text("Search Admins"),
                buttonIcon: Icon(Icons.search),
                items: clubs.map((e) => MultiSelectItem(e, e.name)).toList(),
                initialValue:
                    selectedAdmins.toList(),
                onConfirm: (List<dynamic> values) {
                  selectedAdmins = values.cast<ClubCardData>().toSet();
                  print("SELECTED ADMINS: $selectedAdmins");
                },
                validator: (value) {
                  if (selectedAdmins.isEmpty) {
                    return 'Please choose at least one admin.';
                  }
                  return null;
                },
                searchable: true,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  border: Border.all(
                    color: Colors.grey,
                    width: 1.2,
                  ),
                ),
                chipDisplay: MultiSelectChipDisplay<ClubCardData>(
                  onTap: (value) {
                    setState(() {
                      selectedAdmins.remove(value);
                    });
                  },
                  items: selectedAdmins.map((e) => MultiSelectItem(e, e.name)).toList(),
                  scroll: true,
                  chipColor: _orangeColor,
                  textStyle: TextStyle(color: Colors.grey[800]),
                ),
              ),
            ),
            Divider(height: 25.0,),
            Container(
              width: 295.0,
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
                      return selectedDateTime;
                    }
                  }
                },
              ),
            ),
            Divider(height: 25,),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.1),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FormField(
                    validator: (value) {
                      if (latitude == 0 || longitude == 0) {
                        return 'Please choose a location.';
                      }
                      return null;
                    },
                    builder: (FormFieldState state) {
                      return ElevatedButton(
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
                        child: const Text('Choose Location'),
                      );
                    }
                  ),
                  AnimatedButton(
                    transitionType: TransitionType.LEFT_TO_RIGHT,
                    textStyle: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Garret',
                      fontSize: 15,
                    ),
                    text: "Private",
                    selectedText: "Public",
                    onPress: () {
                      if (indexPubOrPriv == 1) {
                        indexPubOrPriv = 0;
                      } else if (indexPubOrPriv == 0) {
                        indexPubOrPriv = 1;
                      }
                    },
                    selectedTextColor: Colors.white,
                    selectedBackgroundColor: _orangeColor,
                    backgroundColor: Colors.grey,
                    width: 120,
                    height: 40,
                    borderRadius: 20.0,
                    isReverse: true,
                  ),
                ],
              ),
            ),
            Divider(height: 25,),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => {
                      retrieveAutocomplete("Santa Cruz")
                    }, 
                    child: const Text("Google Places Test")
                  ),
                  AnimatedButton(
                    transitionType: TransitionType.LEFT_TO_RIGHT,
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Garret',
                      fontSize: 15,
                    ),
                    text: "Repeatable",
                    selectedText: "Not Repeatable",
                    onPress: () {
                      repeatable = !repeatable;
                    },
                    selectedTextColor: Colors.black,
                    selectedBackgroundColor: Colors.grey,
                    backgroundColor: _orangeColor,
                    height: 45,
                    width: 200,
                    borderRadius: 20.0,
                    isReverse: true,
                  ),
                  AnimatedButton(
                    transitionType: TransitionType.CENTER_LR_OUT,
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Garret',
                      fontSize: 15,
                    ),
                    text: "Post",
                    onPress: () {
                      if (_oFormKey.currentState!.validate()) {
                        postRequest();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            backgroundColor: Colors.green,
                            content: Text('New event created successfully!'),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            backgroundColor: Colors.red,
                            content: Text('Please fill out all fields!'),
                          ),
                        );
                      }
                    },
                    selectedTextColor: Colors.white,
                    selectedBackgroundColor: Colors.lightBlue,
                    backgroundColor: Colors.green,
                    borderRadius: 20.0,
                    height: 45,
                    width: 100,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  Future<void> _pickImage() async {
    final XFile? pickedFile = await ImagePicker().pickImage(
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

}

class StatefulMultiSelect extends StatefulWidget{
  final List<ClubCardData> clubs;
  final Set<ClubCardData> selectedAdmins;
  final Function toggleSelectedAdmin;
  StatefulMultiSelect(
      {required this.clubs,
      required this.selectedAdmins,
      required this.toggleSelectedAdmin});

  @override
  _StatefulMultiSelectState createState() => _StatefulMultiSelectState();
}

class _StatefulMultiSelectState extends State<StatefulMultiSelect> {
  late Set<ClubCardData> selectedAdmins;
  @override
  Widget build(BuildContext context) {
    return MultiSelectDialogField(
      buttonText: Text("Search Admins"),
      buttonIcon: Icon(Icons.search),
      items: widget.clubs.map((e) => MultiSelectItem(e, e.name)).toList(),
      initialValue:
          selectedAdmins.toList(),
      onConfirm: (List<dynamic> values) {
        selectedAdmins = values.cast<ClubCardData>().toSet();
        print("SELECTED ADMINS: ${selectedAdmins}");
      },
      validator: (value) {
        if (selectedAdmins.isEmpty) {
          return 'Please choose at least one admin.';
        }
        return null;
      },
      searchable: true,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        border: Border.all(
          color: Colors.grey,
          width: 1.2,
        ),
      ),
      chipDisplay: MultiSelectChipDisplay<ClubCardData>(
        onTap: (value) {
          setState(() {
            selectedAdmins.remove(value);
          });
        },
        items: selectedAdmins.map((e) => MultiSelectItem(e, e.name)).toList(),
        scroll: true,
        chipColor: Colors.orange,
        textStyle: TextStyle(color: Colors.grey[800]),
      ),
    );
  }
}