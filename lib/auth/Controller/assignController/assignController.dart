import 'dart:convert';
import 'dart:developer';

import 'package:blissiqadmin/Global/constants/ApiString.dart';
import 'package:blissiqadmin/Global/constants/common_snackbar.dart';
import 'package:blissiqadmin/Home/Users/Models/AssignSchoolDataModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class AssignController extends GetxController{

  RxBool isLoading = false.obs;
  RxList<GetAssignSchoolData> allSchoolData = <GetAssignSchoolData>[].obs;
 // RxList<AssignMentorData> allMentorData = <AssignMentorData>[].obs;


  getAssignSchools() async {
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
              .map((mentorJson) => GetAssignSchoolData.fromJson(mentorJson))
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

  // getAssignMentorsTeachers() async {
  //   isLoading.value = true;
  //   allSchoolData.clear();
  //   try {
  //     final response = await http.post(
  //       Uri.parse(ApiString.get_all_schools),
  //       headers: {"Content-Type": "application/json"},
  //     );
  //
  //     print('Response status: ${response.statusCode}');
  //     print('Response body: ${response.body}');
  //
  //     if (response.statusCode == 200) {
  //       var responseData = jsonDecode(response.body);
  //
  //       if (responseData['status'] == 1) {
  //         // Parse each JSON object into a Data model
  //         allMentorData.value = (responseData["data"] as List)
  //             .map((mentorJson) => AssignMentorData.fromJson(mentorJson))
  //             .toList();
  //       } else {
  //         showSnackbar(message: "Failed to fetch school data");
  //       }
  //     }
  //   } catch (e) {
  //     showSnackbar(message: "Error while fetching school data $e");
  //     log(e.toString());
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

}