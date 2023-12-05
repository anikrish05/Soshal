import 'package:flutter/material.dart';
import 'package:gdsc_app/classes/club.dart';

class ClubProfilePage extends StatefulWidget {
  late Club club;
  ClubProfilePage(Club club){
    this.club = club;
  }

  @override
  _ClubProfilePageState createState() =>
      _ClubProfilePageState(this.club);
}

class _ClubProfilePageState extends State<ClubProfilePage> {
  late Club club;
  _ClubProfilePageState(Club club){
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
            child: Image.asset(
              club.downloadURL, // Use Image.asset for assets
              fit: BoxFit.cover,
            ),
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
}

