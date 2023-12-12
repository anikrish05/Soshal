class ClubCardData {
  List<String> admin;
  String category;
  String description;
  String downloadURL;
  List<String> events;
  List<String> followers; // Updated to List<String>
  String name;
  String type;
  bool verified;

  ClubCardData({
    required this.admin,
    required this.category,
    required this.description,
    required this.downloadURL,
    required this.events,
    required this.followers,
    required this.name,
    required this.type,
    required this.verified,
  });
}
