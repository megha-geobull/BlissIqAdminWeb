import 'package:country_code_picker/country_code_picker.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

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
}

