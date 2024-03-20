import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ientrada_new/constants/api.dart';
import 'package:ientrada_new/constants/color.dart';
import 'package:ientrada_new/screens/home_screen.dart';
import 'package:ientrada_new/screens/security_screen.dart';
import 'package:ientrada_new/utils/dialog.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController userController = TextEditingController();
  final TextEditingController apiKeyController = TextEditingController();
  String selectedPage = 'Admin Page';
  final String apiUrl = '${ApiConstants.apiUrl}${ApiConstants.login}';

  Future<void> login(String user, String apiKey) async {
    try {
      // Create a POST request
      var response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'accept': 'application/json',
          'api': apiKey,
          'user': user,
        },
      );

      // Check the status code of the response
      if (response.statusCode == 200) {
        // If successful, navigate to the appropriate page
        final jsonData = json.decode(response.body);
        if (jsonData['login'] == true) {
          if (selectedPage == 'Admin Page') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          } else if (selectedPage == 'Security Page') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SecurityScreen()),
            );
          }
        } else {
          // Show invalid login message
          DialogUtils.showResponseDialog(
              context, ResponseType.Invalid, 'Invalid Login');
        }
      } else {
        // Show error message
        DialogUtils.showResponseDialog(
            context, ResponseType.Failed, 'Error occurred. Please try again.');
      }
    } catch (e) {
      // Show error message
      DialogUtils.showResponseDialog(
          context, ResponseType.Failed, 'Error occurred. Please try again.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(right: 20.0, left: 20, bottom: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/log.png',
                  width: 300,
                ),
                // SizedBox(height: 10.0),
                Text(
                  'Sign in',
                  style: TextStyle(
                    color: AppColors.secondaryDark,
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
                          color: Colors.white,
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
                            filled: false,
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 12.0, horizontal: 16.0),
                            hintStyle: TextStyle(
                                color: AppColors.textSub,
                                fontWeight: FontWeight.w400),
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
                          color: Colors.white,
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
                            filled: false,
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 12.0, horizontal: 16.0),
                            hintStyle: TextStyle(
                                color: AppColors.textSub,
                                fontWeight: FontWeight.w400),
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
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w400),
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
                      ApiConstants.user = enteredUser;
                      ApiConstants.apiKey = enteredApiKey;
                      login(enteredUser, enteredApiKey);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondaryDark,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 135, vertical: 15),
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
