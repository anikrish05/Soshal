class EventCardData {
  List<String> rsvpList;
  String name;
  String description;
  String downloadURL;
  double latitude;
  double longitude;
  double rating;
  Map<String, String> comments;
  String id;

  EventCardData({
    required this.rsvpList,
    required this.name,
    required this.description,
    required this.downloadURL,
    required this.latitude,
    required this.longitude,
    required this.rating,
    required this.comments,
    required this.id
  });
}
