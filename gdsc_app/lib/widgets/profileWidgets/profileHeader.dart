import 'package:flutter/material.dart';
import 'dart:io';

class ProfileHeaderWidget extends StatefulWidget {
  final dynamic image;
  final VoidCallback onClicked;
  final String name;
  final int graduationYear;
  final VoidCallback onImagePicked;

  ProfileHeaderWidget({
    required this.image,
    required this.onClicked,
    required this.name,
    required this.graduationYear,
    required this.onImagePicked,
  });

  @override
  _ProfileHeaderWidgetState createState() => _ProfileHeaderWidgetState();
}

class _ProfileHeaderWidgetState extends State<ProfileHeaderWidget> {
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
                  image: getImageProvider(),
                  fit: BoxFit.cover,
                  width: 128,
                  height: 128,
                  child: InkWell(onTap: () async {
                    widget.onClicked();
                    await Future.delayed(Duration.zero); // Schedule the callback to happen after the frame
                    widget.onImagePicked(); // Trigger the callback
                  }),
                ),
              ),
            ),
            Positioned(
              bottom: 8,
              right: 8,
              child: buildEditIcon(Colors.orange),
            ),
          ],
        ),
        SizedBox(width: 16),
        buildProfileInfo(),
      ],
    );
  }

  ImageProvider<Object> getImageProvider() {
    if (widget.image is File) {
      return FileImage(widget.image as File);
    } else if (widget.image is String) {
      return NetworkImage(widget.image as String);
    } else {
      return AssetImage('assets/emptyprofileimage.jpg');
    }
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
          widget.name,
          style: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.w800,
            fontSize: 24,
          ),
        ),
        SizedBox(height: 4),
        Text(
          'Class of ${widget.graduationYear}',
          style: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.w400,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
