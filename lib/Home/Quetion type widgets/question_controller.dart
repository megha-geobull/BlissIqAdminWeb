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

      print("Url: "+ApiString.get_mcq);
      print("Request Fields: "+request.fields.toString());
      print("Response Data: $responseData");

      // Handle success and error responses
      if (response.statusCode == 201 && responseData['status'] == 1) {
        //mcqList=
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
      request.fields['question'] = questions;
      request.fields['answer'] = answers;
      request.fields['question_img_name'] = questionImgNames;
      request.fields['answer_img_name'] = answerImgNames;

      // Add question images
      for (int i = 0; i < questionImages.length; i++) {
        final image = questionImages[i];
        request.files.add(
          http.MultipartFile.fromBytes(
            'question_img',
            image,
            filename: 'question_$i.png',
            contentType: MediaType('image', 'png'),
          ),
        );
      }

      // Add answer images
      for (int i = 0; i < answerImages.length; i++) {
        final image = answerImages[i];
        request.files.add(
          http.MultipartFile.fromBytes(
            'answer_img',
            image,
            filename: 'answer_$i.png',
            contentType: MediaType('image', 'png'),
          ),
        );
      }

      // Send the request
      final response = await request.send();

      if (response.statusCode == 201) {
        final responseData = await response.stream.bytesToString();
        final decodedResponse = jsonDecode(responseData);
        if (decodedResponse['status'] == 1) {
          showSnackbar(message: decodedResponse['message'] ?? 'Added successfully');
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

  Future<void> addFlipTheCard({
    required String main_category_id,
    String? title,
    required String sub_category_id,
    required String topic_id,
    String? sub_topic_id,
    required String points,
    required String letters,
    required List<td.Uint8List> images,
    required String index,
    required String image_name,
    required BuildContext context,
  }) async {
    isLoading.value = true;

    try {
      final uri = Uri.parse(ApiString.add_card_flipping);
      final request = http.MultipartRequest('POST', uri);

      // Add text fields
      request.fields['main_category_id'] = main_category_id;
      request.fields['sub_category_id'] = sub_category_id;
      request.fields['topic_id'] = topic_id;
      request.fields['sub_topic_id'] = sub_topic_id ?? '';
      request.fields['title'] = title ?? '';
      request.fields['question_type'] = 'Card Flip';
      request.fields['index'] = index;
      request.fields['points'] = points;
      request.fields['letter'] = letters;
      request.fields['image_name'] = image_name;

      // Print request body (fields)
      print("Request Fields: ${request.fields}");

      // Add images
      for (int i = 0; i < images.length; i++) {
        final image = images[i];
        request.files.add(
          http.MultipartFile.fromBytes(
            'image',
            image,
            filename: 'image_$i.png',
            contentType: MediaType('image', 'png'),
          ),
        );
      }

      // Send the request
      final response = await request.send();

      // Print response status code
      print("Response Status Code: ${response.statusCode}");

      // Convert response stream to a string and print
      final responseData = await response.stream.bytesToString();
      print("Response Body: $responseData");

      // Decode and handle the response
      final decodedResponse = jsonDecode(responseData);
      if (response.statusCode == 201 && decodedResponse['status'] == 1) {
        showSnackbar(message: decodedResponse['message'] ?? 'Added successfully');
      } else {
        showSnackbar(message: decodedResponse['message'] ?? 'Error occurred');
      }
    } catch (e) {
      // Print any exceptions that occur
      print('An error occurred: $e');
      showSnackbar(message: 'An error occurred: $e');
    } finally {
      isLoading.value = false;
    }
  }


  Future<void> editConversation({
    required String conversation_id,
    required String main_category_id,
    required String sub_category_id,
    required String topic_id,
    String? sub_topic_id,
    required String question_type,
    required String title,
    required String bot_conversation,
    required String user_conversation,
    required String user_conversation_type,
    required String option,
    required String answer,
    required String points,
    required String index,
  }) async {
    isLoading.value = true;
    try {
      final uri = Uri.parse(ApiString.update_conversation);
      final request = http.MultipartRequest('POST', uri);

      // Add text fields
      request.fields['conversation_id'] = conversation_id;
      request.fields['main_category_id'] = main_category_id;
      request.fields['sub_category_id'] = sub_category_id;
      request.fields['topic_id'] = topic_id;
      request.fields['sub_topic_id'] = sub_topic_id ?? '';
      request.fields['title'] = title;
      request.fields['question_type'] = question_type;
      request.fields['bot_conversation'] = bot_conversation;
      request.fields['user_conversation'] = user_conversation;
      request.fields['user_conversation_type'] = user_conversation_type;
      request.fields['options'] = option;
      request.fields['answer'] = answer;
      request.fields['index'] = index;
      request.fields['points'] = points;

      print(request.fields.toString());

      // Send the request
      final response = await request.send();

      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        print(responseData.toString());
        final decodedResponse = jsonDecode(responseData);
        if (decodedResponse['status'] == 1) {
          showSnackbar(message: decodedResponse['message'] ?? 'Added successfully');
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