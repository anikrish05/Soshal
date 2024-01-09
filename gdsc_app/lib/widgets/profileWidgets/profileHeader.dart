import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

// Define the color as a global variable
Color _orangeColor = Color(0xFFFF8050);

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
    // Get the screen width
    double screenWidth = MediaQuery.of(context).size.width;

    // Calculate the image size as a fraction of the screen width
    double imageSize = screenWidth * 0.3; // Adjust the fraction as needed

    return Row(
      children: [
        Expanded(
          child: Stack(
            children: [
              // Profile Picture with Edit Icon
              Container(
                width: imageSize,
                height: imageSize,
                margin: EdgeInsets.fromLTRB(10, 20, 20, 20), // Adjust left margin as needed
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    fit: BoxFit.cover, // Use BoxFit.cover for all images
                    image: _image,
                  ),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: widget.onClicked,
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: buildEditIcon(_orangeColor),
                    ),
                  ),
                ),
              ),

              // Profile Info Positioned Relative to Profile Picture
              Positioned(
                left: imageSize + 20, // Position info relative to image size
                top: 50, // Adjust top position as needed
                child: buildProfileInfo(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildEditIcon(Color color) => Padding(
    padding: widget.image is String && widget.image.startsWith('asset') ? EdgeInsets.fromLTRB(0, 0, 25, 25): EdgeInsets.all(0),
    child: buildCircle(
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
    double maxWidth = MediaQuery.of(context).size.width - 50; // Adjust the value as needed

    return Padding(
      padding: EdgeInsets.fromLTRB(0,0,0,0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: maxWidth,
            child: Text(
              widget.name,
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w800,
                fontSize: 30,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
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
      ),
    );
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
