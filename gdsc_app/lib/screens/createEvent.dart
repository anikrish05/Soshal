import 'package:flutter/material.dart';
import 'package:gdsc_app/screens/createEventMap.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';

class CreateEventScreen extends StatefulWidget {
  _CreateEventScreenState createState() => _CreateEventScreenState();

}

class _CreateEventScreenState extends State<CreateEventScreen> {
  final format = DateFormat("yyyy-MM-dd HH:mm");
  late DateTime selectedDateTime;


  var eventName = TextEditingController();

  var eventDesc = TextEditingController();

  LatLng? _selectedLatLng;

  Color _orangeColor = Color(0xFFFF8050);
  late String currUserId;

  @override
  void onGetLocation() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CreateEventMapScreen()),
    );
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
                          Image.network('https://cdn.britannica.com/38/111338-050-D23BE7C8/Stars-NGC-290-Hubble-Space-Telescope.jpg?w=400&h=300&c=crop',
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
                                      style: TextStyle(fontFamily: 'Garet', color: Colors.grey, fontSize: 15),
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
                                      style: TextStyle(fontFamily: 'Garet', color: Colors.grey, fontSize: 15),
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
                RichText(
                  text: TextSpan(
                    text: 'Choose Date and Time',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black.withOpacity(0.6),fontFamily: 'Borel', fontSize: 15),
                  ),
                ),
                Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                            width: 240.0,
                            height: 30.0,
                            child:
                            DateTimeField(
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
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            if (selectedDateTime != null) {
                              final formattedDateTime = format.format(selectedDateTime);
                              // For demonstration purposes, display the formatted date and time in a Snackbar
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Selected Date and Time: $formattedDateTime'),
                                ),
                              );
                              // You can store `formattedDateTime` or `selectedDateTime` as needed
                            } else {
                              // Handle the case where no date and time are selected
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Please select a date and time.'),
                                ),
                              );
                            }
                          },
                          child: Text('Show Snackbar'),
                        ),
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