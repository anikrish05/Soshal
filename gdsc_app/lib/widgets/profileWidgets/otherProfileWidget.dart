import 'package:flutter/material.dart';
import '../../classes/userData.dart';

class OtherProfileWidget extends StatefulWidget {
  final UserData user;
  OtherProfileWidget({required this.user});

  @override
  State<OtherProfileWidget> createState() => _OtherProfileWidgetState();
}

class _OtherProfileWidgetState extends State<OtherProfileWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(widget.user.downloadURL),
          ),
          SizedBox(width: 8),
          Text(widget.user.displayName),
        ],
      ),
    );
  }
}
