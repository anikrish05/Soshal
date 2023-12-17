import 'package:gdsc_app/classes/userData.dart';

class Comment {
  final String comment;
  final UserData user;
  final List<dynamic> likedBy;
  Comment({required this.comment, required this.user, required this.likedBy});
}