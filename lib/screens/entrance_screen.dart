import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:ientrada_new/constants/api.dart';
import 'package:ientrada_new/constants/color.dart';
import 'package:ientrada_new/utils/dialog.dart';
import 'package:http/http.dart' as http;
import 'package:ientrada_new/main.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as img;

class EntranceScreen extends StatefulWidget {
  const EntranceScreen({Key? key}) : super(key: key);

  @override
  _EntranceScreenState createState() => _EntranceScreenState();
}

class _EntranceScreenState extends State<EntranceScreen> {
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
              padding: const EdgeInsets.all(75.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: MaterialButton(
                  onPressed: () {
                    _verifyUser('i');
                  },
                  color: AppColors.secondary,
                  child: const Text(
                    'Verify Entrance',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
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

  Future<void> _verifyUser(String other) async {
    if (_capturedImage == null) {
      DialogUtils.showResponseDialog(
          context, ResponseType.Invalid, 'Please capture an image first.');
      return;
    }

    // Disable the register button to prevent multiple clicks
    setState(() {});

    // Show loading dialog
    DialogUtils.showLoadingDialog(context, 'Verifying user...');

    try {
      // Resize image to a consistent resolution
      final File resizedImageFile =
          await _resizeImage(File(_capturedImage!.path));

      // Create a multipart request
      var request = http.MultipartRequest('POST', Uri.parse(apiUrl));

      // Add headers
      request.headers['api'] = ApiConstants.apiKey;
      request.headers['user'] = ApiConstants.user;
      request.headers['other'] = other;

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

      // Re-enable the register button
      setState(() {});

      // Close the loading indicator dialog
      Navigator.of(context).pop();

      // Check if the JSON response contains the 'msg' and 'user' keys
      if (jsonResponse.containsKey('msg2') &&
          jsonResponse.containsKey('user')) {
        String message = jsonResponse['msg2'];
        String username = jsonResponse['user'];

        // Check the response status
        if (response.statusCode == 200) {
          // Show the message in the dialog
          DialogUtils.showResponseDialog(
              context, ResponseType.Success, '$username $message');

          // Reset _capturedImage to null after successful verification
          setState(() {
            _capturedImage = null;
          });

          // Delete the image file after sending it to the API
          await resizedImageFile.delete();
        } else {
          // Show the error response message
          DialogUtils.showResponseDialog(context, ResponseType.Failed, message);
        }
      } else {
        // Show an error message if the response format is unexpected
        DialogUtils.showResponseDialog(
            context, ResponseType.Invalid, 'Face Not Detected');
      }
    } catch (e) {
      // Show error dialog
      DialogUtils.showResponseDialog(context, ResponseType.Failed, 'Error: $e');
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
