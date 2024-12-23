import 'package:blissiqadmin/Home/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller/CategoryController.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(CategoryController());
  Get.put(CategoryController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
      home:  HomePage(),
    );
  }
}

