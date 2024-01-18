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
  final double imageSize;

  ProfileHeaderWidget({
    required this.image,
    required this.onClicked,
    required this.name,
    required this.graduationYear,
    required this.imageSize,
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
        Expanded(
          child: Stack(
            children: [
              // Profile Picture with Edit Icon
              Container(
                width: widget.imageSize, // Use imageSize for width
                height: widget.imageSize, // Use imageSize for height
                margin: widget.image is String && widget.image.startsWith('asset')
                    ? EdgeInsets.fromLTRB(0, 0, 10, 0)
                    : EdgeInsets.fromLTRB(30, 20, 20, 20),
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
                left: widget.imageSize + 40, // Adjust left position based on imageSize
                top: widget.imageSize / 4, // Adjust top position based on imageSize
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
    final int maxCharacters = 50; // Set the maximum number of characters before forcing wrap
    final double increasedPadding = 10.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Align(
          alignment: widget.name.length > maxCharacters ? Alignment.topCenter : Alignment.topLeft,
          // Align text to the top left by default, or top center if it exceeds character limit
          child: Container(
            width: 200, // Set a specific width for the text container
            child: Text(
              widget.name.length > maxCharacters
                  ? '${widget.name.substring(0, maxCharacters)}...' // Truncate text and add '...'
                  : widget.name,
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w800,
                fontSize: 28,
              ),
              overflow: TextOverflow.ellipsis, // Prevent text overflow by fading
              maxLines: 2, // Set the maximum number of lines
            ),
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
        SizedBox(height: widget.name.length > maxCharacters ? increasedPadding : 0), // Adds more space if necessary
      ],
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
