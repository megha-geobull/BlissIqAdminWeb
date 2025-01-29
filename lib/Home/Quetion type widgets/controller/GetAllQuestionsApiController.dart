import 'dart:convert';
import 'dart:developer';
import 'package:blissiqadmin/Global/constants/ApiString.dart';
import 'package:blissiqadmin/Global/constants/common_snackbar.dart';
import 'package:blissiqadmin/Home/Quetion%20type%20widgets/AddQuetionsWidgets/Header_Columns.dart';
import 'package:blissiqadmin/Home/Quetion%20type%20widgets/model/GetCompleteParagraphModel.dart';
import 'package:blissiqadmin/Home/Quetion%20type%20widgets/model/GetCompleteWordModel.dart';
import 'package:blissiqadmin/Home/Quetion%20type%20widgets/model/LearningSlideModel.dart';
import 'package:blissiqadmin/Home/Quetion%20type%20widgets/model/get_fill_in_the_blanks.dart';
import 'package:blissiqadmin/Home/Quetion%20type%20widgets/model/get_match_the_pairs.dart';
import 'package:blissiqadmin/Home/Quetion%20type%20widgets/model/get_rearrange_model.dart';
import 'package:blissiqadmin/Home/Quetion%20type%20widgets/model/get_story_model.dart';
import 'package:blissiqadmin/Home/Quetion%20type%20widgets/model/get_story_phrases_model.dart';
import 'package:blissiqadmin/Home/Quetion%20type%20widgets/model/get_trueOrfalse_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:blissiqadmin/Home/Quetion%20type%20widgets/model/get_mcqs.dart';

class GetAllQuestionsApiController extends GetxController {
  RxBool isLoading = false.obs;
  RxList<Mcqs> getMcqslits = <Mcqs>[].obs;
  RxList<ReArrange> getReArrangeList = <ReArrange>[].obs;
  RxList<TrueOrFalse> getTrueOrFalseList = <TrueOrFalse>[].obs;
  RxList<FillInTheBlanks> getFillInTheBlanksList = <FillInTheBlanks>[].obs;
  RxList<StoryData> getStoryDataList = <StoryData>[].obs;

  RxList<StoryPhrases> getStoryPhrasesList = <StoryPhrases>[].obs;
  RxList<PhrasesData> getConversationList = <PhrasesData>[].obs;
  RxList<MatchPairs> getMatchPairsList = <MatchPairs>[].obs;

  RxList<LearningSlide> getLearningSlideData = <LearningSlide>[].obs;
  RxList<CompleteWordData> getCompleteWordData = <CompleteWordData>[].obs;
  RxList<CompleteParaData> getCompleteParaData = <CompleteParaData>[].obs;

  clearData() {
    getMcqslits.clear();
    getReArrangeList.clear();
    getTrueOrFalseList.clear();
    getFillInTheBlanksList.clear();
    getStoryDataList.clear();
    getStoryPhrasesList.clear();
    getConversationList.clear();
    getLearningSlideData.clear();
    getCompleteWordData.clear();
    getCompleteParaData.clear();
  }

