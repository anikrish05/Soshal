import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
class SlidingUpWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hi',
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
