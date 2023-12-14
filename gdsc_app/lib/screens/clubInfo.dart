import 'package:flutter/material.dart';
import 'package:gdsc_app/classes/club.dart';
import 'package:gdsc_app/classes/ClubCardData.dart';

class ClubProfilePage extends StatefulWidget {
  late ClubCardData club;
  ClubProfilePage(ClubCardData club){
    this.club = club;
  }

  @override
  _ClubProfilePageState createState() =>
      _ClubProfilePageState(this.club);
}

class _ClubProfilePageState extends State<ClubProfilePage> {
  late ClubCardData club;
  _ClubProfilePageState(ClubCardData club){
    this.club = club;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(club.name),
      ),
      body: ListView(
        children: [
          SizedBox(
            height: 200, // Adjust the height of the image container
            child: imageBuild(),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'About ${club.name}',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  // Add club description or information here
                  'Bridging the gap from the classroom to the workplace.',
                  style: TextStyle(fontSize: 16),
                ),
                // Add more details or widgets as needed
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget imageBuild() {
    if (club.downloadURL != "") {
      return Image.network(club.downloadURL, fit: BoxFit.cover);
    } else {
      return Image.network('https://cdn.shopify.com/s/files/1/0982/0722/files/6-1-2016_5-49-53_PM_1024x1024.jpg?7174960393118038727', fit: BoxFit.cover);
    }
  }
}

