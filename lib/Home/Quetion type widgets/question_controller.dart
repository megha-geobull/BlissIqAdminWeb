
import 'dart:convert';

import 'package:blissiqadmin/Global/Routes/AppRoutes.dart';
import 'package:blissiqadmin/Global/constants/ApiString.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';


class QuestionController extends GetxController {

  RxBool isLoading = false.obs;
  RxList mcqList = [].obs;

  addMCQ({
    required String main_category_id,
    required String title,
    required String sub_category_id,
    required String topic_id,
    String? sub_topic_id,
    required String question_type,
    required String question,
    required String index,
    required String option_a,
    required String option_b,
    required String option_c,
    required String option_d,
    required String answer,
    required String points,
    required BuildContext context,
    List<int>? q_image,
  }) async {
    isLoading.value = true;

    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse(ApiString.add_mcq),
      );

      // Prepare the request body
      request.fields.addAll({
        'main_category_id': main_category_id,
        'sub_category_id': sub_category_id,
        'topic_id': topic_id,
        'sub_topic_id': sub_topic_id ?? "",
        'question_type': question_type,
        'question': question,
        'title': title,
        'index': index,
        'option_a': option_a,
        'option_b': option_b,
        'option_c': option_c,
        'option_d': option_d,
        'points': points,
        'answer': answer,
      });

      // Attach image
      if (q_image != null) {
        final multipartFile = http.MultipartFile.fromBytes(
          'q_image',
          q_image,
          filename: 'mcq_image.jpg', // Ensure a valid extension
          contentType: MediaType('image', 'jpeg'),
        );
        request.files.add(multipartFile);
      }

      final response = await request.send();
      final responseData = jsonDecode(await response.stream.bytesToString());

      print("Response Data: $responseData");

      // Handle success and error responses
      if (response.statusCode == 201 && responseData['status'] == 1) {
        Fluttertoast.showToast(
          msg: responseData['message'] ?? 'Added successfully',
        );
      } else {
        Fluttertoast.showToast(
          msg: responseData['message'] ?? 'Error occurred',
        );
      }
    } catch (e, stacktrace) {
      print('An error occurred: $e');
      print('Stacktrace: $stacktrace');
      Fluttertoast.showToast(
        msg: 'An error occurred: $e',
      );
    } finally {
      isLoading.value = false;
    }
  }

  get_MCQ({
    required String main_category_id,
    required String sub_category_id,
    required String topic_id,
    String? sub_topic_id,
  }) async {
    isLoading.value = true;

    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse(ApiString.get_mcq),
      );

      // Prepare the request body
      request.fields.addAll({
        'main_category_id': main_category_id,
        'sub_category_id': sub_category_id,
        'topic_id': topic_id,
        'sub_topic_id': sub_topic_id ?? "",
      });

      final response = await request.send();
      final responseData = jsonDecode(await response.stream.bytesToString());

      print("Response Data: $responseData");

      // Handle success and error responses
      if (response.statusCode == 201 && responseData['status'] == 1) {
        Fluttertoast.showToast(
          msg: responseData['message'] ?? 'fetched successfully',
        );
      } else {
        Fluttertoast.showToast(
          msg: responseData['message'] ?? 'Error occurred',
        );
      }
    } catch (e, stacktrace) {
      print('An error occurred: $e');
      print('Stacktrace: $stacktrace');
      Fluttertoast.showToast(
        msg: 'An error occurred: $e',
      );
    } finally {
      isLoading.value = false;
    }
  }

}