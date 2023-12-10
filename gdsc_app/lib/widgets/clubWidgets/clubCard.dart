import 'package:flutter/material.dart';

class ClubCardWidget extends StatelessWidget {

  Color _cardColor = Color(0xffc8c9ca);
  double _rating = 1.0;  // Example rating

  @override
  Widget build(BuildContext context) {
    // Get the screen width
    double screenWidth = MediaQuery.of(context).size.width;

    // Define the image dimensions based on the screen width
    final double imageWidth = screenWidth * 0.2;  // Adjust the width
    final double imageHeight = screenWidth * 0.22;  // Adjust the height

    return SingleChildScrollView(
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          height: screenWidth * 0.25,  // Adjust the height based on the screen width
          width: screenWidth * 0.50,  // Adjust the width based on the screen width
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
                        child: Image.asset('assets/tech4goodimage.png', fit: BoxFit.contain), // Changed Image.network to Image.asset
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(  // Wrap the Column widget with an Expanded widget
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Tech4 Good Labs', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), // Increased the font size
                          SizedBox(height: 20), // Add more spacing vertically
                          Flexible(  // Wrap the Row widget with a Flexible widget
                            child: Row(
                              children: [
                                SizedBox(width: 14), // Reduced the width to move the stars to the left
                                Row(
                                  children: List.generate(5, (index) {
                                    return Icon(
                                      index < _rating ? Icons.star : Icons.star_border,
                                      color: Colors.yellow,
                                      size: 12,
                                    );
                                  }), // Make the stars dynamic
                                ),
                              ],
                            ),
                          ),
                          // Removed the other widgets
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}