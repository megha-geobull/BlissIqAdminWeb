// NavigationBar/MyDrawer.dart

import 'package:blissiqadmin/Global/constants/CommonSizedBox.dart';
import 'package:blissiqadmin/Home/Drawer/MainCategoriesPage.dart';
import 'package:blissiqadmin/Home/Drawer/SettingsPage.dart';
import 'package:blissiqadmin/Home/Drawer/UsersPage.dart';
import 'package:blissiqadmin/Home/HomePage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
      child: MyDrawer(),
    );
  }

  void onLogoutTap() {}
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
                Get.to(HomePage());
              },
            )),
        // Users
        Obx(() => buildDrawerTile(
              title: 'Users',
              icon: Icons.people,
              isSelected: controller.selectedPage.value == 'Users',
              onTap: () {
                controller.changePage('Users');
                Get.to(UsersPage());
              },
            )),
        // Categories
        Obx(() => buildDrawerTile(
              title: 'Categories',
              icon: Icons.category,
              isSelected: controller.selectedPage.value == 'Categories',
              onTap: () {
                controller.changePage('Categories');
                Get.to(const MainCategoriesPage());
              },
            )),
        // Settings
        Obx(() => buildDrawerTile(
              title: 'Settings',
              icon: Icons.settings,
              isSelected: controller.selectedPage.value == 'Settings',
              onTap: () {
                controller.changePage('Settings');
                Get.to(SettingsPage());
              },
            )),
        // Logout
        Obx(() => buildDrawerTile(
              title: 'Logout',
              icon: Icons.logout,
              isSelected: controller.selectedPage.value == 'Logout',
              onTap: () {
                controller.changePage('Logout');
                onLogoutTap();
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
}

