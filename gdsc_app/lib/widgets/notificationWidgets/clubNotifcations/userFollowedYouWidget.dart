import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../classes/userData.dart';

class UserFollowing extends StatefulWidget {
  final UserData user;
  final int timestamp;
  UserFollowing({required this.user, required this.timestamp});

  @override
  State<UserFollowing> createState() => _UserFollowingState();
}

class _UserFollowingState extends State<UserFollowing> {
  String time = "";

  @override
  void initState() {
    int timestampInMilliseconds = widget.timestamp;
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
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 18.0), // Adjusted padding
          leading: _buildProfileImage(),
          title: RichText(
            text: TextSpan(
              style: DefaultTextStyle.of(context).style,
              children: <TextSpan>[
                TextSpan(text: '${widget.user.displayName}', style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: ' started following you'),
              ],
            ),
          ),
          subtitle: Text(time),
        ),
      ),
    );
  }
}
