import 'package:flutter/material.dart';

class ClubCardWidget extends StatelessWidget {

  Color _cardColor = Color(0xffc8c9ca);

  // Define the image dimensions
  final double imageWidth = 120;  // Increased the width
  final double imageHeight = 100;  // Increased the height

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.2,  // Reduced the height here
        width: MediaQuery.of(context).size.width * 0.58,  // Adjust the width here
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
                      child: Image.network('https://tech4good.soe.ucsc.edu/assets/img/smile-small.png', fit: BoxFit.contain), // Changed BoxFit.cover to BoxFit.contain
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(  // Wrap the Column widget with an Expanded widget
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Tech4Good Labs', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), // Increased the font size
                        SizedBox(height: 8), // Add more spacing vertically
                        Flexible(  // Wrap the Row widget with a Flexible widget
                          child: Row(
                            children: [
                              SizedBox(width: 4), // Reduced the width to move the stars to the left
                              Row(
                                children: List.generate(5, (index) => Icon(Icons.star, color: Colors.yellow, size: 12)), // Make the stars smaller
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
    );
  }
}
