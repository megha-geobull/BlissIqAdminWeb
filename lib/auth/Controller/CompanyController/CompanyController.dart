import 'dart:convert';
import 'dart:developer';

import 'package:blissiqadmin/Global/Routes/AppRoutes.dart';
import 'package:blissiqadmin/Global/constants/ApiString.dart';
import 'package:blissiqadmin/Global/constants/common_snackbar.dart';
import 'package:blissiqadmin/Global/utils/shared_preference/shared_preference_services.dart';
import 'package:blissiqadmin/Home/HomePage.dart';
import 'package:blissiqadmin/Home/Users/Models/GetSchoolsAssignModel.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import '../../../Home/Users/Models/GetAllCompanyModel.dart';

class CompanyController extends GetxController{

  var ownerNameController = TextEditingController();
  var companyNameController = TextEditingController();
  var emailController = TextEditingController();
  var phNoController = TextEditingController();

  var passwordController = TextEditingController();
  var confirmPasswordController = TextEditingController();
  var cinNumber = TextEditingController();
  var panCardNo = TextEditingController();
  var gstNumber = TextEditingController();


  RxBool isLoading = false.obs;
  var formKey = GlobalKey<FormState>();
  RxBool passwordVisible = false.obs;
  RxBool confirmPasswordVisible = false.obs;
  var currentCountryCode = "IN-91".obs;
  var selectedUserType = 'Mentor'.obs;

  RxList<Data> allCompanyData = <Data>[].obs;
  RxList<AllAssignedSchoolsData> allAssignSchoolData = <AllAssignedSchoolsData>[].obs;

  RxString userId = "".obs;




  // Handle country code change
  void onCountryChange(CountryCode countryCode) {
    currentCountryCode.value =
    '${countryCode.code}-${countryCode.dialCode}';
  }

  // Clear all controllers
  @override
  void onClose() {
    clearControllers();
    super.onClose();
  }

  void clearControllers() {
    companyNameController.clear();
    ownerNameController.clear();
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    phNoController.clear();

  }




  void handleSignUp(BuildContext context) {
    if (formKey.currentState!.validate()) {
      // TODO: Implement sign-up functionality
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Signing Up...')),
      );
    }
  }

  /// Admin login api

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


  /// company Registration API
  companyRegistration({
    required String companyName,
    required String ownerName,
    required String panCardNo,
    required String cinNumber,
    required String gstNumber,
    required String email,
    required String contactNo,
    required String password,
    required BuildContext context,
    List<int>? profileImageBytes,
  }) async {
    isLoading.value = true;

    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse(ApiString.company_registration),
      );

      // Prepare the request body
      request.fields.addAll({
        'owner_name': ownerName,
        'company_name': companyName,
        'email': email,
        'contact_no': contactNo,
        'password': password,
        'gst_number':gstNumber,
        'cin_number':cinNumber,
        'pan_card': '',
        'token':''
      });

      // Attach profile image if selected
      if (profileImageBytes != null) {
        final multipartFile = http.MultipartFile.fromBytes(
          'profile_pic', profileImageBytes,
          filename: 'profile_pic',
          contentType: MediaType('image', 'jpeg'),
        );
        request.files.add(multipartFile);
      }


      final response = await request.send();
      final responseData = jsonDecode(await response.stream.bytesToString());
      print(responseData);
      if (response.statusCode == 201 && responseData['status'] == 1) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseData['message'])),
        );
        clearControllers();
        Get.toNamed(AppRoutes.mentorPage);
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

  getAllCompany() async {
    isLoading.value = true;

    try {
      final response = await http.get(
        Uri.parse(ApiString.get_all_companies),
        headers: {"Content-Type": "application/json"},
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        if (responseData['status'] == 1) {
          // Parse each JSON object into a Data model
          allCompanyData.value = (responseData["data"] as List)
              .map((mentorJson) => Data.fromJson(mentorJson))
              .toList();

          print("Fetched ${allCompanyData.length} company");
        } else {
          showSnackbar(message: responseData['message'] ?? "Failed to fetch company");
        }
      } else {
        showSnackbar(message: "Failed to fetch company. Status: ${response.statusCode}");
      }
    } catch (e) {
      showSnackbar(message: "Error while fetching company: $e");
      log(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  approveCompany({required String companyID, required String approvalStatus}) async {
    isLoading.value = true;
    var body = {
      "company_id": companyID,
      "status": approvalStatus,
    };

    try {
      final response = await http.post(
        Uri.parse(ApiString.approve_company),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);

        if (responseData['status'] == 1) {
          print("response approve company: ${responseData['message']}");
          showSnackbar(message: responseData['message']);

          await getAllCompany();
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

  // Get user ID from local storage
  getUserId() async {
    return await getDataFromLocalStorage(
      dataType: "STRING",
      prefKey: "user_id",
    ) as String?;
  }

  assignSchoolApi({
    required String company_id,
    required String school_id,
  }) async {
    isLoading.value = true;
    try {
      final Map<String, dynamic> body = {
        "company_id": company_id,
        "school_id": school_id,
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

          if (kDebugMode) {
            print("School assigned successfully");

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



  getAssignedSchoolsApi(String companyID) async {
    isLoading.value = true;

    try {
      final body = jsonEncode({
        "company_id": companyID,
      });

      final response = await http.post(
        Uri.parse(ApiString.get_assign_schools),
        headers: {
          "Content-Type": "application/json",
        },
        body: body,
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        var responseData = GetSchoolsAssignModel.fromJson(jsonDecode(response.body));
        if (responseData.status == 1) {
          allAssignSchoolData.value = responseData.data;
          print("Fetched ${allAssignSchoolData.value.length} assigned schools");
        } else {
          showSnackbar(message: "Failed to fetch assigned schools");
        }
      } else {
        showSnackbar(message: "Failed to fetch assigned schools. Status: ${response.statusCode}");
      }
    } catch (e) {
      showSnackbar(message: "Error while fetching assigned schools: $e");
      log(e.toString());
    } finally {
      isLoading.value = false;
    }
  }


}

