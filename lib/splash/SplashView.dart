// import 'dart:async';
//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:real_estate_app/Routes/app_pages.dart';
// import 'package:real_estate_app/common_widgets/height.dart';
// import 'package:real_estate_app/global/app_color.dart';
// import 'package:real_estate_app/view/dashboard/deshboard_controllers/profile_controller.dart';
// import 'package:real_estate_app/view/splash_screen/SplashController.dart';
// import 'package:real_estate_app/view/welcome_screen/view/welcome_screen.dart';
//
// class SplashScreen extends StatefulWidget {
//   const SplashScreen({Key? key}) : super(key: key);
//
//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }
//
// class _SplashScreenState extends State<SplashScreen> {
//   final splashController = Get.find<SplashController>();
//
//
//   void navigateToHomeScreen() {
//     Timer(Duration(seconds: 2), () {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => WelcomeScreen()),
//         // MaterialPageRoute(builder: (context) => BottomNavbar()),
//       );
//     });
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     splashController.generateFirebaseToken();
//     navigateToHomeScreen();
//     Get.find<ProfileController>().checkLogin();
//     goToScreen();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             CircleAvatar(
//               radius: 80,
//               backgroundColor: AppColor.blue.withOpacity(0.2),
//               child: Image.asset(
//                 'assets/Houzza.png',
//                 width: 100,
//                 height: 80,
//                 color: AppColor.blue,
//               ),
//             ),
//            // Image.asset('assets/flutter_logo.png', width: 150),
//            boxH15(),
//             CircularProgressIndicator(color: Colors.blue.shade300),
//           ],
//         ),
//       ),
//     );
//   }
//
//   goToScreen() {
//     Timer(
//       const Duration(seconds: 3), () =>
//         //Get.offAllNamed(Routes.WelcomeScreen),
//       Get.to(WelcomeScreen()),
//     );
//   }
// }

import 'dart:async';
import 'package:blissiqadmin/Global/constants/CommonSizedBox.dart';
import 'package:blissiqadmin/auth/Signup/SignupScreen.dart';
import 'package:blissiqadmin/controller/SplashController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


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
    //  Get.find<ProfileController>().checkLogin();
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
                      'assets/roulette.png',
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


