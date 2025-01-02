
import 'package:blissiqadmin/Home/HomePage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import '../Global/constants/ApiString.dart';
import '../Global/constants/CommonSizedBox.dart';
import '../Global/utils/shared_preference/shared_preference_services.dart';

class SignupController extends GetxController {
  // Observables for managing loading state
  var isLoading = false.obs;
  String country_code = "+91";


  loginApi({
    required String email,
    required String password,
  }) async {
    isLoading.value = true;

    String? token='';
    print("Token: $token");

    if (token == null || token.isEmpty) {
      _showBottomSheet(
        title: "Error",
        message: "Failed to generate token. Please try again.",
        isSuccess: false,
      );
      isLoading.value = false;
      return;
    }

    try {
      final Map<String, dynamic> body = {
        "email": email,
        "password": password,
        "token": token!,
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
          debugPrint("fcm-token :-  $token");

          // Correcting userId access
          final userId = responseData['user']['_id'];
          final userName = responseData['user']['user_name'];
          final authToken = responseData['user']['token'];

          print("User ID: $userId");
          print("User Name: $userName");
          print("Token: $authToken");

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
          _showBottomSheet(
            title: "Success",
            message: responseData['message'],
            isSuccess: true,
          );

          bool isLoginSuccess = true;
          if (isLoginSuccess) {
            await Future.delayed(const Duration(seconds: 1));
            //Get.to(const Onboarding_Screen());
            // Get.to(() => SignUpScreen());
          }
        } else {
          _showBottomSheet(
            title: "Error",
            message: responseData['message'] ?? "Something went wrong!",
            isSuccess: false,
          );
        }
      }
    } catch (e) {
      _showBottomSheet(
        title: "Error",
        message: "An error occurred: $e",
        isSuccess: false,
      );
    } finally {
      isLoading.value = false;
    }
  }


  var timeLeft = 15.obs;
  var countdownText = "01:00".obs;
  void startTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (timeLeft.value > 0) {
        timeLeft.value--;
        countdownText.value = '00:${timeLeft.value}'; // Update the countdown text
        startTimer(); // Recursively call to create a countdown
      } else {
        countdownText.value = 'Resend Code';
      }
    });
  }

  _showBottomSheet({
    required String title,
    required String message,
    required bool isSuccess,
  }) {
    Get.bottomSheet(
      Container(
        width:  Get.size.width,
        height: Get.size.width * 0.52,
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Icon with larger size
            Icon(
              isSuccess ? Icons.check_circle : Icons.error,
              color: isSuccess ? Colors.green : Colors.red,
              size: 34, // Increased size for better visibility
            ),
            boxH08(),
            Flexible(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isSuccess ? Colors.green : Colors.red,
                ),
                textAlign: TextAlign.center, overflow: TextOverflow.ellipsis,maxLines: 1,
              ),
            ),
            boxH08(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, color: Colors.black87),
              ),
            ),
          ],
        ),
      ),
    );
    Future.delayed(const Duration(seconds: 1), () {
      Get.back();
    });
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

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Password must contain at least one uppercase letter';
    }
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Password must contain at least one lowercase letter';
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Password must contain at least one digit';
    }
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
      return 'Password must contain at least one special character';
    }
    return null; // Return null if the password is valid
  }

  String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != password) {
      return 'Passwords do not match';
    }
    return null; // Passwords match
  }

}

