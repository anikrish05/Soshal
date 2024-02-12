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
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0),
          ),
          color: Colors.orange,
          child: ListTile(
            contentPadding: EdgeInsets.all(0), // Removes default padding
            title: Row(
              children: [
                CircleAvatar(
                  radius: 25, // Increased radius
                  backgroundColor: Colors.grey, // Set background color to gray
                  child: _buildProfileImage(),
                ),
                SizedBox(width: 20), // Increased spacing between the image and text
                Text(
                  '${user.displayName}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18, // Increased font size
                    color: Colors.black, // Set text color to gray
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }
}




