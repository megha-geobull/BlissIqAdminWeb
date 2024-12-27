import 'package:blissiqadmin/Home/HomePage.dart';
import 'package:blissiqadmin/Home/Users/Mentor/MentorRegistration.dart';
import 'package:blissiqadmin/Home/Users/Mentor/MentorScreen.dart';
import 'package:blissiqadmin/Home/Users/School/SchoolScreen.dart';
import 'package:blissiqadmin/profile/ProfilePage.dart';
import 'package:blissiqadmin/splash/SplashView.dart';
import 'package:get/get.dart';


class AppRoutes {
  static const splash = '/splash';
  static const intro = '/intro';
  static const mentor = '/mentor';
  static const login = '/login';
  static const home = '/home';
  static const userselection = '/userselection';
  static const bottom = '/bottom';
  static const profile = '/profile';
  static const studentList = '/students';
  static const mentorPage = '/mentorPage';
  static const schoolPage = '/schoolPage';

  static final routes = [
    GetPage(
      name: splash,
      page: () => SplashScreen(),
    ),
    // GetPage(name: intro, page: () => IntroductionScreen()),
    GetPage(name: home, page: () => HomePage()),
    GetPage(name: mentor, page: () => MentorRegistration()),
    // GetPage(name: login, page: () => LoginScreen(userType: '',)),
    GetPage(name: profile, page: ()=> ProfilePage()),


    GetPage(name: mentorPage, page: ()=> MentorScreen()),
    GetPage(name: schoolPage, page: ()=> SchoolScreen()),


  ];
}
