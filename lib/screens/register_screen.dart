import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:camera/camera.dart';
import 'package:flutter/widgets.dart';
import 'package:ientrada_new/constants/api.dart';
import 'package:ientrada_new/constants/color.dart';
import 'package:ientrada_new/main.dart';
import 'package:ientrada_new/utils/dialog.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Camera preview
          if (_controller.value.isInitialized)
            Positioned.fill(
              child: AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: _capturedImage == null
                    ? CameraPreview(_controller)
                    : Image.file(File(_capturedImage!.path)),
              ),
            ),

          // Back arrow button
          if (_capturedImage != null)
            Positioned(
              top: 45,
              left: 10,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _capturedImage = null;
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.5),
                  ),
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                ),
              ),
            ),

          // Bottom container
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: 200,
              padding: const EdgeInsets.all(40.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
              ),
              child: Column(
                children: [
                  // Text field for ID
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
                      controller: _userIdController,
                      obscureText: false,
                      decoration: InputDecoration(
                        hintText: 'Enter Unique ID',
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

                  SizedBox(height: 15),

                  // Register button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: MaterialButton(
                        onPressed: () {
                          _registerUser();
                        },
                        color: AppColors.secondary,
                        child: const Text(
                          'Register',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Camera button
          Positioned(
            left: 0,
            right: 0,
            bottom: 170,
            child: Center(
              child: GestureDetector(
                onTap: _pickImageFromCamera,
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3.0),
                  ),
                  child: Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: 35,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _registerUser() async {
    if (_userIdController.text.isEmpty) {
      DialogUtils.showResponseDialog(
          context, ResponseType.Invalid, 'User ID Not Provided');
      return;
    }

    if (_capturedImage == null) {
      DialogUtils.showResponseDialog(
          context, ResponseType.Invalid, 'Please Capture an Image First');
      return;
    }

    // Disable the register button to prevent multiple clicks
    setState(() {});

    // Show the loading indicator
    DialogUtils.showLoadingDialog(context, 'Registering user...');

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

      // Re-enable the register button
      setState(() {});

      // Close the loading indicator dialog
      Navigator.of(context).pop();

      if (sendResponse.statusCode == 200) {
        // Registration successful
        DialogUtils.showResponseDialog(
            context, ResponseType.Success, '$message');

        // Reset _capturedImage to null after successful registration
        setState(() {
          _capturedImage = null;
        });

        // Delete the image file after sending it to the API
        await resizedImageFile.delete();
      } else {
        // Registration failed
        DialogUtils.showResponseDialog(
            context, ResponseType.Failed, '$message');
      }
    } catch (e) {
      if (e.toString().contains('<html>')) {
        DialogUtils.showResponseDialog(
          context,
          ResponseType.Failed,
          'Connection Error. Please Try Again Later!',
        );
      } else {
        DialogUtils.showResponseDialog(
            context, ResponseType.Failed, 'Error: $e');
      }
    } finally {}
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
}
