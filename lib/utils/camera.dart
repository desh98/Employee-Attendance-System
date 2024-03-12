// import 'dart:io';
import 'package:camera/camera.dart';

class CameraService {
  late CameraController _controller;

  Future<void> initializeCamera() async {
    final cameras = await availableCameras();
    _controller = CameraController(cameras[1], ResolutionPreset.max);
    await _controller.initialize();
  }

  Future<XFile?> takePicture() async {
    if (!_controller.value.isInitialized) return null;
    if (_controller.value.isTakingPicture) return null;

    try {
      final XFile file = await _controller.takePicture();
      return file;
    } catch (e) {
      print("Error occurred while taking picture : $e");
      return null;
    }
  }
}
