// NavigationBar/MyDrawer.dart

import 'package:blissiqadmin/Global/constants/CommonSizedBox.dart';
import 'package:blissiqadmin/Home/Drawer/MainCategoriesPage.dart';
import 'package:blissiqadmin/Home/Drawer/Notification.dart';
import 'package:blissiqadmin/Home/Drawer/QuestionWidgets.dart';
import 'package:blissiqadmin/Home/Drawer/SettingsPage.dart';
import 'package:blissiqadmin/Home/Drawer/UsersPage.dart';
import 'package:blissiqadmin/Home/HomePage.dart';
import 'package:blissiqadmin/Home/Quetion%20type%20widgets/AddQuetionsWidgets/AddQuetionsWidgets.dart';
import 'package:blissiqadmin/auth/login/login.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Global/utils/shared_preference/shared_preference_services.dart';

class DrawerController extends GetxController {
  var selectedPage = 'Dashboard'.obs;

  void changePage(String page) {
    selectedPage.value = page;
  }
}

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  final DrawerController controller = Get.put(DrawerController());
  final String profileImage = "assets/icons/icon_white.png";

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: MyDrawer(),
    );
  }

  void onLogoutTap() {
    clearLocalStorage();
    //  isLogin = false;
    setState(() {});
    Get.offAll(LoginScreen());
  }

  Widget MyDrawer() {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        DrawerHeader(
          decoration: BoxDecoration(
            color: Colors.orange.shade100,
          ),
          child: Column(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: Colors.deepOrange.shade50,
                child: ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: profileImage,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Dashboard',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        // Dashboard
        Obx(() => buildDrawerTile(
              title: 'Dashboard',
              icon: Icons.dashboard,
              isSelected: controller.selectedPage.value == 'Dashboard',
              onTap: () {
                controller.changePage('Dashboard');
                Get.to(() => HomePage());

              },
            )),
        // Users
        Obx(() => buildDrawerTile(
              title: 'Users',
              icon: Icons.people,
              isSelected: controller.selectedPage.value == 'Users',
              onTap: () {
                controller.changePage('Users');
                Get.to(() => UsersPage());

              },
            )),
        // Categories
        Obx(() => buildDrawerTile(
              title: 'Categories',
              icon: Icons.category,
              isSelected: controller.selectedPage.value == 'Categories',
              onTap: () {
                controller.changePage('Categories');
                Get.to(() => const MainCategoriesPage());

              },
            )),
        Obx(() => buildDrawerTile(
          title: 'Question Widgets',
          icon: Icons.question_answer,
          isSelected: controller.selectedPage.value == 'Question Widgets',
          onTap: () {
            controller.changePage('Question Widgets');
            Get.to(() =>  AddQuestionsWidgets());
          },
        )),


        // Settings
        Obx(() => buildDrawerTile(
              title: 'Notification',
              icon: Icons.settings,
              isSelected: controller.selectedPage.value == 'Notification',
              onTap: () {
                controller.changePage('Notification');
                Get.to(() => const NotificationPage());

              },
            )),
        // Logout
        Obx(() => buildDrawerTile(
              title: 'Logout',
              icon: Icons.logout,
              isSelected: controller.selectedPage.value == 'Logout',
              onTap: () {
                controller.changePage('Logout');
                _showLogoutDialog(context);
              },
            )),
      ],
    );
  }

  Widget buildDrawerTile({
    required String title,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: isSelected ? Colors.orange : Colors.black),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? Colors.orange : Colors.black,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      tileColor: isSelected ? Colors.orange.shade50 : Colors.transparent,
      onTap: onTap,
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: const Text(
            'Logout Confirmation',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text(
            'Are you sure you want to logout?',
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel',style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,),),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Logout',style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
            ),
          ],
        );
      },
    );
  }

}

