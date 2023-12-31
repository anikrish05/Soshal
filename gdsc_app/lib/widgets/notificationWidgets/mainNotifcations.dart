import 'package:flutter/material.dart';
import 'package:gdsc_app/widgets/notificationWidgets/clubNotifcations/notifcationsForClubs.dart';
import 'package:gdsc_app/widgets/notificationWidgets/userNotifcations/notifcationsForUsers.dart';

class NotificationsPage extends StatefulWidget {
  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final Color _colorTab = Color(0xFFFF8050);
  final Color _colorHighlight = Color(0xFF000000); // Black color for the text
  final Color _colorUnderline = Color(0xFFD3D3D3); // Grey color for the underline

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
        backgroundColor: _colorTab,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTitle('New Activity'),
              UserRequest(),
              ClubReject(),
              SizedBox(height: 16.0),
              _buildTitle('Old Activity'),
              UserRequest(),
              ClubInvite(),
              UserRequest(),
              ClubEvent(),
              UserFollowing(),
              UserReject(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(String title) {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: _colorUnderline)),
      ),
      child: Text(
        title,
        style: TextStyle(color: _colorHighlight, fontSize: 24.0, fontWeight: FontWeight.bold),
      ),
    );
  }
}
