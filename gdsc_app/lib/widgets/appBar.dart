import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(70);

  @override
  Widget build(BuildContext context) {
    return(AppBar(
      backgroundColor: Colors.white,
        elevation: 1,
        title: Container(
            padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 3),
            child: Image.asset('assets/image.png',
              height: 50
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
