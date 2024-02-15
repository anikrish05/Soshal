import 'package:flutter/material.dart';
import 'package:gdsc_app/classes/Comment.dart';

class CommentCard extends StatefulWidget {
  final Comment comment;

  CommentCard({required this.comment});

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  bool isLiked = false;
  Color _orangeColor = Color(0xFFFF8050);
  String timestamp = "";
  Widget _buildProfileImage() {
    Widget profileImage;

    if (widget.comment.user.downloadURL.isEmpty) {
      profileImage = Image.asset(
        'assets/emptyprofileimage-PhotoRoom.png-PhotoRoom.png',
        width: 40,
        height: 40,
        fit: BoxFit.cover,
      );
    } else {
      profileImage = Image.network(
        widget.comment.user.downloadURL,
        width: 40,
        height: 40,
        fit: BoxFit.cover,
      );
    }

    return ClipOval(
      child: profileImage,
    );
  }


  @override
  void initState() {
    int timestampInMilliseconds = widget.comment.timestamp;
    DateTime nodeDateTime = DateTime.fromMillisecondsSinceEpoch(timestampInMilliseconds);
    DateTime currentDateTime = DateTime.now();
    Duration difference = currentDateTime.difference(nodeDateTime);
    String tempString = "";
    if (difference.inDays > 0) {
      setState(() {
        tempString = "${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago";
      });
    } else if (difference.inHours > 0) {
      setState(() {
        tempString = "${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago";
      });
    } else {
      setState(() {
        tempString = "${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago";
      });
    }
    setState(() {
      isLiked = widget.comment.isLiked;
      timestamp = tempString;
    });
  }

  void toggleLike() {
    bool temp = !isLiked;
    setState(() {
      isLiked = temp;
    });
    if(temp){
      widget.comment.like();
    }
    else{
      widget.comment.disLike();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProfileImage(),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${widget.comment.user.displayName}',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: toggleLike,
                          child: Icon(
                            isLiked ? Icons.favorite : Icons.favorite_border,
                            color: isLiked ? Colors.redAccent : Colors.grey,
                          ),
                        ),
                        SizedBox(width: 4),
                        Text(
                          "433", // Change this to the actual like count
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Text(
                  widget.comment.comment,
                  style: TextStyle(color: Colors.black87, fontSize: 16),
                ),
                SizedBox(height: 8),
                Text(
                  "$timestamp",
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}
