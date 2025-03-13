import 'dart:convert';
import 'dart:developer';

import 'package:blissiqadmin/Global/Routes/AppRoutes.dart';
import 'package:blissiqadmin/Global/constants/ApiString.dart';
import 'package:blissiqadmin/Global/constants/CommonSizedBox.dart';
import 'package:blissiqadmin/Global/constants/common_snackbar.dart';
import 'package:blissiqadmin/Global/utils/shared_preference/shared_preference_services.dart';
import 'package:blissiqadmin/Home/HomePage.dart';
import 'package:blissiqadmin/Home/Users/Models/AllStudentModel.dart' as student;
import 'package:blissiqadmin/Home/Users/Models/GetAllMentorModel.dart' as mentor;
import 'package:blissiqadmin/Home/Users/Models/GetMentorsAssignModel.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';

import '../../profile/ProfileController.dart';
import '../../push_notification/functions.dart';

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

  RxBool isLoading = false.obs;
  var formKey = GlobalKey<FormState>();
  RxBool passwordVisible = false.obs;
  RxBool confirmPasswordVisible = false.obs;
  var currentCountryCode = "IN-91".obs;
  var selectedUserType = 'Mentor'.obs;

  final TextEditingController searchController = TextEditingController();

  var selectedSchoolId = ''.obs;
  var selectedSchoolName = ''.obs;
  final selectedSchoolAddress = ''.obs;
  final selectedSchoolLat = "".obs;
  final selectedSchoolLng = "".obs;


  RxList<mentor.Data> allMentorData = <mentor.Data>[].obs;
  RxList<student.Data> assignStudentsData = <student.Data>[].obs;
  RxString userId = "".obs;

  RxList<AllAssignedMentorsData> allAssignMentorData = <AllAssignedMentorsData>[].obs;

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
    nameController.clear();
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    phNoController.clear();
    addressController.clear();
    experienceController.clear();
    qualificationController.clear();
    introBio.clear();
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

          // clearLocalStorage();
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
          Get.find<ProfileController>().checkLogin();
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


  registerNewSchool({
    required String name,
    required String address,
    String? latitude,
    String? longitude,
  }) async {
    isLoading.value = true;
    selectedSchoolId.value = '';
    try {
      final Map<String, dynamic> body = {
        "schoolName": name,
        "address": address,
        "latitude": latitude ?? '',
        "longitude": longitude ?? '',
      };

      final response = await http.post(
        Uri.parse(ApiString.school_registration),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 201) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        if (responseData['status'] == 1) {
          selectedSchoolId.value = responseData['data']['_id'];
          return true;
        } else {
          _showBottomSheet(
            title: "Error",
            message: responseData['message'] ?? "Something went wrong!",
            isSuccess: false,
          );
          return false;
        }
      } else {
        _showBottomSheet(
          title: "Error",
          message: "Something went wrong!",
          isSuccess: false,
        );
        return false;
      }
    } catch (e) {
      _showBottomSheet(
        title: "Error",
        message: "An error occurred: $e",
        isSuccess: false,
      );
      return false;
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


  /// Mentor Registration API
  mentorRegistration({
    required String userType,
    required String fullName,
    required String email,
    required String address,
    required String contactNo,
    required String experience,
    required String qualification,
    required String introBio,
    required String password,
    required String confirmPassword,
    required BuildContext context,
    List<int>? profileImageBytes,
    required String schoolId,
    required String schoolName,

  }) async {
    isLoading.value = true;

    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse(ApiString.mentor_registration),
      );

      // Prepare the request body
      request.fields.addAll({
        'userType': userType,
        'fullName': fullName,
        'email': email,
        'address': address,
        'contact_no': contactNo,
        'experience': experience,
        'qualification': qualification,
        'introBio': introBio,
        'password': password,
        'confirm_password': confirmPassword,
        'school_id':schoolId,
        'school_name':schoolName
      });

      // Attach profile image if selected
      if (profileImageBytes != null) {
        final multipartFile = http.MultipartFile.fromBytes(
          'profile_image',
          profileImageBytes,
          filename: 'profile_image',
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
        final Map<String, dynamic> userData = responseData['data'];
        final userId = userData['_id'];
        final userName = userData['fullName'];
        Functions.setAvailability(
            name: userName,
            email: email,
            phone: contactNo.toString(),
            isEngaged: "false",
            userType: userType,
            userID: userId.toString(),
            fcmToken: '',
            status: "Offline");
        getAllMentors();
        clearControllers();
        //  Get.toNamed(AppRoutes.mentorPage);
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


  /// get all mentors
  getAllMentors() async {
    isLoading.value = true;

    try {
      final response = await http.post(
        Uri.parse(ApiString.get_all_mentors),
        headers: {"Content-Type": "application/json"},
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        if (responseData['status'] == 1) {
          // Parse each JSON object into a Data model
          allMentorData.value = (responseData["data"] as List)
              .map((mentorJson) => mentor.Data.fromJson(mentorJson))
              .toList();

          print("Fetched ${allMentorData.length} mentors");
        } else {
          showSnackbar(message: responseData['message'] ?? "Failed to fetch mentors");
        }
      } else {
        showSnackbar(message: "Failed to fetch mentors. Status: ${response.statusCode}");
      }
    } catch (e) {
      showSnackbar(message: "Error while fetching mentors: $e");
      log(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  delete_mentors(String user_id) async {
    isLoading.value = true;

    try {
      final Map<String, dynamic> body = {
        "mentor_id": user_id,
      };

      final response = await http.delete(
        Uri.parse(ApiString.delete_mentors),
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
          showSnackbar(message: "Failed to delete mentor");
        }
      }
    } catch (e) {
      showSnackbar(message: "Error while deleting mentor $e");
      log(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  getAssignedMentorsApi(String mentorId) async {
    isLoading.value = true;

    try {
      final body = jsonEncode({
        "school_id": mentorId,
      });

      final response = await http.post(
        Uri.parse(ApiString.get_assign_teachers),
        headers: {
          "Content-Type": "application/json",
        },
        body: body,
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        var responseData = GetMentorsAssignModel.fromJson(jsonDecode(response.body));
        if (responseData.status == 1) {
          allAssignMentorData.value = responseData.data;
          print("Fetched ${allAssignMentorData.value.length} assigned mentor");
        } else {
          showSnackbar(message: "Failed to fetch assigned mentors");
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

  getAssignedStudentsApi(String schoolID) async {
    isLoading.value = true;
    assignStudentsData.clear();
    try {
      final body = jsonEncode({
        "school_id": schoolID,
      });

      final response = await http.post(
        Uri.parse(ApiString.get_all_learners),
        headers: {
          "Content-Type": "application/json",
        },
        body: body,
      );

      print('request body and api : ${body} ${ApiString.get_all_learners}');
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);

        if (responseData['status'] == 1) {
          // Parse each JSON object into a Data model
          assignStudentsData.value = (responseData["data"] as List)
              .map((mentorJson) => student.Data.fromJson(mentorJson))
              .toList();
        } else {
          showSnackbar(message: "Failed to fetch Learners");
        }
      }
    } catch (e) {
      showSnackbar(message: "Error while fetching assigned students: $e");
      log(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  approveMentors({required String mentor_id, required String approval_status}) async {
    isLoading.value = true;
    var body = {
      "mentor_id": mentor_id,
      "approval_status": approval_status,
    };

    try {
      final response = await http.post(
        Uri.parse(ApiString.approve_mentor),
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
          await getAllMentors(); // Ensure this completes before proceeding
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

  assignMentorApi({
    required String mentorId,
    required String studentId,
  }) async {
    isLoading.value = true;
    try {
      final Map<String, dynamic> body = {
        "user_id": studentId,
        "mentor_id": mentorId,
      };

      final response = await http.post(
        Uri.parse(ApiString.assign_mentor),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        if (responseData['status'] == 1) {

          if (kDebugMode) {
            print("Mentor assigned successfully");

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
}

