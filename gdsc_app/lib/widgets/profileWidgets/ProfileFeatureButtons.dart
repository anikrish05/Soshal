import 'package:flutter/material.dart';

class ProfileFeatureButtons extends StatefulWidget {
  @override
  _ProfileFeatureButtonsState createState() => _ProfileFeatureButtonsState();
}

class _ProfileFeatureButtonsState extends State<ProfileFeatureButtons> {
  // Track the pressed state of each button
  bool eventsAttendingPressed = false;
  bool clubsPressed = false;
  bool savedPressed = false;

  Color _buttonColor = Color(0xFF88898C);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {
            // Add logic for "Events Attending" button press
            setState(() {
              eventsAttendingPressed = true;
              clubsPressed = false;
              savedPressed = false;
            });
            print('Events Attending button pressed');
          },
          style: ElevatedButton.styleFrom(
            primary: eventsAttendingPressed ? Colors.orange : _buttonColor,
          ),
          child: Text('Events Attending'),
        ),
        SizedBox(width: 16),
        ElevatedButton(
          onPressed: () {
            // Add logic for "Clubs" button press
            setState(() {
              eventsAttendingPressed = false;
              clubsPressed = true;
              savedPressed = false;
            });
            print('Clubs button pressed');
          },
          style: ElevatedButton.styleFrom(
            primary: clubsPressed ? Colors.orange : _buttonColor,
          ),
          child: Text('Clubs'),
        ),
        SizedBox(width: 16),
        ElevatedButton(
          onPressed: () {
            // Add logic for "Saved" button press
            setState(() {
              eventsAttendingPressed = false;
              clubsPressed = false;
              savedPressed = true;
            });
            print('Saved button pressed');
          },
          style: ElevatedButton.styleFrom(
            primary: savedPressed ? Colors.orange : _buttonColor,
          ),
          child: Text('Saved'),
        ),
      ],
    );
  }
}
