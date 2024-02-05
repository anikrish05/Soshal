import 'package:flutter/material.dart';
import 'package:gdsc_app/widgets/notificationWidgets/mainNotifcations.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(65);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 1,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.asset(
            'assets/image.png',
            fit: BoxFit.fitWidth,
            height: 150,
            width: 150,
          ),
        ],
      ),
      automaticallyImplyLeading: false,
      actions: [
        IconButton(
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
