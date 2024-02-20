import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;
import 'package:ientrada_new/main.dart';

class VerifyScreen extends StatefulWidget {
  const VerifyScreen({Key? key}) : super(key: key);

  @override
  _VerifyScreenState createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  late CameraController _controller;
  XFile? _capturedImage;
  final String apiUrl = 'https://ientrada.raccoon-ai.io/api/verify_face';
  final String apiKey = 'abcd';
  final String user = 'slt';

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
              //             'https://userscontent2.emaze.com/images/df500937-33a0-41db-bc2d-94b9defdbb62/ba63bc5c-b364-4317-bfd6-c843b5275680.jpg')
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

                  // Verify button
                  MaterialButton(
                    onPressed: () {
                      _verifyUser();
                    },
                    color: Colors.purple,
                    child: const Text(
                      'Verify',
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
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Verification Status'),
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

  Future<void> _verifyUser() async {
    // Check if the image is captured
    if (_capturedImage == null) {
      _showResponseDialog('Image not captured.');
      return;
    }

    // Prepare the request body
    final File imageFile = File(_capturedImage!.path);

    // // Download the image from the internet
    // final String imageUrl =
    //     'https://userscontent2.emaze.com/images/df500937-33a0-41db-bc2d-94b9defdbb62/ba63bc5c-b364-4317-bfd6-c843b5275680.jpg';
    // http.Response imageResponse = await http.get(Uri.parse(imageUrl));

    // Create a multipart request
    var request = http.MultipartRequest('POST', Uri.parse(apiUrl));

    // Add headers
    request.headers['api'] = apiKey;
    request.headers['user'] = user;

    // Add fields and files to the request
    request.files.add(http.MultipartFile.fromBytes(
      'image',
      await imageFile.readAsBytes(),
      filename: imageFile.path.split('/').last,
    ));

    // // Add image file to the request
    // request.files.add(http.MultipartFile.fromBytes(
    //   'image',
    //   imageResponse.bodyBytes,
    //   filename: 'image.jpg',
    // ));

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
      // Show the message in the dialog
      _showResponseDialog(message);
    } else {
      // Show the error response message
      _showResponseDialog('Verification failed: $message');
    }
  }
}
