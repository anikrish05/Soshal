import 'package:flutter/material.dart';
import 'package:gdsc_app/widgets/notificationWidgets/mainNotifcations.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(70);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 1,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding( // Add padding to the top of the image
            padding: EdgeInsets.only(top: 11.0), // Adjust this value as needed
            child: Image.asset(
              'assets/image.png',
              fit: BoxFit.fitWidth,
              height: 150,
              width: 150,
            ),
          ),
        ],
      ),
      automaticallyImplyLeading: false,
      actions: [
        Padding( // Add padding to the right of the icon
          padding: EdgeInsets.only(right: 19.0), // Adjust this value as needed
          child: IconButton(
            icon: Icon(
              Icons.notifications,
              size: 50,
              color: Colors.grey[500],
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationsPage()),
              );
            },
          ),
        ),
      ],
    );
  }


  void _showSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Settings"),
          // Add your settings content here
          content: Text("Add your settings content here"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Close"),
            ),
          ],
        );
      },
    );
  }
}

