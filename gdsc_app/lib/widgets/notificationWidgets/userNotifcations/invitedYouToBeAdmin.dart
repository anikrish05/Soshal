import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../classes/userData.dart';
Color _colorTab = Color(0xFFFF8050);

class ClubInvite extends StatefulWidget {
  @override
  State<ClubInvite> createState() => _ClubInviteState();
}

class _ClubInviteState extends State<ClubInvite> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: ListTile(
          leading: Image.asset('assets/emptyprofileimage-PhotoRoom.png-PhotoRoom.png', width: 70.0, height: 70.0),
          title: RichText(
            text: TextSpan(
              style: DefaultTextStyle.of(context).style,
              children: <TextSpan>[
                TextSpan(text: 'Animesh Alang', style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: ' invited you to be an admin of Gesher Group Consulting'),
              ],
            ),
          ),
          subtitle: Text('4h ago'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextButton(
                child: Text('Accept', style: TextStyle(color: Colors.white, fontFamily: 'Borel')),
                style: TextButton.styleFrom(
                  backgroundColor: _colorTab,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                onPressed: () {/* Accept action */},
              ),
              SizedBox(width: 10),
              TextButton(
                child: Text('Reject', style: TextStyle(color: Colors.white, fontFamily: 'Borel')),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                onPressed: () {/* Reject action */},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
