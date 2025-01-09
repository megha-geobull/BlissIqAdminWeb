import 'dart:async';
import 'package:blissiqadmin/Home/HomePage.dart';
import 'package:blissiqadmin/Home/Quetion%20type%20widgets/controller/GetAllQuestionsApiController.dart';
import 'package:blissiqadmin/Home/Quetion%20type%20widgets/question_controller.dart';
import 'package:blissiqadmin/auth/login/login.dart';
import 'package:blissiqadmin/profile/ProfileController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth/Controller/AuthController.dart';
import 'auth/Signup/Splash.dart';
import 'controller/CategoryController.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(CategoryController());
  Get.put(ProfileController());
  Get.put(AuthController());
  Get.put(QuestionController());
  Get.put(GetAllQuestionsApiController());
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _BlissIQAppMyAppState();
}

class _BlissIQAppMyAppState extends State<MyApp> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'BlissIq Admin Panel',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:  SplashScreenPage(),
    );
  }
}

