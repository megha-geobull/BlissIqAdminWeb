import 'dart:convert';
import 'dart:developer';

import 'package:blissiqadmin/Global/constants/ApiString.dart';
import 'package:blissiqadmin/Global/constants/common_snackbar.dart';
import 'package:blissiqadmin/Home/Users/Models/AllStudentModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class StudentController extends GetxController {

  RxBool isLoading = false.obs;
  var formKey = GlobalKey<FormState>();
  RxBool passwordVisible = false.obs;
  RxBool confirmPasswordVisible = false.obs;
  var currentCountryCode = "IN-91".obs;
  var selectedUserType = 'Mentor'.obs;
  RxList<Data> allLearnerData = <Data>[].obs;


  getAllLearners() async {
    isLoading.value = true;
    allLearnerData.clear();
    try {
      final response = await http.post(
        Uri.parse(ApiString.get_all_learners),
        headers: {"Content-Type": "application/json"},
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);

        if (responseData['status'] == 1) {
          // Parse each JSON object into a Data model
          allLearnerData.value = (responseData["data"] as List)
              .map((mentorJson) => Data.fromJson(mentorJson))
              .toList();
        } else {
          showSnackbar(message: "Failed to fetch category");
        }
      }
    } catch (e) {
      showSnackbar(message: "Error while fetching category $e");
      log(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  delete_Learners(String user_id) async {
    isLoading.value = true;

    try {
      final Map<String, dynamic> body = {
        "student_id": user_id,
      };

      final response = await http.delete(
        Uri.parse(ApiString.delete_students),
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
          showSnackbar(message: "Failed to delete learner");
        }
      }
    } catch (e) {
      showSnackbar(message: "Error while deleting learner $e");
      log(e.toString());
    } finally {
      isLoading.value = false;
    }
  }


   deleteStudentAPI({required String studentID}) async {
    isLoading.value = true;

    try {
      final Map<String, dynamic> body = {
        "student_id": studentID,
      };

      final response = await http.delete(
        Uri.parse(ApiString.delete_students),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      print('Response url: ${ApiString.delete_students}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        if (responseData['status'] == 1) {
          showSnackbar(message: "Student deleted successfully");
        } else {
          showSnackbar(message: "Failed to delete student");
        }
      }
    } catch (e) {
      showSnackbar(message: "Error while delete $e");
    } finally {
      isLoading.value = false;
    }
  }

}