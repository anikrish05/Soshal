import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:toggle_switch/toggle_switch.dart';
import 'package:gdsc_app/classes/club.dart';
import '../utils.dart';
import '../widgets/loader.dart';
import '../classes/userData.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

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
    club
        .addClub(clubName.text, clubBio.text, location.text, category.text,
            type, adminsAsList, []) //that last array is passing in empty tags list, populate please
        .then((check) => {
              if (check) {Navigator.of(context).pop()}
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
      child: ListView(children: [
        Container(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.asset('assets/ex1.jpeg',
                  height: 150, width: 150, fit: BoxFit.cover),
            ),
            VerticalDivider(),
            Container(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                  SizedBox(
                    height: 65,
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
                    height: 110,
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
                  )
                ]))
          ],
        )),
        Divider(),
        Container(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              Expanded(
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a category.';
                    }
                    return null;
                  },
                  controller: category,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    hintText: "Category",
                    contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                  ),
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
            ])),
        Divider(),
        TextFormField(
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a phone number.';
            }
            return null;
          },
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
            hintText: "Contact Info (Phone Number)",
            contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          ),
        ),
        Divider(),
        TypeAheadField<UserData>(
          builder: (context, controller, focusNode) {
            return TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please choose at least one admin.';
                }
                return null;
              },
              controller: controller,
              focusNode: focusNode,
              decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
                hintText: "Search Admins",
                contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              ),
            );
          },
          itemBuilder: (context, suggestion) {
            return ListTile(
              title: Text(suggestion.displayName),
              trailing: Icon(selectedAdmins.contains(suggestion)
                  ? Icons.check_circle
                  : Icons.check_circle_outline),
            );
          },
          onSelected: (suggestion) {
            toggleSelectedAdmin(suggestion);
            controller.selection =
                TextSelection.collapsed(offset: 0); // Reset cursor
            controller.clear(); // Clear the field
          },
          suggestionsCallback: (String search) {
            if (search == "" && !selectedAdmins.isEmpty) {
              return selectedAdmins.toList();
            }
            return users
                .where((admin) => admin.displayName
                    .toLowerCase()
                    .contains(search.toLowerCase()))
                .toList();
          },
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
                backgroundColor: MaterialStateProperty.all<Color>(_orangeColor))),
      ]),
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
            likedEvents: List<String>.from(
                (responseData[i]['likedEvents'] ?? [])
                    .map((event) => event.toString())),
            dislikedEvents: List<String>.from(
                (responseData[i]['dislikedEvents'] ?? [])
                    .map((event) => event.toString())),
            clubIds: List<String>.from((responseData[i]['clubIds'] ?? [])
                .map((club) => club.toString())),
            friendGroups: List<String>.from((responseData[i]['friendGroups'] ?? [])
                .map((friend) => friend.toString())),
            interestedTags: List<String>.from((responseData[i]['interestedTags'] ?? [])
                .map((tag) => tag.toString())),
            downloadURL: responseData[i]["downloadURL"],
            classOf: responseData[i]["classOf"]);
        users.add(newUser);
      }
    } else {
      // Handle the error
      print('Request failed with status: ${response.statusCode}');
    }
  }
}
