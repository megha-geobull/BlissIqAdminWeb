import 'package:blissiqadmin/Global/Widgets/Button/CustomButton.dart';
import 'package:blissiqadmin/Global/constants/CommonSizedBox.dart';
import 'package:blissiqadmin/Global/constants/CustomTextField.dart';
import 'package:blissiqadmin/Home/Controller/ChangePasswordController.dart';
import 'package:blissiqadmin/Home/Drawer/MyDrawer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {

  final TextEditingController userIdController = TextEditingController();
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
  TextEditingController();

  final ChangePasswordController controller = Get.put(ChangePasswordController());



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Check screen size for responsiveness
          bool isWideScreen = constraints.maxWidth > 800;

          return Row(
            children: [
              // Always visible drawer for wide screens
              if (isWideScreen)
                Container(
                  width: 250,
                  color: Colors.orange.shade100,
                  child: MyDrawer(),
                ),
              Expanded(
                child: Scaffold(
                  appBar: isWideScreen
                      ? null
                      : AppBar(
                    title: const Text('Dashboard'),
                    scrolledUnderElevation: 0,
                    backgroundColor: Colors.blue.shade100,
                    actions: [
                      IconButton(
                        icon: const Icon(
                          Icons.person,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          // Handle notifications
                        },
                      ),
                    ],
                  ),
                  drawer: isWideScreen ? null : Drawer(child: MyDrawer()),
                  body: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 16),
                    child: _buildMainContent(constraints),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMainContent(BoxConstraints constraints) {
    return Center(
      child: Container(
        width: constraints.maxWidth * 0.5,
        height: constraints.maxWidth * 0.48,
        constraints: const BoxConstraints(
          maxWidth: 600,
        ),
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child:  Padding(
          padding: const EdgeInsets.symmetric(vertical: 22.0, horizontal: 16.0),
          child: Obx(
                () => controller.isLoading.value
                ? const Center(
              child: CircularProgressIndicator(),
            )
                : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Change Password",style: TextStyle(
                    fontSize: 22, fontWeight: FontWeight.bold
                  ),),
                  boxH20(),
                  const Text("Old Password",style: TextStyle(
                    fontSize: 17,
                  ),),
                  boxH08(),
                  CustomTextField(
                    controller: oldPasswordController,
                    labelText: "Old Password",
                    keyboardType: TextInputType.visiblePassword,
                    prefixIcon: const Icon(Icons.password_outlined),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter your password';
                      }
                      return null;
                    },
                    obscureText: !controller.passwordVisible.value,
                    sufixIcon: IconButton(
                      icon: Icon(controller.passwordVisible.value
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          controller.passwordVisible.value = !controller.passwordVisible.value;
                        });
                      },
                    ),
                  ),
                  boxH20(),

                  const Text("New Password",style: TextStyle(
                    fontSize: 17,
                  ),),
                  boxH08(),
                  CustomTextField(
                    controller: newPasswordController,
                    labelText: "New Password",
                    keyboardType: TextInputType.visiblePassword,
                    prefixIcon: const Icon(Icons.password_outlined),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter your password';
                      }
                      return null;
                    },
                    obscureText: !controller.passwordVisible.value,
                    sufixIcon: IconButton(
                      icon: Icon(controller.passwordVisible.value
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          controller.passwordVisible.value =
                          !controller.passwordVisible.value;
                        });
                      },
                    ),
                  ),
                  boxH20(),
                  const Text("Confirm Password",style: TextStyle(
                    fontSize: 17,
                  ),),
                  boxH08(),
                  CustomTextField(
                    controller: confirmPasswordController,
                    labelText: "Confirm Password",
                    keyboardType: TextInputType.visiblePassword,
                    prefixIcon: const Icon(Icons.password_outlined),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter your password';
                      }
                      return null;
                    },
                    obscureText: !controller.passwordVisible.value,
                    sufixIcon: IconButton(
                      icon: Icon(controller.passwordVisible.value
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          controller.passwordVisible.value =
                          !controller.passwordVisible.value;
                        });
                      },
                    ),
                  ),

                  boxH50(),
                  CustomButton(
                    onPressed: () {
                      controller.changePassword(
                        oldPassword: oldPasswordController.text.trim(),
                        newPassword: newPasswordController.text.trim(),
                        confirmPassword: confirmPasswordController.text.trim(),
                      );
                    },
                    label: 'Change Password',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
