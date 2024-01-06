import 'package:flutter/material.dart';
import 'package:gdsc_app/classes/userData.dart';

class rsvpCard extends StatelessWidget {
  final UserData user;

  rsvpCard({required this.user});

  @override
  Widget build(BuildContext context) {
    return _rsvpCard(user: user);
  }
}

class _rsvpCard extends StatelessWidget {
  final UserData user;

  _rsvpCard({required this.user});

  Widget _buildProfileImage() {
    Widget profileImage;

    if (user.downloadURL.isEmpty) {
      profileImage = Image.asset(
        'assets/emptyprofileimage-PhotoRoom.png-PhotoRoom.png',
        width: 40,
        height: 40,
        fit: BoxFit.cover,
      );
    } else {
      profileImage = Image.network(
        user.downloadURL,
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
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
          contentPadding: EdgeInsets.all(0), // Removes default padding
          title: Row(
            children: [
              CircleAvatar(
                radius: 20,
                child: _buildProfileImage(),
              ),
              SizedBox(width: 8), // Add some spacing between the image and text
              Text(
                '${user.displayName}:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
