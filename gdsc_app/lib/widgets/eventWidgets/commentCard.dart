import 'package:flutter/material.dart';
import 'package:gdsc_app/classes/Comment.dart';

class CommentCard extends StatefulWidget {
  final Comment comment;

  CommentCard({required this.comment});

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  Widget _buildProfileImage() {
    if (widget.comment.user.downloadURL.isEmpty) {
      return Image.asset('assets/emptyprofileimage-PhotoRoom.png-PhotoRoom.png',
          width: 40, height: 40, fit: BoxFit.cover);
    } else {
      return Image.network(widget.comment.user.downloadURL,
          width: 40, height: 40, fit: BoxFit.cover);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          _buildProfileImage(),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              '${widget.comment.user.displayName}: ${widget.comment.comment}',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
