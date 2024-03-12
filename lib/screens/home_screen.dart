import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/material.dart';
import 'package:ientrada_new/constants/color.dart';
import 'package:ientrada_new/screens/employee_screen.dart';
import 'package:ientrada_new/screens/entrance_screen.dart';
import 'package:ientrada_new/screens/exit_screen.dart';
import 'package:ientrada_new/screens/register_screen.dart';
import 'package:ientrada_new/screens/verify_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final List<Widget> _screens = [
    EmployeeScreen(),
    RegisterScreen(),
    VerifyScreen(),
    EntranceScreen(),
    ExitScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: CurvedNavigationBar(
        index: _currentIndex,
        backgroundColor: Colors.transparent,
        color: AppColors.primary,
        height: 50,
        animationCurve: Curves.easeInOut,
        animationDuration: Duration(milliseconds: 300),
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          CurvedNavigationBarItem(
            child: Icon(
              Icons.person,
              size: 25,
              color: AppColors.white,
            ),
            // label: 'Employee',
          ),
          CurvedNavigationBarItem(
            child: Icon(
              Icons.person_add,
              size: 25,
              color: AppColors.white,
            ),
            // label: 'Register',
          ),
          CurvedNavigationBarItem(
            child: Icon(
              Icons.verified_user_rounded,
              size: 25,
              color: AppColors.white,
            ),
            // label: 'Verify',
          ),
          CurvedNavigationBarItem(
            child: Icon(
              Icons.inbox_rounded,
              size: 25,
              color: AppColors.white,
            ),
            // label: 'Entrance',
          ),
          CurvedNavigationBarItem(
            child: Icon(
              Icons.outbox_rounded,
              size: 25,
              color: AppColors.white,
            ),
            // label: 'Exit',
          ),
        ],
      ),
    );
  }
}
