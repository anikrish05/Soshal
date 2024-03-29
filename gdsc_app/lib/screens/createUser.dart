import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gdsc_app/classes/userData.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

int currYear = DateTime.now().year;
List<int> list = <int>[currYear, currYear + 1, currYear + 2, currYear + 3, currYear + 4];
Color _orangeColor = Color(0xFFFF8050);

class CreateUserScreen extends StatefulWidget {
  final UserData user;
  CreateUserScreen({required this.user});
  @override
  _CreateUserScreenState createState() => _CreateUserScreenState();
}

class _CreateUserScreenState extends State<CreateUserScreen> {
  final newName = TextEditingController();
  late int gradYear = widget.user.classOf;
  List<String> selectedTags = [];

  List<String> sampleTags = [
    "Social",
    "Academic",
    "Professional",
    "Sports",
    "Music",
    "Art",
    "Food",
    "Gaming",
    "Other"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () => Navigator.of(context).pop(),
          color: Colors.orange,
        ),
        centerTitle: true,
        title: Text(
          "Update Profile",
          style: TextStyle(
            color: Color(0xFF88898C),
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(30.0),
        child: ListView(
          children: [
            Container(
              margin: EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Change Name'),
                  SizedBox(height: 20.0),
                  _buildTextField(newName, 'Enter Name', Icons.person),
                  SizedBox(height: 20.0),
                  Divider(),
                  _buildSectionTitle('Change Graduation Year'),
                  SizedBox(height: 20.0),
                  _buildDropdownButton(),
                  SizedBox(height: 20.0),
                  Divider(),
                  _buildSectionTitle('Select Interested Tags'),
                  SizedBox(height: 20.0),
                  MultiSelectDialogField(
                    buttonText: Text("Select Interested Tags"),
                    buttonIcon: Icon(Icons.tag_faces),
                    title: Text("Select Tags"),
                    initialValue: widget.user.interestedTags,
                    items: sampleTags
                        .map((e) => MultiSelectItem(e, e))
                        .toList(),
                    dialogHeight: () {
                      double? height = sampleTags.length * 50.0 + 50.0;
                      if (height > 500.0) {
                        return 550.0;
                      } else {
                        return height;
                      }
                    }(),
                    onConfirm: (List<String> values) {
                      setState(() {
                        selectedTags = values;
                      });
                    },
                    searchable: true,
                    validator: (value) {
                      if (selectedTags.length == 0) {
                        return 'Please choose at least one tag.';
                      }
                    },
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      border: Border.all(
                        color: Colors.grey,
                        width: 1.2,
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Divider(),
                  _buildUpdateButton(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black.withOpacity(0.6), fontFamily: 'Garret', fontSize: 18),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hintText, IconData icon) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
        hintText: hintText,
        prefixIcon: Icon(icon),
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
      ),
    );
  }

  Widget _buildDropdownButton() {
    return Container(
      width: 175,
      padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50.0),
        color: Colors.grey[200],
      ),
      child: DropdownButton<int>(
        value: gradYear,
        hint: Text('Select Graduation Year'),
        isExpanded: true,
        elevation: 16,
        underline: SizedBox(),
        onChanged: (int? value) {
          setState(() {
            gradYear = value!;
          });
        },
        items: list.map<DropdownMenuItem<int>>((int value) {
          return DropdownMenuItem<int>(
            value: value,
            child: Text('$value'),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildUpdateButton() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            height: 50,
            width: 200,
            child: _buildAnimatedButton(),
          )
        ],
      ),
    );
  }

  Widget _buildAnimatedButton() {
    return ElevatedButton.icon(
      onPressed: () {
        _onUpdate();
      },
      icon: Icon(Icons.update),
      label: Text('Update'),
      style: ElevatedButton.styleFrom(
        primary: _orangeColor,
        shape: StadiumBorder(),
        textStyle: TextStyle(fontFamily: 'Garret', fontSize: 22, color: Colors.white),
      ),
    );
  }

  void _onUpdate() {
    String userName = newName.text;
    int graduation = gradYear;

    if (userName == "") {
      userName = widget.user.displayName;
    }

    Navigator.pop(context, [graduation, userName, widget.user.uid, selectedTags]);
  }
}
