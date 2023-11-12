import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(70);

  @override
  Widget build(BuildContext context) {
    return(AppBar(
      backgroundColor: Colors.white,
        elevation: 1,
        title: Padding(
          padding: const EdgeInsets.only(top: 35.0),
          child: Text('Soshal',
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.0,
                  color: Colors.orange[600],
                  fontFamily: 'Borel'
              )
          ),
        ),
        actions: [
          Icon(Icons.notifications,
            size: 50,
            color: Colors.grey[500]
          )
        ],
    ));
  }
}
