import 'dart:convert';
import 'package:blissiqadmin/Global/Routes/AppRoutes.dart';
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
  schoolRegistration({
    required String schoolName,
    required String schoolRegNumber,
    required String principalName,
    required String principalEmail,
    required String principalPhone,
    required String address,
    required String schoolType,
    required String password,
    required String confirm_password,
    required BuildContext context,
    String? company_id,
    String? affiliatedCompany,
    String? status,
    String? token,
  }) async {
    // Indicate loading state
    isLoading.value = true;

    try {
      // Create request body
      final body = {
        'schoolName': schoolName,
        'schoolRegNumber': schoolRegNumber,
        'principalName': principalName,
        'principalEmail': principalEmail,
        'principalPhone': principalPhone,
        'address': address,
        'schoolType': schoolType,
        'password': password,
        'confirm_password': confirm_password,
        if (affiliatedCompany != null) 'affiliatedCompany': affiliatedCompany,
        if (company_id != null) 'company_id': company_id,
        if (status != null) 'status': status,
        if (token != null) 'token': token,
      };

      // Send HTTP POST request
      final response = await http.post(
        Uri.parse(ApiString.school_registration),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(body),
      );

      // Parse response
      final responseData = jsonDecode(response.body);

      if (response.statusCode == 201 && responseData['status'] == 1) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseData['message'])),
        );
        clearControllers(); // Reset input fields
        Get.toNamed(AppRoutes.schoolPage);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseData['message'] ?? 'Error occurred')),
        );
      }
    } catch (e) {
      // Handle errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    } finally {
      // Reset loading state
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