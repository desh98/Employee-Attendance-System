import 'package:flutter/material.dart';
import 'package:ientrada_new/constants/api.dart';
import 'package:ientrada_new/screens/home_screen.dart';
import 'package:ientrada_new/screens/security_screen.dart';
import 'package:ientrada_new/utils/dialog.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController userController = TextEditingController();
  final TextEditingController apiKeyController = TextEditingController();
  String selectedPage = 'Admin Page';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              height: 550,
              width: 400,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/logo-full.png',
                    width: 300,
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    'Sign in to your account',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        TextField(
                          controller: userController,
                          decoration: InputDecoration(
                            hintText: 'User',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(height: 10.0),
                        TextField(
                          controller: apiKeyController,
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: 'API Key',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: Colors.grey),
                          ),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: selectedPage,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedPage = newValue ?? 'Admin Page';
                                  });
                                },
                                items: <String>[
                                  'Admin Page',
                                  'Security Page'
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          value,
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10.0),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            'Forgot API Key?',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: () {
                      String enteredUser = userController.text;
                      String enteredApiKey = apiKeyController.text;
                      if (enteredUser == ApiConstants.user &&
                          enteredApiKey == ApiConstants.apiKey) {
                        if (selectedPage == 'Admin Page') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomeScreen()),
                          );
                        } else if (selectedPage == 'Security Page') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SecurityScreen()),
                          );
                        }
                      } else {
                        DialogUtils.showResponseDialog(
                            context, ResponseType.Invalid, 'Invalid Login');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      padding:
                          EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    ),
                    child: Text(
                      'Sign Me In',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
