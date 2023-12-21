class UserData {
  final String uid;
  String displayName;
  final String email;
  final List<String> following;
  final String role;
  final String downloadURL;
  final List<String> myEvents;
  final List<String> clubIds;
  int classOf;


  UserData({required this.uid, required this.displayName, required this.email, required this.following,
    required this.role, required this.myEvents, required this.clubIds, required this.downloadURL, required this.classOf
  });
}