import 'dart:async';
import 'dart:convert';
import 'dart:io' as i;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import 'package:image_picker/image_picker.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:gdsc_app/classes/club.dart';
import '../app_config.dart';
import '../utils.dart';
import '../widgets/loader.dart';
import '../classes/userData.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

final serverUrl = AppConfig.serverUrl;

class CreateClubScreen extends StatefulWidget {
  late String currUserId;
  CreateClubScreen(currUserId) {
    this.currUserId = currUserId;
  }
  @override
  _CreateClubScreenState createState() => _CreateClubScreenState(currUserId);
}

class _CreateClubScreenState extends State<CreateClubScreen> {
  var clubName = TextEditingController();

  var clubBio = TextEditingController();

  var location = TextEditingController();

  List<int> newImageBytes = [];
  bool chooseImage = false;
  String selectedImage = 'assets/ex1.jpeg';
  XFile? _image;
  Set<UserData> users = {};
  List<UserData> selectedAdmins = [];
  List<String> selectedTags = [];
  List<String> sampleTags = ["Party", "Social", "Hackathon, Coding"];
  GlobalKey<FormState> _oFormKey = GlobalKey<FormState>();
  Color _orangeColor = Color(0xFFFF8050);
  late String currUserId;
  int indexPubOrPriv = 1;
  final TextEditingController controller = TextEditingController();

  _CreateClubScreenState(currUserId) {
    this.currUserId = currUserId;
  }

