import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:gdsc_app/classes/club.dart';

class CreateClubScreen extends StatefulWidget {
  late String currUserId;
  CreateClubScreen(currUserId){
    this.currUserId = currUserId;
  }
  @override
  _CreateClubScreenState createState() =>
      _CreateClubScreenState(currUserId);
}

class _CreateClubScreenState extends State<CreateClubScreen> {
  var clubName = TextEditingController();

  var clubBio = TextEditingController();

  var location = TextEditingController();

  var category = TextEditingController();

  Color _orangeColor = Color(0xFFFF8050);
  late String currUserId;

  int indexPubOrPriv = 1;
  _CreateClubScreenState(currUserId){
    this.currUserId = currUserId;
  }
  void submit(){
    Club club = Club();
    late String type;
    if (indexPubOrPriv==1){
      type = "Public";
    }
    else{
      type = "Private";
    }
    club.addClub(clubName.text, clubBio.text, location.text, category.text, type, [currUserId]).then((check)=>{
      if(check){
        Navigator.of(context).pop()
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: BackButton(
        onPressed: () => Navigator.of(context).pop(),
      color: _orangeColor),
          centerTitle: true,
          title: Text("Create a Club",
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
                  Image.asset('assets/ex1.jpeg',
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
                                hintText: "Club Name",
                                contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
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
                                hintText: "Add Club Bio",
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
                child: TextField(
                  controller: category,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
                    hintText: "Category",
                    contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                  ),
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
                  }
                },
              ),
            ]
          )
        ),
          Divider(),
          TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
              hintText: "Contact Info",
              contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
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
                    side: BorderSide.none
                )
            ),backgroundColor: MaterialStateProperty.all<Color>(_orangeColor)),
          ),
          Divider(),
          ElevatedButton(
            child: Text('Create Club'),
            onPressed: () {submit();},
            style: ButtonStyle(shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide.none,

                )
            ),backgroundColor: MaterialStateProperty.all<Color>(_orangeColor))
          ),

        ],
      )

    ),
    );
  }
}

