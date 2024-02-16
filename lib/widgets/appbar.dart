import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar(
      {Key? key, required this.isSideBarOpen, required this.toggleSideBar})
      : super(key: key);

  final bool isSideBarOpen;
  final VoidCallback toggleSideBar;

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: isSideBarOpen ? Icon(Icons.arrow_back) : Icon(Icons.menu),
        onPressed: toggleSideBar,
      ),
      actions: [
        // Dark mode icon
        IconButton(
          icon: Icon(Icons.brightness_6),
          onPressed: () {
            // Toggle dark mode
          },
        ),
        // Full screen icon
        IconButton(
          icon: Icon(Icons.fullscreen),
          onPressed: () {
            // Toggle full screen
          },
        ),
        // Embryo logo
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Image.asset(
            'assets/logo.png',
            width: 30,
            height: 30,
          ),
        ),
      ],
    );
  }
}
