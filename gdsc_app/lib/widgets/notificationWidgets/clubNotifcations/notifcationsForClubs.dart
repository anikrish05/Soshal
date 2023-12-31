import 'package:flutter/material.dart';
Color _colorTab = Color(0xFFFF8050);

class ClubInvite extends StatelessWidget {
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
                TextSpan(text: ' invited you to be an admin of Gesher Group Consulting'),
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

class ClubEvent extends StatelessWidget {
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
                TextSpan(text: 'Club Name', style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: ' posted a new event: '),
                TextSpan(text: 'Friday Science Mixer'),
              ],
            ),
          ),
          subtitle: Text('4h ago'),
        ),
      ),
    );
  }
}

class ClubReject extends StatelessWidget {
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
                TextSpan(text: ' rejected your request to follow: '),
                TextSpan(text: 'Tech4Good', style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          subtitle: Text('4h ago'),
        ),
      ),
    );
  }
}
