import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ientrada_new/screens/login_screen.dart';
import 'package:video_player/video_player.dart';

class NewSplashScreen extends StatefulWidget {
  const NewSplashScreen({Key? key}) : super(key: key);

  @override
  _NewSplashScreenState createState() => _NewSplashScreenState();
}

class _NewSplashScreenState extends State<NewSplashScreen>
    with SingleTickerProviderStateMixin {
  late VideoPlayerController _controller;
  late bool _isVideoPlaying;
  // ignore: unused_field
  late Future<void> _navigateFuture;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    _isVideoPlaying = false;
    _controller = VideoPlayerController.asset('assets/splash1.mp4')
      ..initialize().then((_) {
        setState(() {
          _isVideoPlaying = true;
        });
        _controller.play();
      }).catchError((error) {
        // Handle video initialization error
        print('Video initialization error: $error');
      });

    // Schedule navigation after a delay
    _navigateFuture =
        Future.delayed(Duration(seconds: 8), _navigateToLoginScreen);
  }

  void _navigateToLoginScreen() {
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => LoginScreen(),
        ),
      );
    }
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (_isVideoPlaying)
              AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Image.asset(
                  'assets/sltnew.png',
                  height: 60,
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Transform.scale(
                scale: 0.4,
                child: Image.asset('assets/logo.png'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
