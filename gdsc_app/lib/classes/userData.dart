class UserData {
  final String uid;
  final String displayName;
  final String email;
  final List<String> following;
  final String role;
  final List<String> myEvents;
  final List<String> clubIds;


  UserData({required this.uid, required this.displayName, required this.email, required this.following,
    required this.role, required this.myEvents, required this.clubIds
  });
}