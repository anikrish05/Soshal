import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../classes/userData.dart';

Color _colorTab = Color(0xFFFF8050);

class UserRequest extends StatefulWidget {
  final UserData user;
  final String timestamp;
  UserRequest({required this.user, required this.timestamp});
  @override
  State<UserRequest> createState() => _UserRequestState();
}

class _UserRequestState extends State<UserRequest> {
  String time = "";

  @override
  void initState() {
    int timestampInMilliseconds = int.parse(widget.timestamp);
    DateTime nodeDateTime = DateTime.fromMillisecondsSinceEpoch(timestampInMilliseconds);
    DateTime currentDateTime = DateTime.now();
    Duration difference = currentDateTime.difference(nodeDateTime);

    if (difference.inDays > 0) {
      setState(() {
        time = "${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago";
      });
    } else if (difference.inHours > 0) {
      setState(() {
        time = "${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago";
      });
    } else {
      setState(() {
        time = "${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago";
      });
    }
    super.initState();
  }

  Widget _buildProfileImage() {
    Widget profileImage;

    if (widget.user.downloadURL.isEmpty) {
      profileImage = Image.asset(
        'assets/emptyprofileimage-PhotoRoom.png-PhotoRoom.png',
        width: 70,
        height: 70,
        fit: BoxFit.cover,
      );
    } else {
      profileImage = Image.network(
        widget.user.downloadURL,
        width: 70,
        height: 70,
        fit: BoxFit.cover,
      );
    }

    return ClipOval(
      child: profileImage,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: ListTile(
          leading: _buildProfileImage(),
          title: RichText(
            text: TextSpan(
              style: DefaultTextStyle.of(context).style,
              children: <TextSpan>[
                TextSpan(text: "${widget.user.displayName}", style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: ' has requested to follow you'),
              ],
            ),
          ),
          subtitle: Text(time),
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
