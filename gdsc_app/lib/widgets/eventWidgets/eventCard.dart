import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class EventCardWidget extends StatelessWidget {

  Color _cardColor = Color(0xffc8c9ca);


  @override
  Widget build(BuildContext context) {
    final double imageWidth = MediaQuery.of(context).size.width * 0.25;
    final double imageHeight = MediaQuery.of(context).size.height * 0.15;
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
                          RatingBar.builder(
                            initialRating: 3,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {
                              print(rating);
                            }, // Make the stars smaller
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
