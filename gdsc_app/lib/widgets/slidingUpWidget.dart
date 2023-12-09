import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:gdsc_app/classes/MarkerData.dart';

class SlidingUpWidget extends StatelessWidget {
  final MarkerData markerData;

  // Corrected constructor definition
  SlidingUpWidget({required this.markerData});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        width: MediaQuery.of(context).size.width * 1.0,
        child: Column(
          children: [
            // Rounded gray bar at the top
            Padding(
              padding: EdgeInsets.only(top: 12), // Adjust the top padding
              child: Container(
                height: 4, // Adjust the height of the gray bar
                width: 100, // Adjust the width of the gray bar
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(10), // Adjust the border radius
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 12), // Adjust the right margin for more space
                    width: 125,
                    height: 125, // Set a fixed height for the image container
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        'https://cdn.shopify.com/s/files/1/0982/0722/files/6-1-2016_5-49-53_PM_1024x1024.jpg?7174960393118038727',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Text(
                              markerData.title,
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            Text(
                              markerData.description,
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Text("By: Adithya "),
                            SizedBox(width: 8),
                            Row(
                              children: List.generate(
                                5,
                                    (index) => Padding(
                                  padding: EdgeInsets.only(right: 4), // Adjust spacing between icons
                                  child: Icon(Icons.star, color: Colors.grey, size: 16),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.location_on),
                            Padding(padding: EdgeInsets.only(right: 4)),
                            Text(markerData.location),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.access_time),
                            Padding(padding: EdgeInsets.only(right: 4)),
                            Text(markerData.time),
                          ],
                        ),
                        SizedBox(height: 8),
                        // Elevated button with rounded edges and #d1d1d1 color
                        Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            margin: EdgeInsets.only(bottom: 2, right: 40), // Adjust top and left margins
                            child: ElevatedButton(
                              onPressed: () {
                                // Add RSVP button logic
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Colors.grey, // Set the button color to #d1d1d1
                                textStyle: TextStyle(
                                  fontFamily: 'Borel',
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold, // Change the font to Borel
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20), // Round the edges
                                ),
                              ),
                              child: Text('rsvp'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              color: Colors.grey,
              thickness: 1,
              indent: 50,
              endIndent: 50,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 40, left: 40),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  height: 40, // Adjust the height of the text box
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'add comments',
                      filled: true,
                      fillColor: Colors.grey, // Set the box color to gray
                      hintStyle: TextStyle(
                        fontFamily: 'Borel',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // Make the hint text white
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 1, horizontal: 10), // Center the hint text both vertically and horizontally
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent), // Remove the outline when focused
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent), // Remove the outline when enabled
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
