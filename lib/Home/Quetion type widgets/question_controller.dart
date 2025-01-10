import 'dart:typed_data' as td;
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:blissiqadmin/Global/constants/ApiString.dart';
import 'package:blissiqadmin/Global/constants/common_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';


class QuestionController extends GetxController {

  RxBool isLoading = false.obs;
  List<dynamic> mcqList = [];

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


      Future<void> addMatchThePairs({
        required String main_category_id,
        required String title,
        required String sub_category_id,
        required String topic_id,
        String? sub_topic_id,
        required String question_type,
        required String question_format,
        required String answer_format,
        required String points,
        required String questions,
        required String questionImgNames,
        required List<td.Uint8List> questionImages,
        required String answers,
        required String answerImgNames,
        required List<td.Uint8List> answerImages,
        required String index,
        required BuildContext context,
      }) async {
        isLoading.value = true;
        try {
          final uri = Uri.parse(ApiString.add_match_pair_question);

          // Create a multipart request
          final request = http.MultipartRequest('POST', uri);

          // Add text fields
          request.fields['main_category_id'] = main_category_id;
          request.fields['sub_category_id'] = sub_category_id;
          request.fields['topic_id'] = topic_id;
          request.fields['sub_topic_id'] = sub_topic_id ?? '';
          request.fields['question_type'] = question_type;
          request.fields['title'] = title;
          request.fields['index'] = index;
          request.fields['question_format'] = question_format;
          request.fields['answer_format'] = answer_format;
          request.fields['points'] = points;

          // Concatenate questions, answers, image names with pipe separators
          request.fields['question_img_name'] = questionImgNames;
          request.fields['answer_img_name'] = answerImgNames;

          if (questionImages.isNotEmpty) {
            for (var i = 0; i < questionImages.length; i++) {
              final image = questionImages[i];
              request.files.add(
                await http.MultipartFile.fromBytes('question_img[$i]', image),
              );
              print('Added Question Image $i: ${questionImgNames[i]}');
            }
          } else {
            print('No Question Images to Add');
          }

  // Add answer images
          if (answerImages.isNotEmpty) {
            for (var i = 0; i < answerImages.length; i++) {
              final image = answerImages[i];
              request.files.add(
                await http.MultipartFile.fromBytes('answer_img[$i]', image),
              );
              print('Added Answer Image $i: ${answerImgNames[i]}');
            }
          } else {
            print('No Answer Images to Add');
          }

          // Print the request body before sending
          print('Request Body:');
          print('Text Fields:');
          request.fields.forEach((key, value) {
            print('$key: $value');
          });
          print('Files:');
          for (var i = 0; i < questionImages.length; i++) {
            print('Question Image $i: ${questionImgNames[i]}');
          }
          for (var i = 0; i < answerImages.length; i++) {
            print('Answer Image $i: ${answerImgNames[i]}');
          }
          // Send the request
          final response = await request.send();

          // Check the response
          if (response.statusCode == 201) {
            final responseData = await response.stream.bytesToString();
            final decodedResponse = jsonDecode(responseData);
            if (decodedResponse['status'] == 1) {
              showSnackbar(message: decodedResponse['message'] ?? 'Added successfully');
              print('Added successfully');
            } else {
              showSnackbar(message: decodedResponse['message'] ?? 'Error occurred');
            }
          } else {
            print('Error: ${response.reasonPhrase}');
            showSnackbar(message: 'Error: ${response.reasonPhrase}');
          }
        } catch (e) {
          print('An error occurred: $e');
          showSnackbar(message: 'An error occurred: $e');
        } finally {
          isLoading.value = false;
        }
      }

}