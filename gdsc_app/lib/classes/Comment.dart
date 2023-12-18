import 'package:gdsc_app/classes/userData.dart';

class Comment {
  final String comment;
  final List<String> likedBy;
  final UserData user; // Updated to use UserData class

  Comment({
    required this.user,
    required this.comment,
    required this.likedBy,
  });
}
