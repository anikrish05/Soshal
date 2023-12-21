import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:gdsc_app/classes/user.dart';

class CreateUserScreen extends StatefulWidget {
  final User user;
  CreateUserScreen({required this.user});
  @override
  _CreateUserScreenState createState() => _CreateUserScreenState();
}
// widget.user
class _CreateUserScreenState extends State<CreateUserScreen> {
  var newName = TextEditingController();
  var newGradYr = TextEditingController();

  final ButtonStyle style =
  ElevatedButton.styleFrom(
      backgroundColor: Colors.orange,
      shape: StadiumBorder(),
      textStyle: const TextStyle(fontFamily: 'Borel', fontSize: 30, color: Colors.grey ));
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
              RichText(
                text: TextSpan(
                  text: 'Change Name',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black.withOpacity(0.6),fontFamily: 'Borel', fontSize: 15),
                ),
              ),
              TextField(
                controller: newName,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
                  hintText: widget.user.displayName,
                  contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                ),
              ),
              Divider(),
              RichText(
                text: TextSpan(
                  text: 'Change Graduation Year',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black.withOpacity(0.6),fontFamily: 'Borel', fontSize: 15),
                ),
              ),
              TextField(
                controller: newGradYr,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
                  hintText: widget.user.classOf.toString(),
                  contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
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
    if (newName.text != null) {
      widget.user.displayName = newName.text;
    }
    if (newGradYr.text != null)
      {
        widget.user.classOf = int.parse(newGradYr.text);
      }
    Navigator.pop(context);
  }
}

