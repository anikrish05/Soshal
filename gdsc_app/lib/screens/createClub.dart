import 'dart:async';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:toggle_switch/toggle_switch.dart';
import 'package:gdsc_app/classes/club.dart';
import '../utils.dart';
import '../widgets/loader.dart';
import '../classes/userData.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

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
  var category = TextEditingController();
  Set<UserData> users = {};
  Set<UserData> selectedAdmins = {};
  GlobalKey<FormState> _oFormKey = GlobalKey<FormState>();
  Color _orangeColor = Color(0xFFFF8050);
  late String currUserId;
  int indexPubOrPriv = 1;
  final TextEditingController controller = TextEditingController();

  _CreateClubScreenState(currUserId) {
    this.currUserId = currUserId;
  }

  void submit() {
    Club club = Club();
    late String type;
    if (indexPubOrPriv == 1) {
      type = "Public";
    } else {
      type = "Private";
    }
    List<String> adminsAsList = selectedAdmins.map((user) => user.uid).toList();
    if (!adminsAsList.contains(currUserId)) {
      adminsAsList.add(currUserId);
    }
    club.addClub(
      clubName.text,
      clubBio.text,
      location.text,
      category.text,
      type,
      adminsAsList,
      [],
    ).then((check) => {
      if (check) {
        Navigator.of(context).pop()
      }
    });
  }

  void toggleSelectedAdmin(UserData selection) {
    if (selectedAdmins.contains(selection)) {
      selectedAdmins.remove(selection);
      debugPrint("$selection removed from admin list.");
    } else {
      selectedAdmins.add(selection);
      debugPrint("$selection added as admin.");
    }
  }

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
          "Create a Club",
          style: TextStyle(
            color: Color(0xFF88898C),
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
      child: ListView(
        padding: EdgeInsets.all(30.0),
        children: [
          Container(
            margin: EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.asset(
                    'assets/empty-club-image.png',
                    height: 150,
                    width: 150,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 16.0),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 65,
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
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            hintText: "Club Name",
                            contentPadding:
                            EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                          ),
                        ),
                      ),
                      SizedBox(height: 20.0),
                      Divider(),
                      SizedBox(
                        height: 110,
                        child: TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a bio.';
                            }
                            return null;
                          },
                          controller: clubBio,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            hintText: "Add Club Bio",
                            contentPadding:
                            EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                          ),
                          maxLines: 3,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(),
          Container(
            margin: EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter one.';
                      }
                      return null;
                    },
                    controller: category,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      hintText: "Category",
                      contentPadding:
                      EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                    ),
                  ),
                ),
                SizedBox(width: 16.0),
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
          Divider(),
          Container(
            margin: EdgeInsets.all(10.0),
            child: TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a phone number.';
                }
                return null;
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                hintText: "Contact Info (Phone Number)",
                contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                prefixIcon: Icon(Icons.phone),
              ),
            ),
          ),
          Divider(),
          Container(
            margin: EdgeInsets.all(10.0),
            child: MultiSelectDialogField(
              buttonText: Text("Search Admins"),
              items: users.map((e) => MultiSelectItem(e, e.displayName)).toList(),
              onConfirm: (List<UserData> values) {
                selectedAdmins = values.toSet();
              },
              searchable: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please choose at least one admin.';
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
            ),
          ),
          Divider(),
          Container(
            margin: EdgeInsets.all(10.0),
            child: ElevatedButton.icon(
              icon: Icon(Icons.add),
              label: Text(
                  'Create Club',
                  style:TextStyle(
                    fontFamily: 'Borel',
                    fontSize: 20,
                  ),
    ),
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
                  ),
                ),
                backgroundColor: MaterialStateProperty.all<Color>(_orangeColor),
              ),
            ),
          ),
        ],
      ),
    );
  }


  Future<void> getAdmin() async {
    users = {};
    final response = await http.get(
      Uri.parse('http://10.0.2.2:3000/api/users/getAllUsers'),
      headers: await getHeaders(),
    );
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body)['message'];

      for (int i = 0; i < responseData.length; i++) {
        UserData newUser = UserData(
          uid: responseData[i]["uid"],
          displayName: responseData[i]["displayName"],
          email: responseData[i]["email"],
          following: responseData[i]["following"],
          role: responseData[i]["role"],
          myEvents: List<String>.from(
            (responseData[i]['myEvents'] ?? []).map(
                  (event) => event.toString(),
            ),
          ),
          likedEvents: List<String>.from(
            (responseData[i]['likedEvents'] ?? []).map(
                  (event) => event.toString(),
            ),
          ),
          dislikedEvents: List<String>.from(
            (responseData[i]['dislikedEvents'] ?? []).map(
                  (event) => event.toString(),
            ),
          ),
          clubIds: List<String>.from(
            (responseData[i]['clubIds'] ?? []).map(
                  (club) => club.toString(),
            ),
          ),
          friendGroups: List<String>.from(
            (responseData[i]['friendGroups'] ?? []).map(
                  (friend) => friend.toString(),
            ),
          ),
          interestedTags: List<String>.from(
            (responseData[i]['interestedTags'] ?? []).map(
                  (tag) => tag.toString(),
            ),
          ),
          downloadURL: responseData[i]["downloadURL"],
          classOf: responseData[i]["classOf"],
        );
        users.add(newUser);
      }
    } else {
      print('Request failed with status: ${response.statusCode}');
    }
  }
}
