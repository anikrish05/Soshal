import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(70);

  @override
  Widget build(BuildContext context) {
    return(AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(
                'assets/image.png',
                fit: BoxFit.fitWidth,
                height: 150,
                width: 150
              ),
            ]),
      automaticallyImplyLeading:false,
      actions: [
          Icon(Icons.notifications,
            size: 50,
            color: Colors.grey[500]
          )
        ],
    ));
  }
}
