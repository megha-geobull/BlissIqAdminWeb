import 'dart:async';
import 'package:blissiqadmin/Global/MyCustomScrollBehaviour.dart';
import 'package:blissiqadmin/Home/HomePage.dart';
import 'package:blissiqadmin/Home/LeaderboardController/LeaderboardController.dart';
import 'package:blissiqadmin/Home/Quetion%20type%20widgets/controller/GetAllQuestionsApiController.dart';
import 'package:blissiqadmin/Home/Quetion%20type%20widgets/question_controller.dart';
import 'package:blissiqadmin/auth/login/login.dart';
import 'package:blissiqadmin/profile/ProfileController.dart';
import 'package:blissiqadmin/push_notification/app_notification.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Global/MyCustomScrollBehaviour.dart';
import 'Home/Controller/Complaint_Controller.dart';
import 'Home/Controller/DashBoardEntrollmentController.dart';
import 'auth/Controller/AuthController.dart';
import 'auth/Signup/Splash.dart';
import 'controller/CategoryController.dart';
import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(CategoryController());
  Get.put(ProfileController());
  Get.put(AuthController());
  Get.put(QuestionController());
  Get.put(GetAllQuestionsApiController());
  Get.put(ComplaintController());
  Get.put(DashBoardController());
  Get.put(LeaderboardController());
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);
  AppNotificationHandler.firebaseNotificationSetup();
  AppNotificationHandler.getInitialMsg();
  AppNotificationHandler.showMsgHandler();
  AppNotificationHandler.onMsgOpen();
 // debugPaintSizeEnabled = true;
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

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'BlissIq Admin Panel',
      debugShowCheckedModeBanner: false,
      scrollBehavior: MyCustomScrollBehavior(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:  SplashScreenPage(),
    );
  }
}

