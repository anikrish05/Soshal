import 'package:flutter/material.dart';
import 'package:gdsc_app/classes/MarkerData.dart';

class SlidingUpWidget extends StatefulWidget {
  final MarkerData markerData;
  final VoidCallback onClose; // Callback to be called when the panel is closed

  SlidingUpWidget({required this.markerData, required this.onClose});

  @override
  _SlidingUpWidgetState createState() => _SlidingUpWidgetState();
}

class _SlidingUpWidgetState extends State<SlidingUpWidget> {
  // List to store comments
  List<Comment> comments = [
    Comment(username: 'Kamble', text: 'Let\'s get lit'),
    Comment(username: 'User', text: 'This isn\'t lowkey the vibe'),
    Comment(username: 'AnotherUser', text: 'Nice event!'),
  ];

  // Controller for the comment text field
  TextEditingController commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: GestureDetector(
        onTap: () {
          // Close the panel and call the onClose callback when tapped outside the panel
          widget.onClose();
        },
        child: Container(
          width: MediaQuery.of(context).size.width * 1.0,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 12),
                child: Container(
                  height: 4,
                  width: 100,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 12),
                      width: 125,
                      height: 125,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          widget.markerData.image,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Text(
                                widget.markerData.title,
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          SizedBox(height: 5),
                          Row(
                            children: [
                              Text(
                                widget.markerData.description,
                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Text("By: Adithya "),
                              SizedBox(width: 8),
                              Row(
                                children: List.generate(
                                  5,
                                      (index) => Padding(
                                    padding: EdgeInsets.only(right: 4),
                                    child: Icon(Icons.star, color: Colors.grey, size: 16),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(Icons.location_on),
                              Padding(padding: EdgeInsets.only(right: 4)),
                              Text(widget.markerData.location),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(Icons.access_time),
                              Padding(padding: EdgeInsets.only(right: 4)),
                              Text(widget.markerData.time),
                            ],
                          ),
                          SizedBox(height: 8),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              margin: EdgeInsets.only(bottom: 2, right: 40),
                              child: ElevatedButton(
                                onPressed: () {
                                  // Add RSVP button logic
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.grey,
                                  textStyle: TextStyle(
                                    fontFamily: 'Borel',
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                child: Text('rsvp'),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                color: Colors.grey,
                thickness: 1,
                indent: 50,
                endIndent: 50,
              ),
              // Text field for adding comments
              Padding(
                padding: const EdgeInsets.only(right: 40, left: 40),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    height: 40,
                    child: TextField(
                      controller: commentController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'add comments',
                        filled: true,
                        fillColor: Colors.grey,
                        hintStyle: TextStyle(
                          fontFamily: 'Borel',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 1, horizontal: 10),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                        border: InputBorder.none,
                        suffixIcon: IconButton(
                          onPressed: () {
                            addComment(); // Function to add the comment
                          },
                          icon: Icon(Icons.send, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16), // Add padding under the text box
              // Comment section
              Expanded(
                child: ListView.builder(
                  itemCount: comments.length,
                  itemBuilder: (context, index) {
                    return buildCommentItem(comments[index]);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCommentItem(Comment comment) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '${comment.username}: ${comment.text}',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          IconButton(
            onPressed: () {
              // Add functionality for the heart-shaped button
            },
            icon: Icon(Icons.favorite_border, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  void addComment() {
    // Get the text from the comment text field
    String text = commentController.text.trim();
    if (text.isNotEmpty) {
      // Add a new comment to the list
      setState(() {
        comments.add(Comment(username: 'User', text: text));
        commentController.clear(); // Clear the text field after adding the comment
      });
    }
  }
}

class Comment {
  final String username;
  final String text;

  Comment({required this.username, required this.text});
}
