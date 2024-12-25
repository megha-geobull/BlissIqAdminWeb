import 'package:country_code_picker/country_code_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../Global/constants/ApiString.dart';
import '../../Global/utils/shared_preference/shared_preference_services.dart';
import '../../Home/HomePage.dart';

class AuthController extends GetxController{

  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var confirmPasswordController = TextEditingController();
  var phNoController = TextEditingController();
  var addressController = TextEditingController();
  var experienceController = TextEditingController();
  var qualificationController = TextEditingController();
  var languagesController = TextEditingController();
  var introBio = TextEditingController();
  var isLoading = false.obs;

  // Form key for validation
  var formKey = GlobalKey<FormState>();

  // Toggle password visibility
  var isPasswordVisible = false.obs;
  var isConfirmPasswordVisible = false.obs;
  var currentCountryCode = "IN-91".obs;
  var selectedUserType = 'Mentor'.obs;

  // Method to handle country code change
  void onCountryChange(CountryCode countryCode) {
    currentCountryCode.value = countryCode.code! + "-" + countryCode.toString().replaceAll("+", "");
  }

  @override
  void onClose() {
    // Dispose the controllers when the controller is disposed
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    phNoController.dispose();
    addressController.dispose();
    experienceController.dispose();
    qualificationController.dispose();
    languagesController.dispose();
    introBio.dispose();
    super.onClose();
  }

  // Method to handle sign-up logic
  void handleSignUp(BuildContext context) {
    if (formKey.currentState!.validate()) {
      // TODO: Implement sign-up functionality
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Signing Up...')),
      );
    }
  }

  loginApi({
    required String email,
    required String password,
  }) async {
    isLoading.value = true;

    try {
      final Map<String, dynamic> body = {
        "email": email,
        "password": password,
        "token": '',
      };

      final response = await http.post(
        Uri.parse(ApiString.login),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        if (responseData['status'] == 1) {

          // Correcting userId access
          final userId = responseData['user']['_id'];
          final userName = responseData['user']['user_name'];
          //final authToken = responseData['user']['token'];

          print("User ID: $userId");
          print("User Name: $userName");
          //print("Token: $authToken");

          clearLocalStorage();
          await setDataToLocalStorage(
            dataType: "STRING",
            prefKey: "user_id",
            stringData: userId,
          );
          await setDataToLocalStorage(
            dataType: "STRING",
            prefKey: "user_name",
            stringData: userName,
          );
          print("User ID after set data: $userId");

          bool isLoginSuccess = true;
          if (isLoginSuccess) {
            await Future.delayed(const Duration(seconds: 2));
            Get.to(HomePage());
          }
        } else {
          Fluttertoast.showToast(
            msg: responseData['message'] ?? "Something went wrong!",
            backgroundColor: Colors.red,
          );
        }
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "An error occurred: $e",
        backgroundColor: Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }

    // Regular expression for email validation
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value)) {
      return 'Enter a valid email address';
    }

    return null; // Return null if the email is valid
  }

}

