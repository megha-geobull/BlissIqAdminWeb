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

}