import 'package:flutter/material.dart';
import 'package:ientrada_new/screens/employee_screen.dart';
import 'package:ientrada_new/screens/register_screen.dart';
import 'package:ientrada_new/screens/verify_screen.dart';
import 'package:ientrada_new/screens/analysis_screen.dart';
import 'package:ientrada_new/widgets/appbar.dart';

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
    AnalysisScreen(),
    VerifyScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Employees',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_add),
            label: 'Register',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'Analysis',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.verified_user),
            label: 'Verify',
          ),
        ],
      ),
    );
  }
}
