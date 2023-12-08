import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:gdsc_app/classes/MarkerData.dart';

class SlidingUpWidget extends StatelessWidget {
  final MarkerData markerData;

  // Corrected constructor definition
  SlidingUpWidget({required this.markerData});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            markerData.title,
            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16.0),
          Text(
            'This is the sliding panel content.',
            style: TextStyle(fontSize: 16.0),
          ),
        ],
      ),
    );
  }
}
