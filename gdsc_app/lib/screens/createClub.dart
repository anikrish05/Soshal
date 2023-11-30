import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:toggle_switch/toggle_switch.dart';

class CreateClubScreen extends StatelessWidget {

  var clubName = TextEditingController();
  var clubBio = TextEditingController();
  var location = TextEditingController();
  var category = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: BackButton(
        onPressed: () => Navigator.of(context).pop(),
      color: Colors.orange),backgroundColor: Colors.white),
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
                              controller: clubName,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
                                labelText: 'Club Name',
                              ),
                            ),
                          ),
                          Divider(),
                          SizedBox(
                            height: 110,
                            width: 150,
                            child: TextField(
                              controller: clubBio,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
                                labelText: 'Add Club Bio',
                              ),
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
                child: TextField(
                  controller: location,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
                    labelText: 'Location',
                  ),
                ),
              ),
              VerticalDivider(),
              ToggleSwitch(
                minWidth: 77.5,
                cornerRadius: 20.0,
                activeBgColors: [[Colors.orange[400]!], [Colors.orange[400]!]],
                activeFgColor: Colors.white,
                inactiveBgColor: Colors.grey,
                inactiveFgColor: Colors.white,
                initialLabelIndex: 1,
                totalSwitches: 2,
                labels: ['Public', 'Private'],
                radiusStyle: true,
                onToggle: (index) {
                  print('switched to: $index');
                },
              ),
            ]
          )
        ),
        Divider(),
        TextField(
          controller: category,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
            labelText: 'Category',
          )
        ),
          Divider(),
          TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
              labelText: 'Contact Info',
            ),
          ),
          Divider(),
          Text('Add Admins'),
          ElevatedButton(
            child: Text('Add Admin'),
            onPressed: () {},
            style: ButtonStyle(shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: Colors.red)
                )
            ),backgroundColor: MaterialStateProperty.all<Color>(Colors.orange)),
          ),
          Divider(),
          ElevatedButton(
            child: Text('Create Club'),
            onPressed: () {},
            style: ButtonStyle(shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: Colors.red)
                )
            ),backgroundColor: MaterialStateProperty.all<Color>(Colors.orange))
          ),

        ],
      )

    ),
    );
  }
}

