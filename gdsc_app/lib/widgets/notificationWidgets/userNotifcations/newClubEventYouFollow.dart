import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../classes/userData.dart';
class ClubEvent extends StatefulWidget {
  @override
  State<ClubEvent> createState() => _ClubEventState();
}

class _ClubEventState extends State<ClubEvent> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
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
                TextSpan(text: 'Club Name', style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: ' posted a new event: '),
                TextSpan(text: 'Friday Science Mixer'),
              ],
            ),
          ),
          subtitle: Text('4h ago'),
        ),
      ),
    );
  }
}