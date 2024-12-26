import 'dart:convert';
import 'package:blissiqadmin/Global/constants/ApiString.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class SchoolController extends GetxController {
  var nameController = TextEditingController();
  var emailAddress = TextEditingController();
  var schoolRegNumber = TextEditingController();
  var principalName = TextEditingController();
  var phNoController = TextEditingController();
  var addressController = TextEditingController();
  var passwordController = TextEditingController();
  var confirmPasswordController = TextEditingController();

  RxBool isLoading = false.obs;
  var formKey = GlobalKey<FormState>();
  RxBool passwordVisible = false.obs;

  void onCountryChange(CountryCode countryCode) {

  }

  // School Registration API
  Future<void> mentorRegistration({
    required String fullName,
    required String email,
    required String address,
    required String contactNo,
    required String password,
    required String confirmPassword,
    required BuildContext context,
  }) async {
    isLoading.value = true;

    try {
      final response = await http.post(
        Uri.parse(ApiString.school_registration),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          'fullName': fullName,
          'email': email,
          'address': address,
          'contact_no': contactNo,
          'password': password,
          'confirm_password': confirmPassword,
        }),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 201 && responseData['status'] == 1) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseData['message'])),
        );
        clearControllers();
        Get.toNamed('/login'); // Adjust the route as needed
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseData['message'] ?? 'Error occurred')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Clear all controllers
  void clearControllers() {
    nameController.clear();
    emailAddress.clear();
    schoolRegNumber.clear();
    principalName.clear();
    phNoController.clear();
    addressController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
  }
}