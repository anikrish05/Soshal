import 'package:flutter/material.dart';
Color _colorTab = Color(0xFFFF8050);

class UserRequest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: ListTile(
          leading: Image.asset('assets/emptyprofileimage-PhotoRoom.png-PhotoRoom.png', width: 70.0, height: 70.0),
          title: RichText(
            text: TextSpan(
              style: DefaultTextStyle.of(context).style,
              children: <TextSpan>[
                TextSpan(text: 'Animesh Alang', style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: ' has requested to follow you'),
              ],
            ),
          ),
          subtitle: Text('4h ago'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextButton(
                child: Text('Accept', style: TextStyle(color: Colors.white, fontFamily: 'Borel')),
                style: TextButton.styleFrom(
                  backgroundColor: _colorTab,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                onPressed: () {/* Accept action */},
              ),
              SizedBox(width: 10),
              TextButton(
                child: Text('Reject', style: TextStyle(color: Colors.white, fontFamily: 'Borel')),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                onPressed: () {/* Reject action */},
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UserFollowing extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: ListTile(
          leading: Image.asset('assets/emptyprofileimage-PhotoRoom.png-PhotoRoom.png', width: 70.0, height: 70.0),
          title: RichText(
            text: TextSpan(
              style: DefaultTextStyle.of(context).style,
              children: <TextSpan>[
                TextSpan(text: 'Aditi Kamble', style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: ' started following you'),
              ],
            ),
          ),
          subtitle: Text('4h ago'),
        ),
      ),
    );
  }
}

class UserReject extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: ListTile(
          leading: Image.asset('assets/emptyprofileimage-PhotoRoom.png-PhotoRoom.png', width: 70.0, height: 70.0),
          title: RichText(
            text: TextSpan(
              style: DefaultTextStyle.of(context).style,
              children: <TextSpan>[
                TextSpan(text: 'Anirudh Krishna', style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: ' rejected your follow request'),
              ],
            ),
          ),
          subtitle: Text('4h ago'),
        ),
      ),
    );
  }
}
