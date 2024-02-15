import 'package:flutter/material.dart';
import 'package:gdsc_app/classes/userData.dart';

class RsvpCard extends StatelessWidget {
  final UserData user;

  RsvpCard({required this.user});

  @override
  Widget build(BuildContext context) {
    print("JEDHJHKEWQHFKJEhfKJHEWKJFHEWJKhfJKEWfhejkw");
    return _RsvpCard(user: user);
  }
}

class _RsvpCard extends StatelessWidget {
  final UserData user;

  _RsvpCard({required this.user});

  Widget _buildProfileImage() {
    Widget profileImage;

    if (user.downloadURL.isEmpty) {
      profileImage = Image.asset(
        'assets/emptyprofileimage-PhotoRoom.png-PhotoRoom.png',
        width: 60, // Increased width
        height: 60, // Increased height
        fit: BoxFit.cover,
      );
    } else {
      profileImage = Image.network(
        user.downloadURL,
        width: 60, // Increased width
        height: 60, // Increased height
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
          side: BorderSide(color: Colors.orange, width: 2.0), // Set border color and width
        ),
        child: ListTile(
          leading: CircleAvatar(
            radius: 25, // Increased radius
            backgroundColor: Colors.white, // Set background color to white
            child: _buildProfileImage(),
          ),
          title: Text(
            '${user.displayName}', // Keep the same text
            style: TextStyle(
              fontWeight: FontWeight.bold, // Keep the same style
              color: _orangeColor, // Set text color to orange
            ),
          ),
        ),
      ),
    );
  }
}