  FutureOr sendImageToServer(List<int> imageBytes, String id) async {
    try {
      final response = await http.post(
        Uri.parse('$serverUrl/api/clubs/updateClubImage'),
        headers: await getHeaders(),
        body: jsonEncode(<String, dynamic>{"image": imageBytes, "id": id}),
      );
      if (response.statusCode == 200) {
        print('Image uploaded successfully');
        setState(() {});
      } else {
        print('Failed to upload image. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error uploading image: $error');
    }

    setState(() {});
  }

  void _showPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text('Choose an Image!'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the popup
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> getAdmin() async {
    users = {};
    final response = await http.get(
        Uri.parse('http://10.0.2.2:3000/api/users/getAllUsers'),
        headers: await getHeaders());
    if (response.statusCode == 200) {
      // Parse and update the user list

      final responseData = jsonDecode(response.body)['message'];

      for (int i = 0; i < responseData.length; i++) {
        UserData newUser = UserData(
            uid: responseData[i]["uid"],
            displayName: responseData[i]["displayName"],
            email: responseData[i]["email"],
            following: responseData[i]["following"],
            role: responseData[i]["role"],
            myEvents: List<String>.from((responseData[i]['myEvents'] ?? [])
                .map((event) => event.toString())),
            likedEvents: List<String>.from((responseData[i]['likedEvents'] ?? [])
                .map((event) => event.toString())),
            dislikedEvents: List<String>.from((responseData[i]['dislikedEvents'] ?? [])
                .map((event) => event.toString())),
            clubIds: List<String>.from((responseData[i]['clubIds'] ?? [])
                .map((club) => club.toString())),
            friendGroups: List<String>.from(
                (responseData[i]['friendGroups'] ?? []).map((friend) => friend.toString())),
            interestedTags: List<String>.from((responseData[i]['interestedTags'] ?? []).map((tag) => tag.toString())),
            downloadURL: responseData[i]["downloadURL"],
            classOf: responseData[i]["classOf"]);
        users.add(newUser);
      }
      selectedAdmins = users.where((user) => user.uid == currUserId).toList();
    } 
    else {
      // Handle the error
      print('Request failed with status: ${response.statusCode}');
    }
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

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

  void submit() async {
    Club club = Club();
    late String type;
    if (indexPubOrPriv == 1) {
      type = "Public";
    } else {
      type = "Private";
    }

    if (chooseImage == false) {
      _showPopup(context);
      return;
    }
    List<String> adminsAsList = selectedAdmins.map((user) => user.uid).toList();
    if (!adminsAsList.contains(currUserId)) {
      adminsAsList.add(currUserId);
    }

    final response =
        await http.post(Uri.parse('$serverUrl/api/clubs/createClub'),
            headers: await getHeaders(),
            body: jsonEncode(<String, dynamic>{
              "name": clubName.text,
              "description": clubBio.text,
              "type": type,
              "admin": adminsAsList,
              "tags": selectedTags,
            }));
    var responseData = json.decode(response.body);
    print("Test");
    print(responseData["message"].toString());
    await sendImageToServer(newImageBytes, responseData["message"].toString());
    Navigator.pop(context, [
      clubName.text,
      clubBio.text,
      location.text,
      type,
      adminsAsList,
      selectedTags,
      newImageBytes
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: BackButton(
              onPressed: () => Navigator.of(context).pop(),
              color: _orangeColor),
          centerTitle: true,
          title: Text(
            "Create a Club",
            style: TextStyle(
              color: Color(0xFF88898C),
            ),
          ),
          backgroundColor: Colors.white),
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
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
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
                            )),
                  ),
                  VerticalDivider(),
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 200,
                          child: TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a title.';
                              }
                              return null;
                            },
                            controller: clubName,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0)),
                              hintText: "Club Name",
                              contentPadding:
                                  EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                            ),
                          ),
                        ),
                        Divider(),
                        SizedBox(
                          height: 100,
                          width: 200,
                          child: TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a biography.';
                              }
                              return null;
                            },
                            controller: clubBio,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0)),
                              hintText: "Add Club Bio",
                              contentPadding:
                                  EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                            ),
                            maxLines: 3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              height: 40,
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: MultiSelectDialogField(
                      buttonText: Text("Select Tags"),
                      buttonIcon: Icon(Icons.tag_faces),
                      title: Text("Select Tags"),
                      initialValue: selectedTags.toList(),
                      items: sampleTags
                          .map((e) => MultiSelectItem(e, e))
                          .toList(),
                      onConfirm: (List<dynamic> values) {
                        selectedTags = values.cast<String>();
                      },
                      searchable: true,
                      validator: (value) {
                        if (selectedTags.length == 0) {
                          return 'Please choose at least one tag.';
                        }
                        return null;
                      },
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        border: Border.all(
                          color: Colors.grey,
                          width: 1.2,
                        ),
                      ),
                      chipDisplay: MultiSelectChipDisplay<String>(
                        onTap: (value) {
                          setState(() {
                            selectedTags.remove(value);
                          });
                        },
                        chipColor: _orangeColor,
                        textStyle: TextStyle(color: Colors.grey[800]),
                      ),
                    ),
                  ),              
                  VerticalDivider(),
                  ToggleSwitch(
                    minWidth: 67.5,
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
                    labels: ['Public', 'Private'],
                    radiusStyle: true,
                    onToggle: (index) {
                      if (index == 1) {
                        indexPubOrPriv = 0;
                      } else if (index == 0) {
                        indexPubOrPriv = 1;
                      }
                    },
                  ),
                ],
              ),
            ),
            Divider(height: 40),
            /// Creates a multi-select dialog field for searching and selecting admins.
            MultiSelectDialogField(
              buttonText: Text("Search Admins"),
              buttonIcon: Icon(Icons.search),
              items: users.map((e) => MultiSelectItem(e, e.displayName)).toList(),
              initialValue:
                  selectedAdmins.toList(),
              onConfirm: (List<dynamic> values) {
                selectedAdmins = values.cast<UserData>();
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
              chipDisplay: MultiSelectChipDisplay<UserData>(
                onTap: (value) {
                  setState(() {
                    selectedAdmins.remove(value);
                  });
                },
                chipColor: _orangeColor,
                textStyle: TextStyle(color: Colors.grey[800]),
              ),
            ),
            Divider(),
            ElevatedButton(
              child: Text('Create Club'),
              onPressed: () {
                if (_oFormKey.currentState!.validate()) {
                  submit();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      backgroundColor: Colors.green,
                      content: Text('New club created successfully!'),
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
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: BorderSide.none,
                )),
                backgroundColor: MaterialStateProperty.all<Color>(_orangeColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}