
import 'package:blissiqadmin/Home/HomePage.dart';
import 'package:blissiqadmin/auth/login/login.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:get/get.dart';
import '../../profile/ProfileController.dart';


class SplashScreenPage extends StatefulWidget {
  @override
  _SplashScreenPageState createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {

  final profileController = Get.find<ProfileController>();

  @override
  void initState() {
    super.initState();

    Get.find<ProfileController>().checkLogin();
    Timer(Duration(seconds: 2), () {
      profileController.userId.isNotEmpty?
      Get.to(HomePage()):
      Get.to(LoginScreen());

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      body: Center(
        child: Image.asset('assets/images/logo.png', height: 80),
      ),
    );
  }
}
