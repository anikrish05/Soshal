import 'package:flutter/material.dart';
import '../../classes/User.dart';
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
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            for (User user in widget.user.users)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(user.downloadURL),
                    ),
                    SizedBox(height: 8),
                    Text(user.displayName),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