  getCompleteWordApi(
      {required String main_category_id,
      required String sub_category_id,
      required String topic_id,
      String? sub_topic_id}) async {
    isLoading.value = true;
    getLearningSlideData.clear();
    try {
      var body = {
        'main_category_id': main_category_id,
        'sub_category_id': sub_category_id,
        'topic_id': topic_id,
        'sub_topic_id': sub_topic_id ?? ''
      };
      final response = await http.post(
          Uri.parse(ApiString.get_complete_the_word),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(body));

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      print('Url: ${ApiString.get_complete_the_word}');

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        if (responseData['status'] == 1) {
          // Parse each JSON object into a Data model
          getCompleteWordData.value = (responseData["data"] as List)
              .map((wordJson) => CompleteWordData.fromJson(wordJson))
              .toList();
          print("Fetched ${getCompleteWordData.length} complete word");
        } else {
          showSnackbar(
              message:
                  responseData['message'] ?? "Failed to fetch complete word ");
        }
      } else {
        showSnackbar(
            message: "Failed to fetch word. Status: ${response.statusCode}");
      }
    } catch (e) {
      showSnackbar(message: "Error while fetching complete word: $e");
      log(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  getCompleteParaApi(
      {required String main_category_id,
      required String sub_category_id,
      required String topic_id,
      String? sub_topic_id}) async {
    isLoading.value = true;
    getCompleteParaData.clear();
    print("Hi Hellow");
    try {
      var body = {
        'main_category_id': main_category_id,
        'sub_category_id': sub_category_id,
        'topic_id': topic_id,
        'sub_topic_id': sub_topic_id ?? ''
      };
      print(main_category_id);
      print(sub_category_id);
      print(topic_id);
      print(sub_topic_id);

      final response = await http.post(
          Uri.parse(ApiString.get_complete_the_paragraph),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(body));

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      print('Url: ${ApiString.get_complete_the_paragraph}');

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        if (responseData['status'] == 1) {
          getCompleteParaData.value = (responseData["data"] as List)
              .map((paraJson) => CompleteParaData.fromJson(paraJson))
              .toList();
          print("Fetched ${getCompleteParaData.length} Complete the para");
        } else {
          showSnackbar(
              message: responseData['message'] ??
                  "Failed to fetch Complete the para ");
        }
      } else {
        showSnackbar(
            message:
                "Failed to fetch Complete the para. Status: ${response.statusCode}");
      }
    } catch (e) {
      showSnackbar(message: "Error while fetching Complete the para: $e");
      log(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  getAllLearningSlideApi(
      {required String main_category_id,
      required String sub_category_id,
      required String topic_id,
      required sub_topic_id}) async {
    isLoading.value = true;
    getLearningSlideData.clear();
    try {
      var body = {
        'main_category_id': main_category_id,
        'sub_category_id': sub_category_id,
        'topic_id': topic_id,
        'sub_topic_id': sub_topic_id ?? ''
      };
      final response = await http.post(Uri.parse(ApiString.get_learning_slide),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(body));

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      print('Url: ${ApiString.get_learning_slide}');

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        if (responseData['status'] == 1) {
          // Parse each JSON object into a Data model
          getLearningSlideData.value = (responseData["data"] as List)
              .map((slideJson) => LearningSlide.fromJson(slideJson))
              .toList();
          print("Fetched ${getLearningSlideData.length} learning slide");
        } else {
          showSnackbar(
              message:
                  responseData['message'] ?? "Failed to fetch learning slide ");
        }
      } else {
        showSnackbar(
            message:
                "Failed to fetch learning slide. Status: ${response.statusCode}");
      }
    } catch (e) {
      showSnackbar(message: "Error while fetching learning slide: $e");
      log(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  getAllMCQS(
      {required String main_category_id,
      required String sub_category_id,
      required String topic_id,
      String? sub_topic_id}) async {
    isLoading.value = true;
    getMcqslits.clear();
    try {
      var body = {
        'main_category_id': main_category_id,
        'sub_category_id': sub_category_id,
        'topic_id': topic_id,
        'sub_topic_id': sub_topic_id ?? ''
      };
      final response = await http.post(Uri.parse(ApiString.get_mcq),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(body));

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      print('Url: ${ApiString.get_mcq}');

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        if (responseData['status'] == 1) {
          // Parse each JSON object into a Data model
          getMcqslits.value = (responseData["data"] as List)
              .map((mcqJson) => Mcqs.fromJson(mcqJson))
              .toList();

          print("Fetched ${getMcqslits.length} mcqs");
        } else {
          showSnackbar(
              message: responseData['message'] ?? "Failed to fetch mcqs ");
        }
      } else {
        showSnackbar(
            message: "Failed to fetch mcqs. Status: ${response.statusCode}");
      }
    } catch (e) {
      showSnackbar(message: "Error while fetching mcqs: $e");
      log(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  /// delete mcq
  delete_Mcq({required String question_ids}) async {
    isLoading.value = true;

    try {
      final Map<String, dynamic> body = {
        "question_id": question_ids,
      };

      final response = await http.delete(
        Uri.parse(ApiString.delete_mcq),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      print('Response url: ${ApiString.delete_mcq}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        if (responseData['status'] == 1) {
          showSnackbar(message: "MCQ deleted successfully");
        } else {
          showSnackbar(message: "Failed to delete MCQ");
        }
      }
    } catch (e) {
      showSnackbar(message: "Error while delete $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// get all re-arrange api
  getAllRe_Arrange(
      {required String main_category_id,
      required String sub_category_id,
      required String topic_id,
      String? sub_topic_id}) async {
    isLoading.value = true;
    try {
      var body = {
        'main_category_id': main_category_id,
        'sub_category_id': sub_category_id,
        'topic_id': topic_id,
        'sub_topic_id': sub_topic_id ?? ''
      };
      final response = await http.post(Uri.parse(ApiString.get_rearrange),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(body));

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      print('Url: ${ApiString.get_rearrange}');

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        if (responseData['status'] == 1) {
          // Parse each JSON object into a Data model
          getReArrangeList.clear();
          getReArrangeList.value = (responseData["data"] as List)
              .map((mcqJson) => ReArrange.fromJson(mcqJson))
              .toList();

          print("Fetched ${getReArrangeList.length} mcqs");
        } else {
          showSnackbar(
              message: responseData['message'] ?? "Failed to fetch mcqs ");
        }
      } else {
        showSnackbar(
            message: "Failed to fetch mcqs. Status: ${response.statusCode}");
      }
    } catch (e) {
      showSnackbar(message: "Error while fetching mcqs: $e");
      log(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  /// get true false api
  getTrueORFalse(
      {required String main_category_id,
      required String sub_category_id,
      required String topic_id,
      String? sub_topic_id}) async {
    isLoading.value = true;
    try {
      var body = {
        'main_category_id': main_category_id,
        'sub_category_id': sub_category_id,
        'topic_id': topic_id,
        'sub_topic_id': sub_topic_id ?? ''
      };
      final response = await http.post(Uri.parse(ApiString.get_true_false),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(body));

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      print('Url: ${ApiString.get_true_false}');

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        if (responseData['status'] == 1) {
          // Parse each JSON object into a Data model
          getTrueOrFalseList.clear();
          getTrueOrFalseList.value = (responseData["data"] as List)
              .map((mcqJson) => TrueOrFalse.fromJson(mcqJson))
              .toList();

          print("Fetched ${getTrueOrFalseList.length} mcqs");
        } else {
          showSnackbar(
              message: responseData['message'] ?? "Failed to fetch mcqs ");
        }
      } else {
        showSnackbar(
            message: "Failed to fetch mcqs. Status: ${response.statusCode}");
      }
    } catch (e) {
      showSnackbar(message: "Error while fetching mcqs: $e");
      log(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  /// get fill in the blanks api
  getFillInTheBlanks(
      {required String main_category_id,
      required String sub_category_id,
      required String topic_id,
      String? sub_topic_id}) async {
    isLoading.value = true;
    getFillInTheBlanksList.clear();
    try {
      var body = {
        'main_category_id': main_category_id,
        'sub_category_id': sub_category_id,
        'topic_id': topic_id,
        'sub_topic_id': sub_topic_id ?? ''
      };
      final response = await http.post(Uri.parse(ApiString.get_fill_blanks),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(body));

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        if (responseData['status'] == 1) {
          // Parse each JSON object into a Data model
          getFillInTheBlanksList.clear();
          getFillInTheBlanksList.value = (responseData["data"] as List)
              .map((mcqJson) => FillInTheBlanks.fromJson(mcqJson))
              .toList();

          print("Fetched ${getTrueOrFalseList.length} mcqs");
        } else {
          showSnackbar(
              message: responseData['message'] ?? "Failed to fetch mcqs ");
        }
      } else {
        showSnackbar(
            message: "Failed to fetch mcqs. Status: ${response.statusCode}");
      }
    } catch (e) {
      showSnackbar(message: "Error while fetching mcqs: $e");
      log(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  /// get story data api
  getStoryData(
      {required String main_category_id,
      required String sub_category_id,
      required String topic_id,
      String? sub_topic_id}) async {
    isLoading.value = true;
    getStoryDataList.clear();
    try {
      var body = {
        'main_category_id': main_category_id,
        'sub_category_id': sub_category_id,
        'topic_id': topic_id,
        'sub_topic_id': sub_topic_id ?? ''
      };
      final response = await http.post(Uri.parse(ApiString.get_story),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(body));

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        if (responseData['status'] == 1) {
          // Parse each JSON object into a Data model
          getStoryDataList.clear();
          getStoryDataList.value = (responseData["data"] as List)
              .map((mcqJson) => StoryData.fromJson(mcqJson))
              .toList();

          print("Fetched ${getTrueOrFalseList.length} mcqs");
        } else {
          showSnackbar(
              message: responseData['message'] ?? "Failed to fetch mcqs ");
        }
      } else {
        showSnackbar(
            message: "Failed to fetch mcqs. Status: ${response.statusCode}");
      }
    } catch (e) {
      showSnackbar(message: "Error while fetching mcqs: $e");
      log(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  getStoryPhrases(
      {required String main_category_id,
      required String sub_category_id,
      required String topic_id,
      required String sub_topic_id}) async {
    isLoading.value = true;
    getStoryPhrasesList.clear();
    try {
      var body = {
        'main_category_id': main_category_id,
        'sub_category_id': sub_category_id,
        'topic_id': topic_id,
        'sub_topic_id': sub_topic_id ?? ''
      };
      final response = await http.post(Uri.parse(ApiString.get_story_phrases),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(body));

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        if (responseData['status'] == 1) {
          // Parse each JSON object into a Data model
          getStoryPhrasesList.clear();
          getStoryPhrasesList.value = (responseData["data"] as List)
              .map((mcqJson) => StoryPhrases.fromJson(mcqJson))
              .toList();

          print("Fetched ${getStoryPhrasesList.length} phrases");
        } else {
          showSnackbar(
              message: responseData['message'] ?? "Failed to fetch phrases ");
        }
      } else {
        showSnackbar(
            message: "Failed to fetch phrases. Status: ${response.statusCode}");
      }
    } catch (e) {
      showSnackbar(message: "Error while fetching phrases: $e");
      log(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  getConversation(
      {required String main_category_id,
      required String sub_category_id,
      required String topic_id,
      String? sub_topic_id}) async {
    isLoading.value = true;
    getConversationList.clear();
    try {
      var body = {
        'main_category_id': main_category_id,
        'sub_category_id': sub_category_id,
        'topic_id': topic_id,
        'sub_topic_id': sub_topic_id ?? ''
      };
      final response = await http.post(
          Uri.parse(ApiString.get_user_conversation),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(body));

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        if (responseData['status'] == 1) {
          // Parse each JSON object into a Data model
          getConversationList.clear();
          getConversationList.value = (responseData["data"] as List)
              .map((mcqJson) => PhrasesData.fromJson(mcqJson))
              .toList();

          print("Fetched ${getConversationList.length} conversation");
        } else {
          showSnackbar(
              message: responseData['message'] ?? "Failed to fetch phrases ");
        }
      } else {
        showSnackbar(
            message:
                "Failed to fetch conversation. Status: ${response.statusCode}");
      }
    } catch (e) {
      showSnackbar(message: "Error while fetching conversation: $e");
      log(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  getMatchPairs({
    required String main_category_id,
    required String sub_category_id,
    required String topic_id,
    String? sub_topic_id,
  }) async {
    isLoading.value = true;
    print("main_category_id: $main_category_id");
    print("sub_category_id: $sub_category_id");
    print("topic_id: $topic_id");
    print("sub_topic_id: $sub_topic_id");
    getMatchPairsList.clear();

    try {
      // Constructing the query parameters
      var queryParams = {
        'main_category_id': main_category_id,
        'sub_category_id': sub_category_id,
        'topic_id': topic_id,
        if (sub_topic_id != null) 'sub_topic_id': sub_topic_id,
      };

      // Constructing the full URI with query parameters
      var uri = Uri.parse(ApiString.get_match_pair_question)
          .replace(queryParameters: queryParams);

      // Making the GET request
      final response = await http.get(
        uri,
        headers: {"Content-Type": "application/json"},
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);

        if (jsonResponse['status'] == 1) {
          // Parse JSON data into a List of MatchPairs
          getMatchPairsList.value = (jsonResponse["data"] as List)
              .map((mcqJson) => MatchPairs.fromJson(mcqJson))
              .toList();

          print("Fetched ${getMatchPairsList.length} MatchPairs");
        } else {
          showSnackbar(
              message: jsonResponse['message'] ?? "Failed to fetch MatchPairs");
        }
      } else {
        showSnackbar(
            message:
                "Failed to fetch MatchPairs. Status: ${response.statusCode}");
      }
    } catch (e) {
      showSnackbar(message: "Error while fetching MatchPairs: $e");
      log(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  updateLearningTableQuestionApi(LearningSlide question) async {
    isLoading.value = true;
    try {
      final response = await http.post(
        Uri.parse(ApiString.update_learning_slide),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'learning_slide_id': question.id,
          'main_category_id': question.mainCategoryId,
          'sub_category_id': question.subCategoryId,
          'topic_id': question.topicId,
          'sub_topic_id': question.subTopicId,
          'title': question.title,
          'definition': question.definition,
          'transcriptionOne': question.transcriptionOne,
          'grammarExamples': question.grammarExamples,
          'transcriptionTwo': question.transcriptionTwo,
          'index': question.index,
          'points': question.points,
        }),
      );

      if (response.statusCode == 200) {
        await getAllLearningSlideApi(
          main_category_id: question.mainCategoryId,
          sub_category_id: question.subCategoryId,
          topic_id: question.topicId,
          sub_topic_id: question.subTopicId,
        );
      } else {
        print('Failed to update question: ${response.body}');
      }
    } catch (e) {
      print('Error updating question: $e');
    } finally {
      isLoading.value = false; // Set loading state to false
    }
  }

  ///update Story Phrases Table Question Api
  updateStoryPhrasesTableQuestionApi(StoryPhrases question) async {
    isLoading.value = true;
    try {
      final response = await http.post(
        Uri.parse(ApiString.update_story_phrases),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'story_phrases_id': question.id,
          'main_category_id': question.mainCategoryId,
          'sub_category_id': question.subCategoryId,
          'topic_id': question.topicId,
          'sub_topic_id': question.subTopicId,
          'phrase_name': question.phraseName,
          'index': question.index,
          'points': question.points,
        }),
      );

      if (response.statusCode == 200) {
        await getStoryPhrases(
            main_category_id: question.mainCategoryId.toString(),
            sub_category_id: question.subCategoryId.toString(),
            topic_id: question.topicId.toString(),
            sub_topic_id: question.subTopicId.toString());
      } else {
        print('Failed to update question: ${response.body}');
      }
    } catch (e) {
      print('Error updating question: $e');
    } finally {
      isLoading.value = false; // Set loading state to false
    }
  }

  ///delete Story Phrases Table Question Api
  deleteStoryPhraseAPI({
    required String main_category_id,
    required String sub_category_id,
    required String topic_id,
    required String sub_topic_id,
    required String phrase_ids,
  }) async {
    final response = await http.delete(
      Uri.parse(ApiString.delete_story_phrases),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'main_category_id': main_category_id,
        'sub_category_id': sub_category_id,
        'topic_id': topic_id,
        'sub_topic_id': sub_topic_id,
        'phrase_id': phrase_ids,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete phrase: ${response.body}');
    }
  }

  ///update Complete Word Table Question Api
  updateCompleteWordTableQuestionApi(CompleteWordData question) async {
    isLoading.value = true;
    try {
      final response = await http.post(
        Uri.parse(ApiString.update_complete_word),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'word_id': question.id,
          'main_category_id': question.mainCategoryId,
          'sub_category_id': question.subCategoryId,
          'topic_id': question.topicId,
          'sub_topic_id': question.subTopicId,
          'question_type': question.questionType,
          'question': question.question,
          'title': question.title,
          'option_a': question.optionA,
          'option_b': question.optionB,
          'option_c': question.optionC,
          'option_d': question.optionD,
          'answer': question.answer,
          'index': question.index,
          'points': question.points,
        }),
      );

      if (response.statusCode == 200) {
        await getStoryPhrases(
            main_category_id: question.mainCategoryId.toString(),
            sub_category_id: question.subCategoryId.toString(),
            topic_id: question.topicId.toString(),
            sub_topic_id: question.subTopicId.toString());
      } else {
        print('Failed to update question: ${response.body}');
      }
    } catch (e) {
      print('Error updating question: $e');
    } finally {
      isLoading.value = false; // Set loading state to false
    }
  }

  /// update true false api
  updateTrueFalseQuestionAPI(TrueOrFalse question) async {
    isLoading.value = true;
    try {
      print(question.topicId);
      final response = await http.post(
        Uri.parse(ApiString.update_true_false),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'true_false_id': question.id,
          'main_category_id': question.mainCategoryId,
          'sub_category_id': question.subCategoryId,
          'topic_id': question.topicId,
          'sub_topic_id': question.subTopicId,
          'question_type': question.questionType,
          'question': question.question,
          'answer': question.answer,
          'index': question.index,
          'points': question.points,
        }),
      );

      if (response.statusCode == 200) {
        await getTrueORFalse(
            main_category_id: question.mainCategoryId.toString(),
            sub_category_id: question.subCategoryId.toString(),
            topic_id: question.topicId.toString(),
            sub_topic_id: question.subTopicId.toString());
      } else {
        print('Failed to update question: ${response.body}');
      }
    } catch (e) {
      print('Error updating question: $e');
    } finally {
      isLoading.value = false; // Set loading state to false
    }
  }

  /// delete true false api
  deleteTrueFalseAPI({
    required String main_category_id,
    required String sub_category_id,
    required String topic_id,
    required String sub_topic_id,
    required String truefalse_ids,
  }) async {
    final response = await http.delete(
      Uri.parse(ApiString.delete_true_false),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'main_category_id': main_category_id,
        'sub_category_id': sub_category_id,
        'topic_id': topic_id,
        'sub_topic_id': sub_topic_id,
        'question_id': truefalse_ids,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete phrase: ${response.body}');
    }
  }

  /// update Mcq api
  updateMcqQuestionAPI(Mcqs question) async {
    isLoading.value = true;
    try {
      print(question.topicId);
      final response = await http.post(
        Uri.parse(ApiString.update_mcq),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'mcq_id': question.id,
          'main_category_id': question.mainCategoryId,
          'sub_category_id': question.subCategoryId,
          'topic_id': question.topicId,
          'sub_topic_id': question.subTopicId,
          'question_type': question.questionType,
          'question': question.question,
          'title': question.title,
          'option_a': question.optionA,
          'option_b': question.optionB,
          'option_c': question.optionC,
          'option_d': question.optionD,
          'answer': question.answer,
          'index': question.index,
          'points': question.points,
        }),
      );

      if (response.statusCode == 200) {
        await getAllMCQS(
            main_category_id: question.mainCategoryId.toString(),
            sub_category_id: question.subCategoryId.toString(),
            topic_id: question.topicId.toString(),
            sub_topic_id: question.subTopicId.toString());
      } else {
        print('Failed to update question: ${response.body}');
      }
    } catch (e) {
      print('Error updating question: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// delete mcq api
  // deleteMcqAPI({
  //   required String main_category_id,
  //   required String sub_category_id,
  //   required String topic_id,
  //   required String sub_topic_id,
  //   required String question_id,
  // }) async {
  //   final response = await http.delete(
  //     Uri.parse(ApiString.delete_mcq),
  //     headers: {
  //       'Content-Type': 'application/json',
  //     },
  //     body: jsonEncode({
  //       'main_category_id': main_category_id,
  //       'sub_category_id': sub_category_id,
  //       'topic_id': topic_id,
  //       'sub_topic_id': sub_topic_id,
  //       'question_id': question_id,
  //     }),
  //   );
  //
  //   if (response.statusCode != 200) {
  //     throw Exception('Failed to delete phrase: ${response.body}');
  //   }
  // }


  /// update true false api




}
