import 'package:gdsc_app/classes/ClubCardData.dart';

class EventCardData {
  List<String> rsvpList;
  String name;
  String description;
  String downloadURL;
  double latitude;
  double longitude;
  double rating;
  List<String> comments;
  String id;
  List<String> admin;
  List<ClubCardData> clubInfo;

  EventCardData({
    required this.rsvpList,
    required this.name,
    required this.description,
    required this.downloadURL,
    required this.latitude,
    required this.longitude,
    required this.rating,
    required this.comments,
    required this.id,
    required this.admin,
    required this.clubInfo
  });
}
