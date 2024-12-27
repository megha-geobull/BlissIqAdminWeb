import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Global/constants/ApiString.dart';
import '../Global/utils/shared_preference/shared_preference_services.dart';

bool isLogin = false;

class ProfileController extends GetxController {
  var isLoading = false.obs;
  var profile = {}.obs;
  String? getLangCode='';
  String? getLanguage='';
  String? getAge = '';
  String? getPurpose = '';
  RxString userId = "".obs;

  checkLogin() async {
    print("checkLogin ");

    String? fetchedUserId = await getUserId();
    if (fetchedUserId != null) {
      userId.value = fetchedUserId;
    } else {
      userId.value = ''; // Provide a fallback or log the error
    }
    isLogin = userId.value.isNotEmpty ?true:false;
    print("userId.value   ${userId.value}  $isLogin");
    if (userId.value.isNotEmpty) {
      getProfile();
    }
  }

  setData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    getLangCode = pref.getString('languageCode');
    getLanguage = pref.getString('language');
    getAge = pref.getString('age');
    getPurpose = pref.getString('purpose');

    print(getLangCode);
    print(getLanguage);
    print(getAge);
    print(getPurpose);
  }

  getProfile() async {
     userId.value = await getUserId();

    if (userId.value == null || userId.value!.isEmpty) {
      print("User ID:- $userId");
      print("User ID not found in local storage.");
      return;
    }

    try {
      final Map<String, dynamic> body = {
        "user_id": userId.value,
      };

      final response = await http.post(
        Uri.parse(ApiString.getProfile),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );
      print('url: ${ApiString.addTodaysAttendance}');
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body)['data'];
        profile.value = data;
        profile.value = {
          'user_name': data['user_name'] ?? '',
          'contact_no': data['contact_no']?.toString() ?? '',
          'email': data['email'] ?? '',
          'school': data['school'] ?? '',
          'board_name': data['board_name'] ?? '',
          'std_class': data['std_class'] ?? '',
          'profile_image': data['profile_image'] ?? '',
        };
        print("Profile fetched successfully: ${response.body}");
      } else {
        print("Failed to fetch profile: ${response.body}");
      }
    } catch (e) {
      print("Error fetching profile: $e");
    }
  }

   editProfile({
    required String user_name,
    required String contact_no,
    required String email,
    required String school,
    required String std_class,
    required String profile_image,
    required String board_name,
  }) async {
    isLoading.value = true;
    final String? userId = await getUserId();

    if (userId == null || userId.isEmpty) {
      print("User ID not found. $userId");
      return;
    }

    try {
      await setData();  // Make sure setData is called before proceeding

      // Default values in case SharedPreferences values are not set
      String? language = getLanguage ;  // Default to Marathi if not set
      String? ageGroup = getAge ;  // Default age group
      String? purpose = getPurpose;  // Default purpose

      final Uri url = Uri.parse(ApiString.edit_profile);
      var request = http.MultipartRequest('POST', url)
        ..fields['user_id'] = userId
        ..fields['user_name'] = user_name
        ..fields['contact_no'] = contact_no
        ..fields['email'] = email
        ..fields['school'] = school
        ..fields['language'] = language!
        ..fields['age_group'] = ageGroup!
        ..fields['purpose'] = purpose!
        ..fields['std_class'] = std_class.isNotEmpty ? std_class : 'Not Provided'
        ..fields['board_name'] = board_name.isNotEmpty ? board_name : '';

      // Handle profile image upload logic
      if (profile_image.isNotEmpty) {
        if (profile_image.startsWith('assets/')) {
          // If the profile image is a local asset, convert it to a file
          ByteData byteData = await rootBundle.load(profile_image);
          List<int> imageData = byteData.buffer.asUint8List();
          final tempDir = await getTemporaryDirectory();
          final tempFile = File('${tempDir.path}/temp_avatar.png');
          await tempFile.writeAsBytes(imageData);
          request.files.add(
            await http.MultipartFile.fromPath('profile_image', tempFile.path),
          );
        } else if (profile_image.startsWith('http')) {
          // If the profile image is a URL, send the URL as part of the request
          request.fields['profile_image'] = profile_image;
        } else {
          // Invalid profile image format
          print("No valid image selected or provided.");
        }
      } else {
        // If profile_image is empty, ensure it is not included at all
        request.fields.remove('profile_image');
      }

      // If profile_image is empty, ensure it is not included at all
      if (profile_image.isEmpty) {
        request.fields.remove('profile_image');
      }

      // Send the request
      var response = await request.send();
      final responseData = await http.Response.fromStream(response);

      // Handle server response
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(responseData.body);
        if (jsonResponse['status'] == 1) {
          // Successfully updated profile
          await getProfile();
          Fluttertoast.showToast(
            msg: jsonResponse['message'] ?? "Profile updated successfully!",
            backgroundColor: Colors.green,
          );
        } else {
          // Profile update failed
          Fluttertoast.showToast(
            msg: jsonResponse['message'] ?? "Update failed!",
            backgroundColor: Colors.red,
          );
        }
      } else {
        // Server returned an error
        print("Error: ${response.statusCode}, Response: ${responseData.body}");
      }
    } catch (e) {
      // Catch any errors during the process
      print("Error updating profile: $e");
      Fluttertoast.showToast(
        msg: "An error occurred: $e",
        backgroundColor: Colors.red,
      );
    } finally {
      // Stop loading spinner
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

  checkAttendance(String currentDate,String time) async {
    userId.value = await getUserId();

    if (userId.value == null || userId.value!.isEmpty) {
      print("User ID:- $userId");
      print("User ID not found in local storage.");
      return;
    }
//attendance_date,user_id,current_time
    try {
      final Map<String, dynamic> body = {
        "user_id": userId.value,
        "attendance_date": currentDate,
        "current_time": time,
      };

      final response = await http.post(
        Uri.parse(ApiString.addTodaysAttendance),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      print('url: ${ApiString.addTodaysAttendance}');
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body)['data'];
        // profile.value = data;
        // profile.value = {
        //   'user_name': data['user_name'] ?? '',
        //   'contact_no': data['contact_no']?.toString() ?? '',
        //   'email': data['email'] ?? '',
        //   'school': data['school'] ?? '',
        //   'board_name': data['board_name'] ?? '',
        //   'std_class': data['std_class'] ?? '',
        //   'profile_image': data['profile_image'] ?? '',
        // };
         print("Profile fetched successfully: ${response.body}");
      } else {
        print("Failed to update attendance: ${response.body}");
      }
    } catch (e) {
      print("Error adding attendance: $e");
    }
  }


}
