import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http_parser/http_parser.dart';
import 'package:blissiqadmin/Global/constants/ApiString.dart';
import 'package:blissiqadmin/Global/constants/common_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'dart:html' as html;

class QuestionApiController extends GetxController {
  var questions = <dynamic>[].obs;
  RxBool isLoading = false.obs;

  ///Add re-arrange api function
  addRearrangeApi({
    required String mainCategoryId,
    required String subCategoryId,
    required String topicId,
    required String subTopicId,
    required String questionType,
    required String title,
    required String question,
    List<int>? qImage,
    required String answer,
    required String points,
    required String index,
    String? profileImageName,
  }) async {
    isLoading.value = true;
    var uri = Uri.parse(ApiString.add_rearrange);
    try {

      var request = http.MultipartRequest("POST", uri);
      if (qImage != null) {
        var mimeType = lookupMimeType('image') ?? 'image/jpeg';
        var timestamp = DateTime.now().millisecondsSinceEpoch;
        var multipartFile = http.MultipartFile.fromBytes(
          'q_image',
          qImage,
          filename: 'image_$timestamp.jpg',
          contentType: MediaType.parse(mimeType),
        );
        request.files.add(multipartFile);
      }

      if (qImage != null) {
        final mimeType = lookupMimeType(profileImageName!); // Get MIME type
        final mimeTypeParts = mimeType?.split('/') ?? ['application', 'octet-stream'];

        final multipartFile = http.MultipartFile.fromBytes(
          'profile_pic',
          qImage,
          filename: profileImageName, // Pass file name
          contentType: MediaType(mimeTypeParts[0], mimeTypeParts[1]),
        );
        request.files.add(multipartFile);
      }

      request.fields['main_category_id'] = mainCategoryId;
      request.fields['sub_category_id'] = subCategoryId;
      request.fields['topic_id'] = topicId;
      request.fields['sub_topic_id'] = subTopicId;
      request.fields['question_type'] = questionType;
      request.fields['title'] = title;
      request.fields['question'] = question;
      request.fields['answer'] = answer;
      request.fields['points'] = points;
      request.fields['index'] = index;

      http.Response response = await http.Response.fromStream(await request.send());

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 201) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        print('Response status: ${responseData}');
        if (responseData['status'] == 1) {
          showSnackbar(message: "question added successfully");
        } else {
          showSnackbar(message: "Failed to add Subcategory");
        }
      }
    } catch (e) {
      showSnackbar(message: "Error while add $e");
    } finally {
      isLoading.value = false;
    }
  }

  ///Add re-arrange api function
  addRearrangeSentenseApi({
    required String mainCategoryId,
    required String subCategoryId,
    required String topicId,
    required String subTopicId,
    required String questionType,
    required String title,
    required String question,
    required String answer,
    required String points,
    required String index,
    required String question_formate,
    required String options,

  }) async {
    isLoading.value = true;
    var uri = Uri.parse(ApiString.add_complete_sentence);
    try {

      var request = http.MultipartRequest("POST", uri);

      request.fields['main_category_id'] = mainCategoryId;
      request.fields['sub_category_id'] = subCategoryId;
      request.fields['topic_id'] = topicId;
      request.fields['sub_topic_id'] = subTopicId;
      request.fields['question_type'] = questionType;
      request.fields['title'] = title;
      request.fields['question'] = question;
      request.fields['answer'] = answer;
      request.fields['points'] = points;
      request.fields['index'] = index;
      request.fields['question_format'] = question_formate;
      request.fields['options'] = options;

      http.Response response = await http.Response.fromStream(await request.send());

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 201) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        print('Response status: ${responseData}');
        if (responseData['status'] == 1) {
          showSnackbar(message: "question added successfully");
        } else {
          showSnackbar(message: "Failed to add question");
        }
      }
    } catch (e) {
      showSnackbar(message: "Error while add $e");
    } finally {
      isLoading.value = false;
    }
  }

  ///Add re-true-false api function
   addTrueFalseApi({
    required String mainCategoryId,
    required String subCategoryId,
    required String topicId,
    required String subTopicId,
    required String questionType,
    required String question,
    Uint8List? qImage,
    required String answer,
    required String points,
    required String index,
  }) async {
    isLoading.value = true;
    var uri = Uri.parse(ApiString.add_true_false);
    try {
      var request = http.MultipartRequest("POST", uri);
      if (qImage != null) {
        var mimeType = lookupMimeType('image') ?? 'image/jpeg';
        var multipartFile = http.MultipartFile.fromBytes(
          'q_image',
          qImage,
          filename: 'uploaded_image.jpg',
          contentType: MediaType.parse(mimeType),
        );
        request.files.add(multipartFile);
      }

      request.fields['main_category_id'] = mainCategoryId;
      request.fields['sub_category_id'] = subCategoryId;
      request.fields['topic_id'] = topicId;
      request.fields['sub_topic_id'] = subTopicId;
      request.fields['question_type'] = questionType;
      request.fields['question'] = question;
      request.fields['answer'] = answer;
      request.fields['points'] = points;
      request.fields['index'] = index;

      http.Response response = await http.Response.fromStream(await request.send());

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 201) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        print('Response status: ${responseData}');
        if (responseData['status'] == 1) {
          showSnackbar(message: "Question added successfully");
        } else {
          showSnackbar(message: "Failed to add question");
        }
      } else {
        showSnackbar(message: "Failed to add question: ${response.reasonPhrase}");
      }
    } catch (e) {
      showSnackbar(message: "Error while adding question: $e");
    } finally {
      isLoading.value = false;
    }
  }

  ///Add story api function
  addStoryApi({
    required String mainCategoryId,
    required String subCategoryId,
    required String topicId,
    required String subTopicId,
    required String storyTitle,
    Uint8List? story_img,
    required String content,
    required String highlightWord,
    required String points,
    required String index,
  }) async {
    isLoading.value = true;
    var uri = Uri.parse(ApiString.add_story);
    try {
      var request = http.MultipartRequest("POST", uri);
      if (story_img != null) {
        var mimeType = lookupMimeType('image') ?? 'image/jpeg';
        var multipartFile = http.MultipartFile.fromBytes(
          'story_img',
          story_img,
          filename: 'uploaded_image.jpg',
          contentType: MediaType.parse(mimeType),
        );
        request.files.add(multipartFile);
      }

      // Add fields to the request
      request.fields['main_category_id'] = mainCategoryId;
      request.fields['sub_category_id'] = subCategoryId;
      request.fields['topic_id'] = topicId;
      request.fields['sub_topic_id'] = subTopicId;
      request.fields['story_title'] = storyTitle;
      request.fields['content'] = content;
      request.fields['highlight_word'] = highlightWord;
      request.fields['points'] = points;
      request.fields['index'] = index;

      // Send request
      http.Response response = await http.Response.fromStream(await request.send());

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 201) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        if (responseData['status'] == 1) {
          showSnackbar(message: "Story added successfully");
        } else {
          showSnackbar(message: "Failed to add Story");
        }
      } else {
        showSnackbar(message: "Failed to add Story: ${response.reasonPhrase}");
      }
    } catch (e) {
      showSnackbar(message: "Error while adding story: $e");
    } finally {
      isLoading.value = false;
    }
  }

  ///Add story-phrase api function
  addStoryPhraseApi({
    required String mainCategoryId,
    required String subCategoryId,
    required String topicId,
    required String subTopicId,
    required String phraseName,
    required String points,
    required String index,
  }) async {
    isLoading.value = true;
    var uri = Uri.parse(ApiString.add_story_phrases);
    try {
      var request = http.MultipartRequest("POST", uri);
      request.fields['main_category_id'] = mainCategoryId;
      request.fields['sub_category_id'] = subCategoryId;
      request.fields['topic_id'] = topicId;
      request.fields['sub_topic_id'] = subTopicId;
      request.fields['phrase_name'] = phraseName;
      request.fields['points'] = points;
      request.fields['index'] = index;

      http.Response response = await http.Response.fromStream(await request.send());

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      if (response.statusCode == 201) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        print('Response status: ${responseData}');
        if (responseData['status'] == 1) {
          showSnackbar(message: "question added successfully");
        } else {
          showSnackbar(message: "Failed to add Subcategory");
        }
      }
    } catch (e) {
      showSnackbar(message: "Error while add $e");
    } finally {
      isLoading.value = false;
    }
  }

  ///Add fill in blanks
  addFillBlanksApi({
    required String mainCategoryId,
    required String subCategoryId,
    required String topicId,
    required String subTopicId,
    required String questionType,
    required String title,
    required String question,
    Uint8List? qImage,
    required String optionLanguage,
    required String questionLanguage,
    required String optionA,
    required String optionB,
    required String optionC,
    required String optionD,
    required String answer,
    required String points,
    required String index,
  }) async {
    isLoading.value = true;
    var uri = Uri.parse(ApiString.add_fill_blanks);
    try {
      var request = http.MultipartRequest("POST", uri);

      // Add image if available
      if (qImage != null) {
        var mimeType = lookupMimeType('image') ?? 'image/jpeg';
        var multipartFile = http.MultipartFile.fromBytes(
          'q_image',
          qImage,
          filename: 'uploaded_image.jpg',
          contentType: MediaType.parse(mimeType),
        );
        request.files.add(multipartFile);
      }

      // Add form fields
      request.fields['main_category_id'] = mainCategoryId;
      request.fields['sub_category_id'] = subCategoryId;
      request.fields['topic_id'] = topicId;
      request.fields['sub_topic_id'] = subTopicId;
      request.fields['question_type'] = questionType;
      request.fields['title'] = title;
      request.fields['question'] = question;
      request.fields['option_language'] = optionLanguage;
      request.fields['question_language'] = questionLanguage;
      request.fields['option_a'] = optionA;
      request.fields['option_b'] = optionB;
      request.fields['option_c'] = optionC;
      request.fields['option_d'] = optionD;
      request.fields['answer'] = answer;
      request.fields['points'] = points;
      request.fields['index'] = index;

      // Send request
      http.Response response = await http.Response.fromStream(await request.send());

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      if (response.statusCode == 201) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        print('Response status: ${responseData}');
        if (responseData['status'] == 1) {
          showSnackbar(message: "Question added successfully");
        } else {
          showSnackbar(message: "Failed to add question");
        }
      } else {
        showSnackbar(message: "Failed to add question: ${response.reasonPhrase}");
      }
    } catch (e) {
      showSnackbar(message: "Error while adding question: $e");
    } finally {
      isLoading.value = false;
    }
  }

 ///Add fill in blanks
  addGuessTheImage({
    required String mainCategoryId,
    required String subCategoryId,
    required String topicId,
    required String subTopicId,
    required String questionType,
    required String title,
    Uint8List? qImage,
    required String optionA,
    required String optionB,
    required String optionC,
    required String optionD,
    required String answer,
    required String points,
    required String index,
  }) async {
    isLoading.value = true;
    var uri = Uri.parse(ApiString.add_guess_the_image);
    try {
      var request = http.MultipartRequest("POST", uri);

      // Add image if available
      if (qImage != null) {
        var mimeType = lookupMimeType('image') ?? 'image/jpeg';
        var multipartFile = http.MultipartFile.fromBytes(
          'q_image',
          qImage,
          filename: 'uploaded_image.jpg',
          contentType: MediaType.parse(mimeType),
        );
        request.files.add(multipartFile);
      }

      // Add form fields
      request.fields['main_category_id'] = mainCategoryId;
      request.fields['sub_category_id'] = subCategoryId;
      request.fields['topic_id'] = topicId;
      request.fields['sub_topic_id'] = subTopicId;
      request.fields['question_type'] = questionType;
      request.fields['title'] = title;
      // request.fields['q_image_name'] = q_image_name;
      request.fields['option_a'] = optionA;
      request.fields['option_b'] = optionB;
      request.fields['option_c'] = optionC;
      request.fields['option_d'] = optionD;
      request.fields['answer'] = answer;
      request.fields['points'] = points;
      request.fields['index'] = index;

      // Send request
      http.Response response = await http.Response.fromStream(await request.send());

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      if (response.statusCode == 201) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        print('Response status: ${responseData}');
        if (responseData['status'] == 1) {
          showSnackbar(message: "Question added successfully");
        } else {
          showSnackbar(message: "Failed to add question");
        }
      } else {
        showSnackbar(message: "Failed to add question: ${response.reasonPhrase}");
      }
    } catch (e) {
      showSnackbar(message: "Error while adding question: $e");
    } finally {
      isLoading.value = false;
    }
  }


  addMatchThePairs({
    required String main_category_id,
    required String title,
    required String sub_category_id,
    required String topic_id,
    String? sub_topic_id,
    required String question_type,
    required String question_format,
    required String answer_format,
    required List<Map<dynamic, dynamic>> entries,
    required String points,
    required String index,
    required BuildContext context,
  }) async {
    isLoading.value = true;
    print("API is calling");
    try {
      // Prepare the request body as JSON
      final requestBody = jsonEncode({
        'main_category_id': main_category_id,
        'sub_category_id': sub_category_id,
        'topic_id': topic_id,
        'sub_topic_id': sub_topic_id ?? "",
        'question_type': question_type,
        'title': title,
        'index': index,
        'question_format': question_format,
        'answer_format': answer_format,
        'points': points,
        'entries': entries,
      });

      // Print request body for debugging
      print("Request Body: $requestBody");

      // Send the POST request with application/json content-type
      final response = await http.post(
        Uri.parse(ApiString.add_match_pair_question),
        headers: {
          'Content-Type': 'application/json',
        },
        body: requestBody,
      );

      // Print response details for debugging
      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      // Parse the response
      final responseData = jsonDecode(response.body);

      // Handle the response
      if (response.statusCode == 201 && responseData['status'] == 1) {
        showSnackbar(
          message: responseData['message'] ?? 'Added successfully',
        );
        print(responseData['message']);
      } else {
        showSnackbar(
          message: responseData['message'] ?? 'Error occurred',
        );
        print(responseData['message']);
      }
    } catch (e, stacktrace) {
      // Handle exceptions
      print('An error occurred: $e');
      print('Stacktrace: $stacktrace');
      showSnackbar(
        message: 'An error occurred: $e',
      );
    } finally {
      isLoading.value = false;
    }
  }

  addCompleteWordApi({
    required String mainCategoryId,
    required String title,
    required String subCategoryId,
    required String topicId,
    String? subTopicId,
    required String questionType,
    required String question,
    required String index,
    required String optionA,
    required String optionB,
    required String optionC,
    required String optionD,
    required String answer,
    required String points,
    required BuildContext context,
  }) async {
    isLoading.value = true;

    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse(ApiString.add_complete_the_word),
      );

      // Prepare the request body
      request.fields.addAll({
        'main_category_id': mainCategoryId,
        'sub_category_id': subCategoryId,
        'topic_id': topicId,
        'sub_topic_id': subTopicId ?? "",
        'question_type': questionType,
        'question': question,
        'title': title,
        'index': index,
        'option_a': optionA,
        'option_b': optionB,
        'option_c': optionC,
        'option_d': optionD,
        'points': points,
        'answer': answer,
      });

      final response = await request.send();
      final responseData = jsonDecode(await response.stream.bytesToString());

      print("Response Data: $responseData");

      // Handle success and error responses
      if (response.statusCode == 201 && responseData['status'] == 1) {
        print('Question added successfully');
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

  addCompleteParagraphApi({
    required String mainCategoryId,
    required String title,
    required String subCategoryId,
    required String topicId,
    String? subTopicId,
    required String questionType,
    required String question,
    required String paragraphContent,
    required String index,
    required String optionA,
    required String optionB,
    required String optionC,
    required String optionD,
    required String optionE,
    required String optionF,
    required String answer,
    required String points,
    required BuildContext context,
  }) async {
    isLoading.value = true;

    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse(ApiString.add_complete_the_paragraph),
      );
      // Prepare the request body
      request.fields.addAll({
        'main_category_id': mainCategoryId,
        'sub_category_id': subCategoryId,
        'topic_id': topicId,
        'sub_topic_id': subTopicId ?? "",
        'question_type': questionType,
        'question': question,
        'paragraph_content': paragraphContent,
        'title': title,
        'index': index,
        'option_a': optionA,
        'option_b': optionB,
        'option_c': optionC,
        'option_d': optionD,
        'option_e':optionE,
        'option_f':optionF,
        'points': points,
        'answer': answer
      });

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


  Future<void> addLearningSlideApi({
    required String mainCategoryId,
    required String subCategoryId,
    required String topicId,
    String? subTopicId,
    required String title,
    required String questionType,
    required String definition,
    required String index,
    required String points,
    String? youtubeLink,
    String? image_link,
    String?  pdf_link,
    String?  ppt_link,
    // Uint8List? pdfBytes,
    // Uint8List? pptBytes,
  }) async {
    isLoading.value = true;

    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse(ApiString.add_learning_slide),
      );

      // Add form fields
      request.fields.addAll({
        'main_category_id': mainCategoryId,
        'sub_category_id': subCategoryId,
        'topic_id': topicId,
        'sub_topic_id': subTopicId ?? "",
        'question_type': questionType,
        'title': title,
        'index': index,
        'definition': definition,
        'points': points,
        'video_file': youtubeLink ?? "",
        'pdf_file': pdf_link ?? "",
        'ppt_file': ppt_link ?? "",
        'image_file': image_link ?? "",
      });

      // // Attach files if they exist
      // if (imageBytes != null) {
      //   request.files.add(http.MultipartFile.fromBytes(
      //     'image_file',
      //     imageBytes,
      //     filename: 'image.png',
      //     contentType: MediaType('image', 'png'),
      //   ));
      // }

      // Send request
      final response = await request.send();
      final responseData = jsonDecode(await response.stream.bytesToString());

      if (response.statusCode == 201 && responseData['status'] == 1) {
        Fluttertoast.showToast(
          msg: responseData['message'] ?? 'Slide content added successfully',
        );
        print('added successfully..!');
      } else {
        Fluttertoast.showToast(
          msg: responseData['message'] ?? 'Failed to add slide content',
        );
        print('error to add question');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'An error occurred: $e');
      print('error occurred $e');
    } finally {
      isLoading.value = false;
    }
  }



  addExampleApi({
    required String mainCategoryId,
    required String subCategoryId,
    required String topicId,
    required String subTopicId,
    required String questionType,
    required String question,
    Uint8List? qImage,
    required String answer,
    required String points,
    required String index,
  }) async {
    isLoading.value = true;
    var uri = Uri.parse(ApiString.add_topic_example);
    try {
      var request = http.MultipartRequest("POST", uri);
      if (qImage != null) {
        var mimeType = lookupMimeType('image') ?? 'image/jpeg';
        var multipartFile = http.MultipartFile.fromBytes(
          'image_name',
          qImage,
          filename: 'uploaded_image.jpg',
          contentType: MediaType.parse(mimeType),
        );
        request.files.add(multipartFile);
      }

      request.fields['main_category_id'] = mainCategoryId;
      request.fields['sub_category_id'] = subCategoryId;
      request.fields['topic_id'] = topicId;
      request.fields['sub_topic_id'] = subTopicId;
      request.fields['question_type'] = questionType;
      request.fields['question'] = question;
      request.fields['answer'] = answer;
      request.fields['points'] = points;
      request.fields['index'] = index;

      http.Response response = await http.Response.fromStream(await request.send());

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 201) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        print('Response status: ${responseData}');
        if (responseData['status'] == 1) {
          showSnackbar(message: "Question added successfully");
        } else {
          showSnackbar(message: "Failed to add question");
        }
      } else {
        showSnackbar(message: "Failed to add question: ${response.reasonPhrase}");
      }
    } catch (e) {
      showSnackbar(message: "Error while adding question: $e");
    } finally {
      isLoading.value = false;
    }
  }

}
