import 'package:flutter/material.dart';

class ProfileHeaderWidget extends StatefulWidget {
  late String _image;
  late VoidCallback _onClicked;
  ProfileHeaderWidget(String image, VoidCallback onClicked){
    this._image = image;
    this._onClicked = onClicked;
  }
  @override
  _ProfileHeaderWidgetState createState() => _ProfileHeaderWidgetState(_image, _onClicked);
}

class _ProfileHeaderWidgetState extends State<ProfileHeaderWidget> {
  late String _image;
  late VoidCallback _onClicked;
  _ProfileHeaderWidgetState(String _image, VoidCallback _onClicked){
    this._image = _image;
    this._onClicked = _onClicked;
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
          )
        ),
        Positioned(
          bottom: 0,
            right: 0,
            child: buildEditIcon(Colors.orange)),
      ]
    );
    return Scaffold(
      child: Container(
        padding: const EdgeInsets.all(tDefaultSize),
        child: Column(
          children: [
            SizedBox(
              width: 120, height: 120,
            )
          ]
        )
      )
    )
  }

  Widget buildEditIcon(Color color) => buildCircle(
    color: Colors.white,
    all: 3,
    child: buildCircle(
      color: color,
      all:8,
      child:   Icon(
        Icons.edit,
        color: Colors.white,
        size: 20,
      ),
    ),
  );
  Widget buildCircle({
  required Widget child,
    required double all,
    required Color color
}) =>ClipOval(
    child:   Container(
      padding: EdgeInsets.all(all),
      color: color,
      child: child
    ),
);



}
