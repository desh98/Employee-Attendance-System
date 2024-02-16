import 'package:flutter/material.dart';
import 'package:ientrada_new/screens/register_screen.dart';
import 'package:ientrada_new/screens/verify_screen.dart';

class SideBar extends StatelessWidget {
  const SideBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.deepPurple,
            ),
            child: Text(
              'IENTRADA',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            title: Text('Register'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        RegisterScreen()), // Navigate to RegisterScreen
              );
            },
          ),
          ListTile(
            title: Text('Verify'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        VerifyScreen()), // Navigate to VerifyScreen
              );
            },
          ),
        ],
      ),
    );
  }
}
