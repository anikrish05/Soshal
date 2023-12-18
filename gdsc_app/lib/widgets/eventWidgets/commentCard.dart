import 'package:flutter/material.dart';
import 'package:gdsc_app/classes/Comment.dart';

class CommentCard extends StatefulWidget {
  final Comment comment; // Define a variable to hold the comment object

  // Constructor that takes a Comment parameter
  CommentCard({required this.comment});

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('assets/emptyprofileimage-PhotoRoom.png-PhotoRoom.png'),
              ),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              '${widget.comment.user.displayName}: ${widget.comment.comment}', // Accessing the comment object
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
