import 'dart:convert';
import 'dart:developer';
import 'package:blissiqadmin/Global/Routes/AppRoutes.dart';
import 'package:blissiqadmin/Global/constants/ApiString.dart';
import 'package:blissiqadmin/Global/constants/common_snackbar.dart';
import 'package:blissiqadmin/Global/utils/shared_preference/shared_preference_services.dart';
import 'package:blissiqadmin/Home/Users/Models/AllSchoolModel.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class SchoolController extends GetxController {
  bool isLogin = false;

  // Form field controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final phNoController = TextEditingController();
  final addressController = TextEditingController();
  final schoolNameController = TextEditingController();
  final schoolRegNumberController = TextEditingController();
  final principalNameController = TextEditingController();
  final principalEmailController = TextEditingController();
  final principalPhoneController = TextEditingController();

  final schoolTypeController = TextEditingController();
  final affiliatedCompanyController = TextEditingController();
  final approvalStatusController = TextEditingController();
  final statusController = TextEditingController();

  RxBool isLoading = false.obs;

  // Password visibility toggle
  final isPasswordVisible = false.obs;
  final isConfirmPasswordVisible = false.obs;

  // Form key
  final formKey = GlobalKey<FormState>();
  RxString userId = "".obs;
  RxList<Data> allSchoolData = <Data>[].obs;


  void onCountryChange(CountryCode countryCode) {
    String code = countryCode.dialCode ?? '+1';
    phNoController.text = '$code ${phNoController.text.replaceAll(RegExp(r'^\+\d+\s?'), '')}';
  }

  // Dispose controllers when the screen is removed
  clearControllers() {
    nameController.clear();
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    phNoController.clear();
    addressController.clear();
    schoolNameController.clear();
    schoolRegNumberController.clear();
    principalNameController.clear();
    principalEmailController.clear();
    principalPhoneController.clear();
    super.onClose();
  }


  schoolRegistrationApi({
    required String schoolName,
    required String schoolRegNumber,
    required String principalName,
    required String principalEmail,
    required String principalPhone,
    required String address,
    required String schoolType,
    required String affiliatedCompany,
    required String password,
    required String confirmPassword,
    required BuildContext context,
  }) async {
    isLoading.value = true;

    try {
      final response = await http.post(
        Uri.parse(ApiString.school_registration),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer YOUR_TOKEN",
        },
        body: jsonEncode({
          'schoolName': schoolName,
          'schoolRegNumber': schoolRegNumber,
          'principalName': principalName,
          'principalEmail': principalEmail,
          'principalPhone': principalPhone,
          'address': address,
          'schoolType': schoolType,
          'affiliatedCompany': affiliatedCompany,
          'status': "",// optional
          'token': "",// optional
          'company_id': "",// optional
          'approval_status': "",// optional
          'password': password,
          'confirm_password': confirmPassword,
        }),
      );

      final responseData = jsonDecode(response.body);
      print(responseData);
      if (response.statusCode == 201 && responseData['status'] == 1) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseData['message'])),
        );
        getAllSchools();
        // Get.back();
        clearControllers();
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


  getAllSchools() async {
    isLoading.value = true;
    allSchoolData.clear();
    try {
      final response = await http.post(
        Uri.parse(ApiString.get_all_schools),
        headers: {"Content-Type": "application/json"},
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);

        if (responseData['status'] == 1) {
          // Parse each JSON object into a Data model
          allSchoolData.value = (responseData["data"] as List)
              .map((mentorJson) => Data.fromJson(mentorJson))
              .toList();
        } else {
          showSnackbar(message: "Failed to fetch school data");
        }
      }
    } catch (e) {
      showSnackbar(message: "Error while fetching school data $e");
      log(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  delete_school(String user_id) async {
    isLoading.value = true;

    try {
      final Map<String, dynamic> body = {
        "school_id": user_id,
      };

      final response = await http.delete(
        Uri.parse(ApiString.delete_schools),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);

        if (responseData['status'] == 1) {
          // Parse each JSON object into a Data model
          showSnackbar(message: "Deleted successfully");
        } else {
          showSnackbar(message: "Failed to delete school");
        }
      }
    } catch (e) {
      showSnackbar(message: "Error while deleting school $e");
      log(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  approveSchool({required String school_id, required String approval_status}) async {
    isLoading.value = true;
    var body = {
      "school_id": school_id,
      "approval_status": approval_status,
    };

    try {
      final response = await http.post(
        Uri.parse(ApiString.approve_school),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);

        if (responseData['status'] == 1) {
          print("response approve mentor: ${responseData['message']}");
          showSnackbar(message: responseData['message']);

          // Fetch updated mentor list after approval
          await getAllSchools(); // Ensure this completes before proceeding
        } else {
          showSnackbar(message: responseData['message']);
        }
      }
    } catch (e) {
      showSnackbar(message: "Error $e");
      log(e.toString());
    } finally {
      isLoading.value = false;
    }
  }


   assignSchoolApi({
    required String schoolId,
    required String companyId,
  }) async {
    isLoading.value = true;
    try {
      final Map<String, dynamic> body = {
        "school_id": schoolId,
        "company_id": companyId,
      };

      final response = await http.post(
        Uri.parse(ApiString.assign_school),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        if (responseData['status'] == 1) {
          print("School assigned successfully");
          Fluttertoast.showToast(
            msg: "School assigned successfully!",
            backgroundColor: Colors.green,
          );
        } else {
          Fluttertoast.showToast(
            msg: responseData['message'] ?? "Something went wrong!",
            backgroundColor: Colors.red,
          );
        }
      } else if (response.statusCode == 400) {
        // Handle 400 response status
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        Fluttertoast.showToast(
          msg: responseData['message'] ?? "Bad Request!",
          backgroundColor: Colors.orange,
        );
        print("Error 400: ${responseData['message']}");
      } else {
        Fluttertoast.showToast(
          msg: "Unexpected error occurred. Please try again.",
          backgroundColor: Colors.red,
        );
        print("Unexpected status: ${response.statusCode}, Body: ${response.body}");
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "An error occurred: $e",
        backgroundColor: Colors.red,
      );
      print("Exception: $e");
    } finally {
      isLoading.value = false;
    }
  }


}