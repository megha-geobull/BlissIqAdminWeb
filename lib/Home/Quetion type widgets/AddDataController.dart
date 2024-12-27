
import 'package:blissiqadmin/Global/constants/ApiString.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get/get.dart';

import '../../Global/constants/common_snackbar.dart';

class Add_DataController extends GetxController {
  RxBool isLoading = false.obs;
//main_category_id, sub_category_id, topic_id, sub_topic_id, question_type,
// title,question,q_image,option_a,option_b,option_c,option_d,answer,points,index
  add_mcq({
    required String maincategory_id,
    required String sub_categoryId,
    required String topicId,
    required String subtopic_id,
    required String question_type,
    required String title,
    required String question,
    required String q_image,
    required String option_a,
    required String option_b,
    required String option_c,
    required String option_d,
    required String answer,
    required String points,
    required String index,
  }) async {
    isLoading.value = true;

    try {
      final Map<String, dynamic> body = {
        "main_category_id": maincategory_id,
        "sub_category_id": sub_categoryId,
        "topic_id": topicId,
        "sub_topic_id": subtopic_id,
        "question_type": question_type,
        "question":question,
        "option_a":option_a,
        "option_b":option_b,
        "option_c":option_c,
        "option_d":option_d,
        "answer":answer,
        "points":points,
        "points":points,
        "index":index,
      };

      final response = await http.post(
        Uri.parse(ApiString.add_subtopics),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );
      print(ApiString.add_subtopics);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        if (responseData['status'] == 1) {
          showSnackbar(message: "Subtopic added successfully");
        } else {
          showSnackbar(message: "Failed to add Subtopic");
        }
      }
    } catch (e) {
      showSnackbar(message: "Error while add $e");
    } finally {
      isLoading.value = false;
    }
  }

}