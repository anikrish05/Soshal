import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class SlidingUpWidget extends StatefulWidget {
  @override
  _SlidingUpWidgetState createState() => _SlidingUpWidgetState();
}

class _SlidingUpWidgetState extends State<SlidingUpWidget> {
  @override
  Widget build(BuildContext context) {
    return  SlidingUpPanel(
        panel: Center(
          child: Text("This is the sliding Widget"),
        ),
        minHeight: 0,
        body: Center(
          child: Text("This is the Widget behind the sliding panel"),
        ),
      );
  }
}
