import 'package:flutter/material.dart';

class CreateCardWidget extends StatelessWidget {

  Color _cardColor = Color(0xffc8c9ca);

  // Define the image dimensions
  final double imageWidth = 100;
  final double imageHeight = 80;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.89, // Adjust the width here
        child: Card(
          color: _cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20), // Set the border radius
          ),
          clipBehavior: Clip.hardEdge,
          child: InkWell(
            splashColor: Colors.blueGrey.withAlpha(30),
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
                      Text('Eventx', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)), // Replace 'Title Header' with your title
                      SizedBox(height: 8), // Add more spacing vertically
                      Row(
                        children: [
                          Text('By: '), // Replace 'Club Name' with your club name
                          SizedBox(width: 8), // Add more space between the "By:" text and stars
                          Row(
                            children: List.generate(5, (index) => Icon(Icons.star, color: Colors.yellow, size: 16)), // Make the stars smaller
                          ),
                        ],
                      ),
                      SizedBox(height: 8), // Add more spacing vertically
                      Row(
                        children: [
                          Icon(Icons.location_on), // Add a location icon
                          Text('X-Location'), // Replace 'Location' with your location
                        ],
                      ),
                      SizedBox(height: 8), // Add more spacing vertically
                      Row(
                        children: [
                          Icon(Icons.access_time), // Add a clock icon
                          Text('Event Time'), // Replace 'Event Time' with your event time
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
