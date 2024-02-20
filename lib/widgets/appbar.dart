import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({super.key});

  @override
  Size get preferredSize => Size.fromHeight(80);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: AppBar(
        leading: Image.asset(
          'assets/logo.png',
          width: 25,
          height: 25,
        ),
        actions: [
          // Dark mode icon
          Container(
            decoration: BoxDecoration(
              color: Colors.purple[50],
              borderRadius: BorderRadius.circular(10),
            ),
            child: IconButton(
              icon: Icon(Icons.dark_mode_rounded),
              color: Colors.purple,
              onPressed: () {},
            ),
          ),

          SizedBox(width: 5),
          // Logout button
          Container(
            decoration: BoxDecoration(
              color: Colors.purple[50],
              borderRadius: BorderRadius.circular(10),
            ),
            child: IconButton(
              icon: Icon(Icons.logout),
              color: Colors.purple,
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}
