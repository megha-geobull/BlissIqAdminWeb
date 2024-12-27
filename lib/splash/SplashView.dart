import 'dart:async';
import 'package:blissiqadmin/Global/constants/CommonSizedBox.dart';
import 'package:blissiqadmin/auth/Signup/SignupScreen.dart';
import 'package:blissiqadmin/controller/SplashController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../profile/ProfileController.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  final splashController = Get.find<SplashController>();

  // Animation controller for image scaling
  late AnimationController _controller;
  late Animation<double> _animation;

  void navigateToHomeScreen() {
    Timer(Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SignUpScreen()),
      );
    });
  }

  @override
  void initState() {
    super.initState();
    // splashController.generateFirebaseToken();
    navigateToHomeScreen();
    Get.find<ProfileController>().checkLogin();
    goToScreen();

    // Initialize animation controller
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3), // Total duration of animation
    );

    _animation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.repeat(reverse: true); // Continuously scale up and down
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated Houzza logo with scale animation
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.scale(
                  scale: _animation.value,
                  child: CircleAvatar(
                    radius: 80,
                    child: Image.asset(
                      'assets/images/logo.png',
                      width: 100,
                      height: 80,
                    ),
                  ),
                );
              },
            ),
            boxH15(),

            // Fading circular progress indicator
            FadeTransition(
              opacity: _controller,
              child: CircularProgressIndicator(
                color: Colors.blue.shade300,
                strokeWidth: 0.9,
              ),
            ),
          ],
        ),
      ),
    );
  }

  goToScreen() {
    Timer(
       Duration(seconds: 3),
          () => Get.to(SignUpScreen()),
    );
  }
}


