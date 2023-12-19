import 'package:gdsc_app/classes/user.dart';

class MarkerData {
  final String title;
  final String description;
  final String location;
  final String time;
  final String image;
  final List<dynamic> comments;
  final String eventID;
  final User user;
  double rating;

  MarkerData({required this.title, required this.description, required this.location, required this.time, required this.image, required this.comments, required this.eventID, required this.user, required this.rating});
}