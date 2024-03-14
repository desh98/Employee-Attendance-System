import 'package:flutter/material.dart';
import 'package:ientrada_new/constants/api.dart';
import 'package:ientrada_new/constants/color.dart';
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
      backgroundColor: AppColors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/login.png',
                  width: 400,
                ),
                SizedBox(height: 10.0),
                Text(
                  'Sign in',
                  style: TextStyle(
                    color: AppColors.primaryDark,
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20.0),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 1,
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                        child: TextFormField(
                          controller: userController,
                          decoration: InputDecoration(
                            hintText: 'User',
                            filled: true,
                            fillColor: Colors.white,
                            border: InputBorder.none, // Remove border
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 12.0, horizontal: 16.0),
                            hintStyle: TextStyle(color: AppColors.textSub),
                            prefixIcon: Icon(
                              Icons.person,
                              color: AppColors.textSub,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 1,
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                        child: TextFormField(
                          controller: apiKeyController,
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: 'API Key',
                            filled: true,
                            fillColor: Colors.white,
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 12.0, horizontal: 16.0),
                            hintStyle: TextStyle(color: AppColors.textSub),
                            prefixIcon: Icon(
                              Icons.vpn_key,
                              color: AppColors.textSub,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20.0),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 1,
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
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
                            color: AppColors.textSub,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.0),
                Center(
                  child: ElevatedButton(
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
                      'Sign In',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
