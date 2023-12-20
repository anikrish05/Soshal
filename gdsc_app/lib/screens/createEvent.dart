import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gdsc_app/screens/createEventMap.dart';
import 'package:http/http.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:gdsc_app/classes/club.dart';
import 'package:date_time_picker/date_time_picker.dart';

class CreateEventScreen extends StatefulWidget {
  _CreateEventScreenState createState() => _CreateEventScreenState();

}

class _CreateEventScreenState extends State<CreateEventScreen> {
  GlobalKey<FormState> _oFormKey = GlobalKey<FormState>();
  late TextEditingController _controller1;
  String _valueChanged1 = '';
  String _valueToValidate1 = '';
  String _valueSaved1 = '';
  String date = "";
  double latitude = 0.0;
  double longitude = 0.0;

  var eventName = TextEditingController();

  var eventDesc = TextEditingController();

  var location = TextEditingController();

  Color _orangeColor = Color(0xFFFF8050);
  late String currUserId;

  @override
  void onGetLocation() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CreateEventMapScreen()),
    );
    result.latitude = latitude;
    result.longitude = longitude;
  }

  bool repeatable = true;
  final ButtonStyle style2 =
  ElevatedButton.styleFrom(
      backgroundColor: Colors.orange,
      shape: StadiumBorder(),
      textStyle: const TextStyle(fontFamily: 'Borel', fontSize: 15, color: Colors.grey ));
  final ButtonStyle style =
  ElevatedButton.styleFrom(
      backgroundColor: Colors.orange,
      shape: StadiumBorder(),
      textStyle: const TextStyle(fontFamily: 'Borel', fontSize: 30, color: Colors.grey ));

  int indexPubOrPriv = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(leading: BackButton(
            onPressed: () => Navigator.of(context).pop(),
            color: _orangeColor),
            centerTitle: true,
            title: Text("Create an Event",
              style: TextStyle(
                color: Color(0xFF88898C),
              ),),
            backgroundColor: Colors.white
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
                          child:
                          Image.network('https://raw.githubusercontent.com/anikrish05/Soshal/c54bb225182d1b0263a168f7aac91d8c661b24d3/gdsc_app/assets/ex1.jpeg',
                              height: 150,
                              width: 150,
                              fit: BoxFit.cover
                          ),
                        ),
                        VerticalDivider(),
                        Container(
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children:[
                                  SizedBox(
                                    height: 40,
                                    width: 150,
                                    child: TextField(
                                      style: TextStyle(fontFamily: 'Borel', color: Colors.grey, fontSize: 15),
                                      controller: eventName,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
                                        hintText: "Event Title",
                                        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                                      ),

                                    ),
                                  ),
                                  Divider(),
                                  SizedBox(
                                    height: 110,
                                    width: 150,
                                    child: TextField(
                                      style: TextStyle(fontFamily: 'Borel', color: Colors.grey, fontSize: 15),
                                      controller: eventDesc,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
                                        hintText: "Event Description",
                                        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),                              ),
                                      maxLines: 3,
                                    ),
                                  )
                                ]
                            )
                        )
                      ],
                    )
                ),
                Divider(),
                Container(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 40,
                            width: 150,
                            child: ElevatedButton(
                              style: style2,
                              onPressed: () {onGetLocation();},
                              child: const Text('Chose Location'),
                            ),
                          ),
                          VerticalDivider(),
                          ToggleSwitch(
                            minWidth: 77.5,
                            cornerRadius: 20.0,
                            activeBgColors: [[_orangeColor], [_orangeColor]],
                            activeFgColor: Colors.white,
                            inactiveBgColor: Colors.grey,
                            inactiveFgColor: Colors.white,
                            initialLabelIndex: 0,
                            totalSwitches: 2,
                            labels: ['Public', 'Private'],
                            radiusStyle: true,
                            onToggle: (index) {
                              if(index==1)
                              {
                                indexPubOrPriv = 0;

                              }
                              else if(index==0)
                              {
                                indexPubOrPriv = 1;

                              };
                            },
                          ),
                        ]
                    )
                ),
                Divider(),
                Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                            width: 240.0,
                            height: 30.0,
                            child:
                            DateTimePicker
                              (
                              type: DateTimePickerType.dateTimeSeparate,
                              onChanged: (date) {
                                date = date;
                              },
                              dateMask: '[yyyy-MM-d hh:mm]',
                              initialValue: DateTime.now().toString(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                              icon: Icon(Icons.event),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
                              ),

                            )
                        )

                      ],
                    )
                ),
                Divider(),
                Container(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            text: 'Repeatable',
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black.withOpacity(0.6),fontFamily: 'Borel', fontSize: 30),


                          ),
                        ),
                        Switch(
                          // This bool value toggles the switch.
                          value: repeatable,
                          activeColor: Colors.orange,
                          onChanged: (bool value) {
                            // This is called when the user toggles the switch.
                            setState(() {
                              repeatable = value;
                            });
                          },
                        )
                      ]
                  ),
                ),
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
                          onPressed: () {},
                          child: const Text('post'),
                        ),
                      )
                    ],
                  ),
                )

              ]),
        ));
  }
}