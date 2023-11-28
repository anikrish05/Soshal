import 'package:flutter/material.dart';

class ProfileHeaderWidget extends StatefulWidget {
  late String _image;
  late String _name; // Added _name
  late int _graduationYear; // Added _graduationYear
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
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipOval(
          child: Material(
            color: Colors.transparent,
            child: Ink.image(
              image: AssetImage(_image),
              fit: BoxFit.cover,
              width: 128,
              height: 128,
              child: InkWell(onTap: _onClicked),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: buildEditIcon(Colors.orange),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          child: buildProfileInfo(),
        ),
      ],
    );
  }

  Widget buildEditIcon(Color color) => buildCircle(
    color: Colors.white,
    all: 3,
    child: buildCircle(
      color: color,
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
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _name,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Class of $_graduationYear',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }


}
