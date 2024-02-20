import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/widgets.dart';
import 'package:ientrada_new/main.dart';
import 'package:http/http.dart' as http;

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late CameraController _controller;
  XFile? _capturedImage;
  final TextEditingController _userIdController = TextEditingController();
  final String apiUrl = 'https://ientrada.raccoon-ai.io/api/register_face';

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    _controller = CameraController(cameras[1], ResolutionPreset.max);
    await _controller.initialize();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Text field for ID
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  color: Colors.grey[100],
                  child: TextFormField(
                    controller: _userIdController,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      labelText: 'Enter Unique ID',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),

              // Camera preview
              Center(
                child: Container(
                  height: 500,
                  child: _capturedImage == null
                      ? CameraPreview(_controller)
                      : Image.file(File(_capturedImage!.path)),
                ),
              ),

              // // Camera preview
              // Center(
              //   child: Container(
              //     height: 500,
              //     child: _capturedImage == null
              //         ? Image.network(
              //             'https://w0.peakpx.com/wallpaper/294/364/HD-wallpaper-angelina-jolie-actress-face-portrait-girls.jpg')
              //         : Image.file(File(_capturedImage!.path)),
              //   ),
              // ),

              // Buttons
              Column(
                children: [
                  // Capture image button
                  Center(
                    child: Container(
                      child: MaterialButton(
                        onPressed: () async {
                          if (!_controller.value.isInitialized) {
                            return;
                          }
                          if (_controller.value.isTakingPicture) {
                            return;
                          }

                          try {
                            await _controller.setFlashMode(FlashMode.auto);
                            final XFile file = await _controller.takePicture();
                            setState(() {
                              _capturedImage = file;
                            });
                          } on CameraException catch (e) {
                            debugPrint(
                                "Error occurred while taking picture : $e");
                          }
                        },
                        color: Colors.purple,
                        child: const Text(
                          'Capture Image',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Reset captured image button
                  if (_capturedImage != null)
                    Center(
                      child: Container(
                        child: MaterialButton(
                          onPressed: () {
                            setState(() {
                              _capturedImage = null;
                            });
                          },
                          color: Colors.purple,
                          child: const Text(
                            'Back to Camera',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),

                  // Register button
                  MaterialButton(
                    onPressed: () {
                      _registerUser();
                    },
                    color: Colors.purple,
                    child: const Text(
                      'Register',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showResponseDialog(String message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Registration Status'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _registerUser() async {
    // Check if the user ID and image are provided
    if (_userIdController.text.isEmpty || _capturedImage == null) {
      _showResponseDialog('User ID or image not provided.');
      return;
    }

    // Prepare the request body
    final String userId = _userIdController.text;
    final File imageFile = File(_capturedImage!.path);

    // // Download the image from the internet
    // final String imageUrl =
    //     'https://w0.peakpx.com/wallpaper/294/364/HD-wallpaper-angelina-jolie-actress-face-portrait-girls.jpg';

    // http.Response imageResponse = await http.get(Uri.parse(imageUrl));

    // // Check if the image was downloaded successfully
    // if (imageResponse.statusCode != 200) {
    //   _showResponseDialog('Failed to download image.');
    //   return;
    // }

    // Create a multipart request
    var request = http.MultipartRequest('POST', Uri.parse(apiUrl));

    // Add headers
    request.headers['api'] = 'abcd';
    request.headers['user'] = 'slt';
    request.headers['nic'] = '123';

    // Add user ID field to the request
    request.fields['user'] = userId;

    // // Add image file to the request
    // request.files.add(http.MultipartFile.fromBytes(
    //   'image',
    //   imageResponse.bodyBytes,
    //   filename: 'image.jpg',
    // ));

    // Add fields and files to the request
    request.files.add(http.MultipartFile.fromBytes(
      'image',
      await imageFile.readAsBytes(),
      filename: imageFile.path.split('/').last,
    ));

    // Send the request
    http.StreamedResponse response = await request.send();

    // Get the response body
    String responseBody = await response.stream.bytesToString();

    // Parse the response JSON
    Map<String, dynamic> jsonResponse = json.decode(responseBody);

    // Get the message from the response
    String message = jsonResponse['msg'];

    // Check the response status
    if (response.statusCode == 200) {
      // Registration successful
      _showResponseDialog('$message');
    } else {
      // Registration failed
      _showResponseDialog('$message');
    }
  }
}
