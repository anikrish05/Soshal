import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfileHeaderWidget extends StatefulWidget {
  final dynamic image;
  final String name;
  final int graduationYear;
  final VoidCallback onClicked;

  ProfileHeaderWidget({
    required this.image,
    required this.onClicked,
    required this.name,
    required this.graduationYear,
    Key? key,
  }) : super(key: key);

  @override
  _ProfileHeaderWidgetState createState() => _ProfileHeaderWidgetState();
}

class _ProfileHeaderWidgetState extends State<ProfileHeaderWidget> {
  late ImageProvider<Object> _image;

  @override
  void initState() {
    super.initState();
    _image = _getImageProvider(widget.image);
  }

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
                  image: _image,
                  fit: BoxFit.cover,
                  width: 128,
                  height: 128,
                  child: InkWell(onTap: widget.onClicked),
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

  Widget buildEditIcon(Color color) => buildCircle(
    color: Colors.white,
    all: 3,
    child: buildCircle(
      color: Colors.orange,
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

  // Add this method to update the image dynamically
  void updateImage(dynamic newImage) {
    setState(() {
      _image = _getImageProvider(newImage);
    });
  }

  // Helper method to get the appropriate ImageProvider based on the image type
  ImageProvider<Object> _getImageProvider(dynamic image) {
    if (image is String && image.startsWith('http')) {
      // Network image
      return NetworkImage(image);
    } else if (image is String && image.startsWith('assets')) {
      // Asset image
      return AssetImage(image);
    } else if (image is String) {
      // File image
      return FileImage(File(image));
    } else {
      // Default fallback image (you may change this)
      return AssetImage('assets/default_image.png');
    }
  }
}
