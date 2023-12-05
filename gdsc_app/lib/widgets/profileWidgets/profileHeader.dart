import 'package:flutter/material.dart';

class ProfileHeaderWidget extends StatefulWidget {
  late String _image;
  late String _name;
  late int _graduationYear;
  late VoidCallback _onClicked;

  ProfileHeaderWidget(String image, VoidCallback onClicked, String name, int graduationYear) {
    this._image = image;
    this._onClicked = onClicked;
    this._name = name;
    this._graduationYear = graduationYear;
  }

  @override
  _ProfileHeaderWidgetState createState() =>
      _ProfileHeaderWidgetState(_image, _name, _graduationYear, _onClicked);
}

class _ProfileHeaderWidgetState extends State<ProfileHeaderWidget> {
  late String _image;
  late String _name;
  late int _graduationYear;
  late VoidCallback _onClicked;

  _ProfileHeaderWidgetState(
      String image, String name, int graduationYear, VoidCallback onClicked) {
    this._image = image;
    this._name = name;
    this._graduationYear = graduationYear;
    this._onClicked = onClicked;
    print(this._onClicked);
  }
  Color _colorTab = Color(0xFFFF8050);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Stack(
          children: [
            ClipOval(
              child: Material(
                color: Colors.transparent,
                child: Ink.image(
                  image: AssetImage("assets/emptyprofileimage-PhotoRoom.png-PhotoRoom.png"),
                  fit: BoxFit.cover,
                  width: 128,
                  height: 128,
                  child: InkWell(onTap: _onClicked),
                ),
              ),
            ),
            Positioned(
              bottom: 8, // Adjust the distance from the bottom
              right: 8, // Adjust the distance from the right
              child: buildEditIcon(Colors.orange),
            ),
          ],
        ),
        SizedBox(width: 16), // Adjust the padding as needed
        buildProfileInfo(),
      ],
    );
  }

  Widget buildEditIcon(Color color) => buildCircle(
    color: Colors.white,
    all: 3,
    child: buildCircle(
      color: _colorTab,
      all: 8,
      child: Icon(
        Icons.edit,
        color: Colors.white,
        size: 20,
      ),
    ),
  );

  Widget buildCircle({
    required Widget child,
    required double all,
    required Color color,
  }) =>
      ClipOval(
        child: Container(
          padding: EdgeInsets.all(all),
          color: color,
          child: child,
        ),
      );

  Widget buildProfileInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          _name,
          style: TextStyle(
            color: Colors.grey, // Change font color to gray
            fontWeight: FontWeight.w800, // Change to a bold font
            fontSize: 24, // Make the top text bigger
          ),
        ),
        SizedBox(height: 4),
        Text(
          'Class of $_graduationYear',
          style: TextStyle(
            color: Colors.grey, // Change font color to gray
            fontWeight: FontWeight.w400, // Change to a regular font
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
