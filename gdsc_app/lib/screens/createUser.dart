import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gdsc_app/classes/userData.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

int currYear = DateTime.now().year;
List<int> list = <int>[currYear, currYear + 1,currYear + 2, currYear + 3, currYear + 4];

class CreateUserScreen extends StatefulWidget {
  final UserData user;
  CreateUserScreen({required this.user});
  @override
  _CreateUserScreenState createState() => _CreateUserScreenState();
}
// widget.user
class _CreateUserScreenState extends State<CreateUserScreen> {
  final newName = TextEditingController();
  int gradYear = list.first;

  final ButtonStyle style =
  ElevatedButton.styleFrom(
      backgroundColor: Colors.orange,
      shape: StadiumBorder(),
      textStyle: const TextStyle(fontSize: 18));
      
  List<String> selectedTags = [];
  List<String> sampleTags = ["Social", "Academic", "Professional", "Sports", "Music", "Art", "Food", "Gaming", "Other"];
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(leading: BackButton(
            onPressed: () => Navigator.of(context).pop(),
            color: Colors.orange),
            centerTitle: true,
            title: Text("Update Profile",
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
                          Text(
                            'Change Name',
                            style: TextStyle(
                              color: Colors.black.withOpacity(0.6),
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              fontFamily: Theme.of(context).textTheme.bodyLarge!.fontFamily,
                              decorationColor: Colors.black.withOpacity(0.6),
                              decorationThickness: 2.0,
                            ),
                          ),
                          Padding(padding: EdgeInsets.only(bottom: 8)),
                          TextField(
                            controller: newName,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
                              hintText: widget.user.displayName,
                              contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                            ),
                          ),
                          Divider(),
                          Text(
                            'Change Graduation Year',
                            style: TextStyle(
                              color: Colors.black.withOpacity(0.6),
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              fontFamily: Theme.of(context).textTheme.bodyLarge!.fontFamily,
                              decorationColor: Colors.black.withOpacity(0.6),
                              decorationThickness: 2.0,
                            ),
                          ),
                          Padding(padding: EdgeInsets.only(bottom: 8)),
                          Container(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50.0),
                                color: Colors.grey[200], // Change the color as needed
                              ),
                              child:DropdownButton<int>(
                                value: gradYear,
                                hint: Text('Select Graduation Year'),
                                isExpanded: true,
                                elevation: 16,
                                underline: SizedBox(),
                                onChanged: (int? value) {
                                  // This is called when the user selects an item.
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
                          ),
                          Divider(),
                          MultiSelectDialogField(
                            buttonText: Text("Select Interested Tags"),
                            buttonIcon: Icon(Icons.tag_faces),
                            title: Text("Select Tags"),
                            initialValue: selectedTags.toList(),
                            items: sampleTags
                                .map((e) => MultiSelectItem(e, e))
                                .toList(),
                            onConfirm: (List<String> values) {
                              selectedTags = values;
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
                                    onPressed: () {_onUpdate();},
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

  void _onUpdate() {
    String userName = newName.text;
    int graduation = gradYear;

    if(userName == "")
    {
      userName = widget.user.displayName;
    }

    Navigator.pop(context, [graduation, userName, widget.user.uid, selectedTags]);

  }
}
