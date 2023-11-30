import 'package:flutter/material.dart';

class CreateCardWidget extends StatelessWidget {
  late VoidCallback onCreateEvent;
  late VoidCallback onCreateClub;
  Color _cardColor = Color(0xffc8c9ca);

  // Define the image dimensions
  final double imageWidth = 100;
  final double imageHeight = 80;

  CreateCardWidget({
    required this.onCreateEvent,
    required this.onCreateClub,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Card(
        color: _cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // Set the border radius
        ),
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          splashColor: Colors.blueGrey.withAlpha(30),
          onTap: onCreateEvent,
          child: Padding(
            padding: const EdgeInsets.all(8.0), // Add padding to the card
            child: Row(
              children: [
                Container(
                  width: imageWidth,
                  height: imageHeight,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network('https://cdn.shopify.com/s/files/1/0982/0722/files/6-1-2016_5-49-53_PM_1024x1024.jpg?7174960393118038727', fit: BoxFit.cover), // Replace 'IMAGE_URL' with your image url
                  ),
                ),
                SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Title Header', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)), // Replace 'Title Header' with your title
                    Text('By: '), // Replace 'Club Name' with your club name
                    Text('Location'), // Replace 'Location' with your location
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
