import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:camera/camera.dart';
import 'package:ientrada_new/constants/api.dart';
import 'package:ientrada_new/main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as img;
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
  final String apiUrl =
      '${ApiConstants.apiUrl}${ApiConstants.registerFaceEndpoint}';

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
        _capturedImage = file;
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

  Future<void> _registerUser() async {
    // Check if the user ID is provided
    if (_userIdController.text.isEmpty) {
      _showResponseDialog('User ID not provided.');
      return;
    }

    if (_capturedImage == null) {
      _showResponseDialog('Please capture an image first.');
      return;
    }

    // Prepare the request body
    final String userId = _userIdController.text;

    try {
      // Resize image to a consistent resolution
      final File resizedImageFile =
          await _resizeImage(File(_capturedImage!.path));

      // Create a multipart request
      var request = http.MultipartRequest('POST', Uri.parse(apiUrl));

      // Add headers
      request.headers['api'] = ApiConstants.apiKey;
      request.headers['user'] = ApiConstants.user;
      request.headers['nic'] = _userIdController.text;

      // Add user ID field to the request
      request.fields['user'] = userId;

      // Add image file to the request
      request.files.add(await http.MultipartFile.fromPath(
        'image',
        resizedImageFile.path,
      ));

      // Send the request
      final sendResponse = await request.send();

      // Get the response body
      final responseBody = await sendResponse.stream.bytesToString();

      // Parse the response JSON
      final jsonResponse = json.decode(responseBody);

      // Get the message from the response
      final message = jsonResponse['msg'];

      // Check the response status
      if (sendResponse.statusCode == 200) {
        // Registration successful
        _showResponseDialog('$message');
        // Reset _capturedImage to null after successful registration
        setState(() {
          _capturedImage = null;
        });
        // Delete the image file after sending it to the API
        await resizedImageFile.delete();
      } else {
        // Registration failed
        _showResponseDialog('$message');
      }
    } catch (e) {
      // Handle any errors that occurred during the process
      _showResponseDialog('Error: $e');
    }
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

  Future<File> _resizeImage(File imageFile) async {
    try {
      // Check if the image file exists
      if (!(await imageFile.exists())) {
        throw Exception('Image file does not exist.');
      }

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
    } catch (e) {
      // Handle errors and return an appropriate error message
      if (e is FileSystemException) {
        // File system error (e.g., image file not found)
        throw Exception('Error accessing image file: $e');
      } else {
        // Other errors
        throw Exception('Error resizing image: $e');
      }
    }
  }

  // Future<File> _resizeImage(File imageFile) async {
  //   // Read image bytes
  //   final Uint8List bytes = await imageFile.readAsBytes();

  //   // Decode image
  //   img.Image? image = img.decodeImage(bytes);
  //   if (image == null) {
  //     throw Exception('Failed to decode image.');
  //   }

  //   // Resize image
  //   final img.Image resizedImage = img.copyResize(image, width: 800);

  //   // Write resized image to a file
  //   final File resizedFile =
  //       File('${(await getTemporaryDirectory()).path}/resized_image.jpg');
  //   await resizedFile.writeAsBytes(img.encodeJpg(resizedImage));

  //   return resizedFile;
  // }
}
