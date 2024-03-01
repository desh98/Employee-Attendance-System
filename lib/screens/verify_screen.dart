import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:ientrada_new/constants/api.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:ientrada_new/main.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as img;

class VerifyScreen extends StatefulWidget {
  const VerifyScreen({Key? key}) : super(key: key);

  @override
  _VerifyScreenState createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  late CameraController _controller;
  XFile? _capturedImage;
  final String apiUrl =
      '${ApiConstants.apiUrl}${ApiConstants.verifyFaceEndpoint}';

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

  Future<void> _pickImageFromCamera() async {
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
        _capturedImage = file; // Update _capturedImage with the new image
      });
    } on CameraException catch (e) {
      debugPrint("Error occurred while taking picture : $e");
    }
  }

  Future<void> _pickImageFromGallery() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _capturedImage = XFile(pickedFile.path);
      });
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

              // Buttons
              Column(
                children: [
                  // Capture image button
                  Center(
                    child: Container(
                      child: MaterialButton(
                        onPressed: _pickImageFromCamera,
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

                  // Pick image from gallery button
                  Center(
                    child: Container(
                      child: MaterialButton(
                        onPressed: _pickImageFromGallery,
                        color: Colors.purple,
                        child: const Text(
                          'Pick Image from Gallery',
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
      barrierDismissible: false,
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
    if (_capturedImage == null) {
      _showResponseDialog('Please capture an image first.');
      return;
    }
    try {
      // Resize image to a consistent resolution
      final File resizedImageFile =
          await _resizeImage(File(_capturedImage!.path));

      // Create a multipart request
      var request = http.MultipartRequest('POST', Uri.parse(apiUrl));

      // Add headers
      request.headers['api'] = ApiConstants.apiKey;
      request.headers['user'] = ApiConstants.user;

      // Add image file to the request
      request.files.add(await http.MultipartFile.fromPath(
        'image',
        resizedImageFile.path,
      ));

      // Send the request
      http.StreamedResponse response = await request.send();

      // Get the response body
      String responseBody = await response.stream.bytesToString();

      // Parse the response JSON
      Map<String, dynamic> jsonResponse = json.decode(responseBody);

      String message = jsonResponse['msg'];
      String username = jsonResponse['user'];

      // Check the response status
      if (response.statusCode == 200) {
        // Show the message in the dialog
        _showResponseDialog('$username: $message');
        // Reset _capturedImage to null after successful verification
        setState(() {
          _capturedImage = null;
        });
        // Delete the image file after sending it to the API
        await resizedImageFile.delete();
      } else {
        // Show the error response message
        _showResponseDialog(message);
      }
    } catch (e) {
      // Show error dialog
      _showResponseDialog('Error: $e');
    }
  }

  Future<File> _resizeImage(File imageFile) async {
    // Read image bytes
    final Uint8List bytes = await imageFile.readAsBytes();

    // Decode image
    img.Image? image = img.decodeImage(bytes);
    if (image == null) {
      throw Exception('Failed to decode image.');
    }

    // Resize image
    final img.Image resizedImage = img.copyResize(image, width: 800);

    // Write resized image to a file
    final File resizedFile =
        File('${(await getTemporaryDirectory()).path}/resized_image.jpg');
    await resizedFile.writeAsBytes(img.encodeJpg(resizedImage));

    return resizedFile;
  }
}
