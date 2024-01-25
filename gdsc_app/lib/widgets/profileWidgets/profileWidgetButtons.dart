import 'package:flutter/material.dart';

class CreateButtonsWidget extends StatelessWidget {
  late VoidCallback onUpdateProfile;
  late VoidCallback onCreateClub;

  CreateButtonsWidget(VoidCallback onUpdateProfile, VoidCallback onCreateClub){
    this.onUpdateProfile = onUpdateProfile;
    this.onCreateClub = onCreateClub;
  }
  Color _buttonColor = Color(0xFF88898C);
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: onUpdateProfile,
            style: ElevatedButton.styleFrom(
              primary: _buttonColor, // Set the button color to gray
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50), // Set the border radius
              ),
            ),
            child: Text(' Edit Profile '),
          ),
          SizedBox(width: 16),
          ElevatedButton(
            onPressed: onCreateClub,
            style: ElevatedButton.styleFrom(
              primary: _buttonColor, // Set the button color to gray
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
            ),
            child: Text('Create Club'),
          ),
        ],
      ),
    );
  }
}