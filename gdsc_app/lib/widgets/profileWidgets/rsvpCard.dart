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
  Color _orangeColor = Color(0xFFFF8050);


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
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
          side: BorderSide(color: Colors.orange, width: 2.0),
        ),
        child: ListTile(
          contentPadding: EdgeInsets.all(12.0),
          leading: CircleAvatar(
            radius: 30,
            backgroundColor: _orangeColor,
            child: _buildProfileImage(),
          ),
          title: Text(
            '${user.displayName}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
              color: Colors.black87,
            ),
          ),
          subtitle: Text(
            '${user.classOf}',
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.black87,
            ),
          ),
        ),
      ),
    );
  }
}




