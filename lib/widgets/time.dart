import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CurrentTime extends StatefulWidget {
  const CurrentTime({Key? key}) : super(key: key);

  @override
  _CurrentTimeState createState() => _CurrentTimeState();
}

class _CurrentTimeState extends State<CurrentTime> {
  late String _currentTime;

  @override
  void initState() {
    super.initState();
    // Initialize the current time
    _currentTime = _getCurrentTime();
    // Start a timer to update the time every second
    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _currentTime = _getCurrentTime();
      });
    });
  }

  String _getCurrentTime() {
    return DateFormat('hh:mm:ss a').format(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 20,
      left: 100,
      right: 100,
      child: Container(
        decoration: BoxDecoration(color: Colors.black),
        alignment: Alignment.center,
        child: Text(
          _currentTime,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
