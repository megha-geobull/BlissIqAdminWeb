import 'package:blissiqadmin/Global/Routes/AppRoutes.dart';
import 'package:blissiqadmin/Global/constants/ApiString.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../Global/utils/shared_preference/shared_preference_services.dart';
import '../../Home/HomePage.dart';


class AuthController extends GetxController {
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var confirmPasswordController = TextEditingController();
  var phNoController = TextEditingController();
  var addressController = TextEditingController();
  var experienceController = TextEditingController();
  var qualificationController = TextEditingController();

  var introBioController = TextEditingController();

  RxBool isLoading = false.obs;
  var languagesController = TextEditingController();
  var introBio = TextEditingController();
  var formKey = GlobalKey<FormState>();
  RxBool passwordVisible = false.obs;
  RxBool confirmPasswordVisible = false.obs;
  var currentCountryCode = "IN-91".obs;
  var selectedUserType = 'Mentor'.obs;

  List<PlatformFile>? _paths;
  var pathsFile;
  var pathsFileName;

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
    introBioController.clear();
  }


  // File picker for profile image
   pickFile() async {
    _paths = (await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: false,
      onFileLoading: (FilePickerStatus status) => print("status .... $status"),
      allowedExtensions: ['png', 'jpg', 'jpeg', 'heic'],
    ))?.files;

    if (_paths != null && _paths!.isNotEmpty) {
      pathsFile = _paths!.first.bytes; // Store the bytes
      pathsFileName = _paths!.first.name; // Store the file name
    } else {
      print('No file selected');
    }
  }

  // Mentor Registration API
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
      });

      // Attach profile image if selected
      if (_paths != null && pathsFile != null) {
        final mimeType = lookupMimeType(pathsFileName);
        final multipartFile = http.MultipartFile.fromBytes(
          'profile_img',
          pathsFile,
          filename: pathsFileName,
          contentType: MediaType.parse(mimeType ?? 'application/octet-stream'),
        );
        request.files.add(multipartFile);
      }

      final response = await request.send();
      final responseData = jsonDecode(await response.stream.bytesToString());

      if (response.statusCode == 201 && responseData['status'] == 1) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseData['message'])),
        );
        clearControllers();
        Get.toNamed(AppRoutes.login);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseData['message'] ?? 'Error occurred')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: \$e')),
      );
    } finally {
      isLoading.value = false;
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

          print("User ID: $userId");
          print("User Name: $userName");

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


