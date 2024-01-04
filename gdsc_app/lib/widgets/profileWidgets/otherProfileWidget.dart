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

  Widget _buildProfileImage() {
    Widget profileImage;

    if (widget.user.downloadURL.isEmpty) {
      profileImage = Image.asset(
        'assets/emptyprofileimage-PhotoRoom.png-PhotoRoom.png',
        width: 40,
        height: 40,
        fit: BoxFit.cover,
      );
    } else {
      profileImage = Image.network(
        widget.user.downloadURL,
        width: 40,
        height: 40,
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
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          _buildProfileImage(),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '${widget.user.displayName}:',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
