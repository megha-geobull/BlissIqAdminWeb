import 'dart:convert';
import 'dart:developer';
import 'package:blissiqadmin/Global/constants/ApiString.dart';
import 'package:blissiqadmin/Global/constants/common_snackbar.dart';
import 'package:blissiqadmin/Home/Quetion%20type%20widgets/model/CardFlipModel.dart';
import 'package:blissiqadmin/Home/Quetion%20type%20widgets/model/GetCompleteParagraphModel.dart';
import 'package:blissiqadmin/Home/Quetion%20type%20widgets/model/GetCompleteWordModel.dart';
import 'package:blissiqadmin/Home/Quetion%20type%20widgets/model/LearningSlideModel.dart';
import 'package:blissiqadmin/Home/Quetion%20type%20widgets/model/UserConversationModel.dart';
import 'package:blissiqadmin/Home/Quetion%20type%20widgets/model/get_fill_in_the_blanks.dart';
import 'package:blissiqadmin/Home/Quetion%20type%20widgets/model/get_match_the_pairs.dart';
import 'package:blissiqadmin/Home/Quetion%20type%20widgets/model/get_rearrange_model.dart';
import 'package:blissiqadmin/Home/Quetion%20type%20widgets/model/get_story_model.dart';
import 'package:blissiqadmin/Home/Quetion%20type%20widgets/model/get_story_phrases_model.dart';
import 'package:blissiqadmin/Home/Quetion%20type%20widgets/model/get_trueOrfalse_model.dart';
import 'package:blissiqadmin/Home/Quetion%20type%20widgets/model/guess_the_image.dart';
import 'package:blissiqadmin/Home/Quetion%20type%20widgets/model/image_puzzle_model.dart';
import 'package:blissiqadmin/Home/Quetion%20type%20widgets/model/re_arrange_sentence_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:get/get.dart';
import 'package:blissiqadmin/Home/Quetion%20type%20widgets/model/get_mcqs.dart';
import 'package:mime/mime.dart';
import 'dart:typed_data' as td;


class GetAllQuestionsApiController extends GetxController{
  RxBool isLoading = false.obs;

  RxList<Mcqs> getMcqslits = <Mcqs>[].obs;
  RxList<ReArrange> getReArrangeList = <ReArrange>[].obs;
  RxList<ReArrangeSentenceData> getReArrangeSentenceDataList = <ReArrangeSentenceData>[].obs;
  RxList<TrueOrFalse> getTrueOrFalseList = <TrueOrFalse>[].obs;
  RxList<FillInTheBlanks> getFillInTheBlanksList = <FillInTheBlanks>[].obs;
  RxList<StoryData> getStoryDataList = <StoryData>[].obs;
  RxList<GuessTheImageData> guessTheImageList = <GuessTheImageData>[].obs;
  RxList<ImagePuzzleData> imagePuzzleDataList = <ImagePuzzleData>[].obs;

  RxList<StoryPhrases> getStoryPhrasesList = <StoryPhrases>[].obs;
  RxList<UserConversationalData> getConversationList = <UserConversationalData>[].obs;
  RxList<MatchPairs> getMatchPairsList = <MatchPairs>[].obs;
  RxList<CardFlipData> getCardFlipList = <CardFlipData>[].obs;


  RxList<LearningSlide> getLearningSlideData = <LearningSlide>[].obs;
  RxList<CompleteWordData> getCompleteWordData = <CompleteWordData>[].obs;
  RxList<CompleteParaData> getCompleteParaData = <CompleteParaData>[].obs;

  get question_id => null;


  clearData(){
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
    guessTheImageList.clear();
    getReArrangeSentenceDataList.clear();
  }


  getCompleteWordApi({
    required String main_category_id ,
    required String sub_category_id,
    required String topic_id,
    String? sub_topic_id}) async {
    isLoading.value = true;
    getLearningSlideData.clear();
    try {
      var body = {
        'main_category_id':main_category_id,
        'sub_category_id':sub_category_id,
        'topic_id':topic_id,
        'sub_topic_id':sub_topic_id??''
      };
      final response = await http.post(
          Uri.parse(ApiString.get_complete_the_word),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(body)
      );

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
          showSnackbar(message: responseData['message'] ?? "Failed to fetch complete word ");
        }
      } else {
        showSnackbar(message: "Failed to fetch word. Status: ${response.statusCode}");
      }
    } catch (e) {
      showSnackbar(message: "Error while fetching complete word: $e");
      log(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  getReArrangeSentenceApi({
    required String main_category_id ,
    required String sub_category_id,
    required String topic_id,
    String? sub_topic_id}) async {
    isLoading.value = true;
    getReArrangeSentenceDataList.clear();
    try {
      var body = {
        'main_category_id':main_category_id,
        'sub_category_id':sub_category_id,
        'topic_id':topic_id,
        'sub_topic_id':sub_topic_id??''
      };
      final response = await http.post(
          Uri.parse(ApiString.get_complete_sentence),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(body)
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      print('Url: ${ApiString.get_complete_sentence}');

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        if (responseData['status'] == 1) {
          getReArrangeSentenceDataList.value = (responseData["data"] as List)
              .map((wordJson) => ReArrangeSentenceData.fromJson(wordJson))
              .toList();
          print("Fetched ${getReArrangeSentenceDataList.length} complete word");
        } else {
          showSnackbar(message: responseData['message'] ?? "Failed to fetch complete word ");
        }
      } else {
        showSnackbar(message: "Failed to fetch word. Status: ${response.statusCode}");
      }
    } catch (e) {
      showSnackbar(message: "Error while fetching complete word: $e");
      log(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  getGuessTheImage({
    required String main_category_id ,
    required String sub_category_id,
    required String topic_id,
    String? sub_topic_id}) async {
    isLoading.value = true;
    guessTheImageList.clear();
    try {
      var body = {
        'main_category_id':main_category_id,
        'sub_category_id':sub_category_id,
        'topic_id':topic_id,
        'sub_topic_id':sub_topic_id??''
      };
      final response = await http.post(
          Uri.parse(ApiString.get_guess_the_image),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(body)
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      print('Url: ${ApiString.get_guess_the_image}');

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        if (responseData['status'] == 1) {
          // Parse each JSON object into a Data model
          guessTheImageList.value = (responseData["data"] as List)
              .map((wordJson) => GuessTheImageData.fromJson(wordJson))
              .toList();
          print("Fetched ${guessTheImageList.length} guess the image");
        } else {
          showSnackbar(message: responseData['message'] ?? "Failed to fetch guess the image ");
        }
      } else {
        showSnackbar(message: "Failed to fetch word. Status: ${response.statusCode}");
      }
    } catch (e) {
      showSnackbar(message: "Error while fetching guess the image: $e");
      log(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  getCompleteParaApi({
    required String main_category_id ,
    required String sub_category_id,
    required String topic_id,
    required String sub_topic_id}) async {
    isLoading.value = true;
    getCompleteParaData.clear();
    try {
      var body = {
        'main_category_id':main_category_id,
        'sub_category_id':sub_category_id,
        'topic_id':topic_id,
        'sub_topic_id':sub_topic_id??''
      };

      final response = await http.post(
          Uri.parse(ApiString.get_complete_the_paragraph),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(body)
      );

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
          showSnackbar(message: responseData['message'] ?? "Failed to fetch Complete the para ");
        }
      } else {
        showSnackbar(message: "Failed to fetch Complete the para. Status: ${response.statusCode}");
      }
    } catch (e) {
      showSnackbar(message: "Error while fetching Complete the para: $e");
      log(e.toString());
    } finally {
      isLoading.value = false;
    }
  }


  getAllLearningSlideApi({
    required String main_category_id,
    required String sub_category_id,
    required String topic_id,
    required String sub_topic_id,
  }) async {
    isLoading.value = true;
    getLearningSlideData.clear();

    try {
      var body = {
        'main_category_id': main_category_id,
        'sub_category_id': sub_category_id,
        'topic_id': topic_id,
        'sub_topic_id': sub_topic_id.isEmpty ? '' : sub_topic_id
      };

      final response = await http.post(
        Uri.parse(ApiString.get_learning_slide),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');
      print('API URL: ${ApiString.get_learning_slide}');

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);

        if (responseData['status'] == 1 && responseData["data"] is List) {
          print("Raw Data: ${responseData["data"]}");

          // Parse JSON into LearningSlide objects
          getLearningSlideData.assignAll(
            (responseData["data"] as List)
                .map((slideJson) {
              try {
                return LearningSlide.fromJson(slideJson);
              } catch (e) {
                print("Error parsing slide: $e");
                return null;
              }
            })
                .whereType<LearningSlide>() // Remove null values
                .toList(),
          );

          print("Fetched ${getLearningSlideData.length} learning slides");
        } else {
          showSnackbar(message: responseData['message'] ?? "Failed to fetch learning slides.");
        }
      } else {
        showSnackbar(message: "Failed to fetch learning slides. Status: ${response.statusCode}");
      }
    } catch (e) {
      showSnackbar(message: "Error while fetching learning slides: $e");
      log(e.toString());
    } finally {
      isLoading.value = false;
      print("Final Learning Slide Count: ${getLearningSlideData.length}");
    }
  }

  getAllMCQS({
    required String main_category_id ,
    required String sub_category_id,
    required String topic_id,
    String? sub_topic_id}) async {
    isLoading.value = true;
    getMcqslits.clear();
    try {
      var body = {
        'main_category_id':main_category_id,
        'sub_category_id':sub_category_id,
        'topic_id':topic_id,
        'sub_topic_id':sub_topic_id??''
      };
      final response = await http.post(
          Uri.parse(ApiString.get_mcq),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(body)
      );

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
          showSnackbar(message: responseData['message'] ?? "Failed to fetch mcqs ");
        }
      } else {
        showSnackbar(message: "Failed to fetch mcqs. Status: ${response.statusCode}");
      }
    } catch (e) {
      showSnackbar(message: "Error while fetching mcqs: $e");
      log(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

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
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  deleteConversation({required String question_ids}) async {
    isLoading.value = true;

    try {
      final Map<String, dynamic> body = {
        "conversation_id": question_ids,
      };

      final response = await http.delete(
        Uri.parse(ApiString.delete_conversation),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      print('Response url: ${ApiString.delete_mcq}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        if (responseData['status'] == 1) {
          showSnackbar(message: "conversation deleted successfully");
        } else {
          showSnackbar(message: "Failed to delete conversation");
        }
      }
    } catch (e) {
      showSnackbar(message: "Error while delete $e");
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  getAllRe_Arrange({
    required String main_category_id ,
    required String sub_category_id,
    required String topic_id,
    String? sub_topic_id}) async {
    isLoading.value = true;
    try {
      var body = {
        'main_category_id':main_category_id,
        'sub_category_id':sub_category_id,
        'topic_id':topic_id,
        'sub_topic_id':sub_topic_id??''
      };
      final response = await http.post(
          Uri.parse(ApiString.get_rearrange),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(body)
      );

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
          showSnackbar(message: responseData['message'] ?? "Failed to fetch mcqs ");
        }
      } else {
        showSnackbar(message: "Failed to fetch mcqs. Status: ${response.statusCode}");
      }
    } catch (e) {
      showSnackbar(message: "Error while fetching mcqs: $e");
      log(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  getTrueORFalse({
    required String main_category_id ,
    required String sub_category_id,
    required String topic_id,
    String? sub_topic_id}) async {
    isLoading.value = true;
    try {
      var body = {
        'main_category_id':main_category_id,
        'sub_category_id':sub_category_id,
        'topic_id':topic_id,
        'sub_topic_id':sub_topic_id??''
      };
      final response = await http.post(
          Uri.parse(ApiString.get_true_false),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(body)
      );

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
          showSnackbar(message: responseData['message'] ?? "Failed to fetch mcqs ");
        }
      } else {
        showSnackbar(message: "Failed to fetch mcqs. Status: ${response.statusCode}");
      }
    } catch (e) {
      showSnackbar(message: "Error while fetching mcqs: $e");
      log(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  getFillInTheBlanks({
    required String main_category_id ,
    required String sub_category_id,
    required String topic_id,
    String? sub_topic_id}) async {
    isLoading.value = true;
    getFillInTheBlanksList.clear();
    try {
      var body = {
        'main_category_id':main_category_id,
        'sub_category_id':sub_category_id,
        'topic_id':topic_id,
        'sub_topic_id':sub_topic_id??''
      };
      final response = await http.post(
          Uri.parse(ApiString.get_fill_blanks),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(body)
      );

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
          showSnackbar(message: responseData['message'] ?? "Failed to fetch mcqs ");
        }
      } else {
        showSnackbar(message: "Failed to fetch mcqs. Status: ${response.statusCode}");
      }
    } catch (e) {
      showSnackbar(message: "Error while fetching mcqs: $e");
      log(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  getStoryData({
    required String main_category_id ,
    required String sub_category_id,
    required String topic_id,
    String? sub_topic_id}) async {
    isLoading.value = true;
    getStoryDataList.clear();
    try {
      var body = {
        'main_category_id':main_category_id,
        'sub_category_id':sub_category_id,
        'topic_id':topic_id,
        'sub_topic_id':sub_topic_id??''
      };
      final response = await http.post(
          Uri.parse(ApiString.get_story),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(body)
      );

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
          showSnackbar(message: responseData['message'] ?? "Failed to fetch mcqs ");
        }
      } else {
        showSnackbar(message: "Failed to fetch mcqs. Status: ${response.statusCode}");
      }
    } catch (e) {
      showSnackbar(message: "Error while fetching mcqs: $e");
      log(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  getStoryPhrases({
    required String main_category_id ,
    required String sub_category_id,
    required String topic_id,
    required String sub_topic_id}) async {
    isLoading.value = true;
    getStoryPhrasesList.clear();
    try {
      var body = {
        'main_category_id':main_category_id,
        'sub_category_id':sub_category_id,
        'topic_id':topic_id,
        'sub_topic_id':sub_topic_id??''
      };
      final response = await http.post(
          Uri.parse(ApiString.get_story_phrases),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(body)
      );

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
          showSnackbar(message: responseData['message'] ?? "Failed to fetch phrases ");
        }
      } else {
        showSnackbar(message: "Failed to fetch phrases. Status: ${response.statusCode}");
      }
    } catch (e) {
      showSnackbar(message: "Error while fetching phrases: $e");
      log(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  getConversation({
    required String main_category_id ,
    required String sub_category_id,
    required String topic_id,
    String? sub_topic_id}) async {
    isLoading.value = true;
    getConversationList.clear();
    try {
      var body = {
        'main_category_id':main_category_id,
        'sub_category_id':sub_category_id,
        'topic_id':topic_id,
        'sub_topic_id':sub_topic_id??''
      };
      final response = await http.post(
          Uri.parse(ApiString.get_user_conversation),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(body)
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        if (responseData['status'] == 1) {
          // Parse each JSON object into a Data model
          getConversationList.clear();
          getConversationList.value = (responseData["data"] as List)
              .map((conversationJson) => UserConversationalData.fromJson(conversationJson))
              .toList();

          print("Fetched ${getConversationList.length} conversation");
        } else {
          showSnackbar(message: responseData['message'] ?? "Failed to fetch phrases ");
        }
      } else {
        showSnackbar(message: "Failed to fetch conversation. Status: ${response.statusCode}");
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
      var uri = Uri.parse(ApiString.get_match_pair_question).replace(queryParameters: queryParams);

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
          showSnackbar(message: jsonResponse['message'] ?? "Failed to fetch MatchPairs");
        }
      } else {
        showSnackbar(message: "Failed to fetch MatchPairs. Status: ${response.statusCode}");
      }
    } catch (e) {
      showSnackbar(message: "Error while fetching MatchPairs: $e");
      log(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  getCardFlip({
    required String main_category_id ,
    required String sub_category_id,
    required String topic_id,
    String? sub_topic_id}) async {
    isLoading.value = true;
    getCardFlipList.clear();
    try {
      var body = {
        'main_category_id':main_category_id,
        'sub_category_id':sub_category_id,
        'topic_id':topic_id,
        'sub_topic_id':sub_topic_id??''
      };
      final response = await http.post(
          Uri.parse(ApiString.get_card_flipping),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(body)
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        if (responseData['status'] == 1) {
          // Parse each JSON object into a Data model
          getCardFlipList.clear();
          getCardFlipList.value = (responseData["data"] as List)
              .map((mcqJson) => CardFlipData.fromJson(mcqJson))
              .toList();

          print("Fetched ${getCardFlipList.length} conversation");
        } else {
          showSnackbar(message: responseData['message'] ?? "Failed to fetch phrases ");
        }
      } else {
        showSnackbar(message: "Failed to fetch conversation. Status: ${response.statusCode}");
      }
    } catch (e) {
      showSnackbar(message: "Error while fetching conversation: $e");
      log(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  getImagePuzzleList({
    required String main_category_id ,
    required String sub_category_id,
    required String topic_id,
    String? sub_topic_id}) async {
    isLoading.value = true;
    imagePuzzleDataList.clear();
    try {
      var body = {
        'main_category_id':main_category_id,
        'sub_category_id':sub_category_id,
        'topic_id':topic_id,
        'sub_topic_id':sub_topic_id??''
      };
      final response = await http.post(
          Uri.parse(ApiString.get_puzzle_the_image),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(body)
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        if (responseData['status'] == 1) {
          // Parse each JSON object into a Data model
          imagePuzzleDataList.clear();
          imagePuzzleDataList.value = (responseData["data"] as List)
              .map((mcqJson) => ImagePuzzleData.fromJson(mcqJson))
              .toList();

          print("Fetched ${imagePuzzleDataList.length} puzzles ");
        } else {
          showSnackbar(message: responseData['message'] ?? "Failed to fetch image puzzles ");
        }
      } else {
        showSnackbar(message: "Failed to fetch image puzzles. Status: ${response.statusCode}");
      }
    } catch (e) {
      showSnackbar(message: "Error while fetching image puzzles: $e");
      log(e.toString());
    } finally {
      isLoading.value = false;
    }
  }




  updateConversationalApi(UserConversationalData question, pathsFile) async {
    isLoading.value = true;
    try {
      final response = await http.post(
        Uri.parse(ApiString.update_conversation),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'conversation_id':question.id,
          'main_category_id':question.mainCategoryId,
          'sub_category_id':question.subCategoryId,
          'topic_id': question.topicId,
          'sub_topic_id':question.subTopicId,
          'title': question.title,
          'bot_conversation': question.botConversation,
          'user_conversation': question.userConversation,
          'user_conversation_type': question.userConversationType,
          'options': question.options,
          'answer': question.answer,
          'index': question.index,
          'points': question.points,
        }),
      );

      if (response.statusCode == 200) {
        await getConversation(
          main_category_id: question.mainCategoryId,
          sub_category_id: question.subCategoryId,
          topic_id: question.topicId,
          sub_topic_id: question.subTopicId,);
      } else {
        print('Failed to update question: ${response.body}');
      }
    } catch (e) {
      print('Error updating question: $e');
    } finally {
      isLoading.value = false; // Set loading state to false
    }
  }


  updateCardFlip({
    required CardFlipData question,
    required BuildContext context,
  }) async {
    isLoading.value = true;

    try {
      final uri = Uri.parse(ApiString.update_card_flipping);
      final request = http.MultipartRequest('POST', uri);
      // Add text fields
      request.fields['card_flipping_id'] = question.id.toString();
      request.fields['main_category_id'] = question.mainCategoryId.toString();
      request.fields['sub_category_id'] = question.subCategoryId.toString();
      request.fields['topic_id'] = question.topicId.toString();
      request.fields['sub_topic_id'] = question.subTopicId.toString() ?? '';
      request.fields['title'] = question.title ?? '';
      request.fields['question_type'] = question.questionType ?? '';
      request.fields['index'] = question.index.toString() ?? '';
      request.fields['points'] = question.points.toString() ?? '';

      // Print request body (fields)
      print("Request Fields: ${request.fields}");

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


  updateCardFlipEntry({
    required String id,
    required List<td.Uint8List> images,
    required String letters,
    required BuildContext context,
  }) async {
    isLoading.value = true;

    try {
      final uri = Uri.parse(ApiString.add_card_flip_entry);
      final request = http.MultipartRequest('POST', uri);
      // Add text fields
      request.fields['letter'] = letters;
      request.fields['card_pair'] = id;
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

   updateImagePuzzle({
    required ImagePuzzleData question,
    required List<td.Uint8List> images,
    required String letters,
    required BuildContext context,
  }) async {
    isLoading.value = true;

    try {
      final uri = Uri.parse(ApiString.update_puzzle_the_image);
      final request = http.MultipartRequest('POST', uri);
      // Add text fields
      request.fields['puzzle_id'] = question.id.toString();
      request.fields['main_category_id'] = question.mainCategoryId.toString();
      request.fields['sub_category_id'] = question.subCategoryId.toString();
      request.fields['topic_id'] = question.topicId.toString();
      request.fields['sub_topic_id'] = question.subTopicId.toString() ?? '';
      request.fields['title'] = question.title ?? '';
      request.fields['question_type'] = question.questionType ?? '';
      request.fields['index'] = question.index.toString() ?? '';
      request.fields['points'] = question.points.toString() ?? '';
      request.fields['letter'] = letters;

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

   updateImagePuzzleEntry({
    required String id,
    required List<td.Uint8List> images,
    required String letters,
    required BuildContext context,
  }) async {
    isLoading.value = true;

    try {
      final uri = Uri.parse(ApiString.add_puzzle_entry);
      final request = http.MultipartRequest('POST', uri);
      // Add text fields
      request.fields['puzzle_id'] = id;
      request.fields['letter'] = letters;
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

  updateMatchThePairEntry({
    required String id,
    required List<td.Uint8List> qImages,
    required List<td.Uint8List> aImages,
    required String question,
    required String answer,
    required BuildContext context,
  }) async {
    isLoading.value = true;

    try {
      final uri = Uri.parse(ApiString.add_match_pair_question_entry);
      final request = http.MultipartRequest('POST', uri);
      // Add text fields
      request.fields['match_pair'] = id;
      request.fields['question'] = question;
      request.fields['answer'] = answer;
      // Print request body (fields)
      print("Request Fields: ${request.fields}");

      // Add images
      for (int i = 0; i < qImages.length; i++) {
        final image = qImages[i];
        request.files.add(
          http.MultipartFile.fromBytes(
            'question_img',
            image,
            filename: 'image_$i.png',
            contentType: MediaType('image', 'png'),
          ),
        );
      }
      for (int i = 0; i < aImages.length; i++) {
        final image = aImages[i];
        request.files.add(
          http.MultipartFile.fromBytes(
            'answer_img',
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
//learning slide

  updateLearningTableQuestionApi(LearningSlide question) async {
    isLoading.value = true;
    try {
      final response = await http.post(
        Uri.parse(ApiString.update_learning_slide),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'learning_slide_id':question.id,
          'main_category_id':question.mainCategoryId,
          'sub_category_id':question.subCategoryId,
          'topic_id': question.topicId,
          'sub_topic_id':question.subTopicId,
          'title': question.title,
          'definition': question.definition,
          'pdf_file': question.pdfFile,
          'video_file': question.videoFile,
          'ppt_file': question.pptFile,
          'image_file': question.imageFile,
          'index': question.index,
          'points': question.points,
        }),
      );

      if (response.statusCode == 200) {
        await getAllLearningSlideApi(
          main_category_id: question.mainCategoryId,
          sub_category_id: question.subCategoryId,
          topic_id: question.topicId,
          sub_topic_id: question.subTopicId,);
      } else {
        print('Failed to update question: ${response.body}');
      }
    } catch (e) {
      print('Error updating question: $e');
    } finally {
      isLoading.value = false; // Set loading state to false
    }
  }

  deleteLearningSlideAPI({required String learning_ids}) async {
    isLoading.value = true;

    try {
      print(learning_ids);

      final Map<String, dynamic> body = {
        "learning_id": learning_ids,
      };

      print(body.toString());
      final response = await http.delete(
        Uri.parse(ApiString.delete_learning_slide),
        headers: {
          "Content-Type": "application/json",
          "Access-Control-Allow-Origin": "*"  // Corrected header
        },
        body:jsonEncode(body),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      print('Response url: ${ApiString.delete_learning_slide}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        if (responseData['status'] == 1) {
          showSnackbar(message: "Learning slide deleted successfully");
        } else {
          showSnackbar(message: "Failed to delete learning slide");
        }
      }
    } catch (e) {
      showSnackbar(message: "Error while deleting: $e");
      print(e);
    } finally {
      isLoading.value = false;
    }
  }



  delete_match_pair_question({
    required String question_ids,
    required BuildContext context,
  }) async {
    try {
      final response = await http.delete(
        Uri.parse(ApiString.delete_match_pair_question),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'question_id': question_ids,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Question deleted successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Something went wrong. Please try again later.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }


  //Update Story Phrases
  updateStoryPhrasesTableQuestionApi(StoryPhrases question) async {
    isLoading.value = true;
    if (kDebugMode) {
      print("Update Story Phrases Table Question Api ");
    }
    try {
      final response = await http.post(
        Uri.parse(ApiString.update_story_phrases),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'story_phrases_id':question.id,
          'main_category_id':question.mainCategoryId,
          'sub_category_id':question.subCategoryId,
          'topic_id': question.topicId,
          'sub_topic_id':question.subTopicId,
          'passage': question.passage,
          'index': question.index,
          'points': question.points,
          'question_format': question.questionFormat,
          'image': question.image,
          'image_name': question.imageName,
        }),
      );

      if (response.statusCode == 200) {
        await getStoryPhrases(
            main_category_id: question.mainCategoryId.toString(),
            sub_category_id: question.subCategoryId.toString(),
            topic_id: question.topicId.toString(),
            sub_topic_id: question.subTopicId.toString()
        );
      } else {
        if (kDebugMode) {
          print('Failed to update question: ${response.body}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error updating question: $e');
      }
    } finally {
      isLoading.value = false;
    }
  }


  //delete story phrases
  deleteStoryPhraseAPI({
    required String phrase_ids,

  }) async {
    final response = await http.delete(
      Uri.parse(ApiString.delete_story_phrases),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'phrase_id': phrase_ids,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete phrase: ${response.body}');
    }
  }

  // Update Rearrange thw word

  updateRearrangeTheWordApi(ReArrange question, List<int>? qImage) async {

    isLoading.value = true;
    try {
      var uri = Uri.parse(ApiString.update_rearrange);
      var request = http.MultipartRequest('POST', uri);
      // Add fields to the request
      request.fields['rearrange_id'] = question.id.toString();
      request.fields['main_category_id'] = question.mainCategoryId.toString();
      request.fields['sub_category_id'] = question.subCategoryId.toString();
      request.fields['topic_id'] = question.topicId.toString();
      request.fields['sub_topic_id'] = question.subTopicId.toString();
      request.fields['question_type'] = question.questionType ?? "";
      request.fields['title'] = question.title  ?? "";
      request.fields['question'] = question.question  ?? "";
      request.fields['answer'] = question.answer  ?? "";
      request.fields['index'] = question.index.toString();
      request.fields['points'] = question.points.toString();

      // Add image file if available
      if (qImage != null) {
        request.files.add(
          http.MultipartFile.fromBytes(
            'q_image',
            qImage,
            filename: 'question_image.png',
            contentType: MediaType('image', 'png'),
          ),
        );
      }

      var response = await request.send();
      if (response.statusCode == 200) {
        showSnackbar(message: "Question updated successfully");
      } else {
        print('Failed to update question: ${await response.stream.bytesToString()}');
      }
    } catch (e) {
      print('Error updating question: $e');
    } finally {
      isLoading.value = false;
    }
  }

  updateRearrangeSentenceApi(ReArrangeSentenceData question) async {
    isLoading.value = true;
    try {
      var uri = Uri.parse(ApiString.update_complete_sentence);
      var request = http.MultipartRequest('POST', uri);
      // Add fields to the request
      request.fields['question_id'] = question.id.toString();
      request.fields['question_format'] = question.questionFormat ?? "";
      request.fields['title'] = question.title  ?? "";
      request.fields['question'] = question.question  ?? "";
      request.fields['answer'] = question.answer  ?? "";
      request.fields['index'] = question.index.toString();
      request.fields['points'] = question.points.toString();

      var response = await request.send();
      if (response.statusCode == 200) {
        showSnackbar(message: "Question updated successfully");
      } else {
        print('Failed to update question: ${await response.stream.bytesToString()}');
      }
    } catch (e) {
      print('Error updating question: $e');
    } finally {
      isLoading.value = false;
    }
  }
  //delete api

  deleteReArrangeAPI({
    required String question_id,
  }) async {
    final response = await http.delete(
      Uri.parse(ApiString.delete_rearrange),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        // 'main_category_id': main_category_id,
        // 'sub_category_id': sub_category_id,
        // 'topic_id': topic_id,
        // 'sub_topic_id': sub_topic_id,
        'question_id': question_id,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete phrase: ${response.body}');
    }
  }


  //Update Fill in the blanks API

  updateFillInTheBlanksTableQuestionApi(
      FillInTheBlanks question, List<int>? qImage) async {
    isLoading.value = true;
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(ApiString.update_fill_blanks),
      );

      // Add headers
      request.headers.addAll({
        'Content-Type': 'multipart/form-data',
      });

      // Add fields
      request.fields.addAll({
        'fill_blank_id': question.id ?? '',
        'main_category_id': question.mainCategoryId ?? '',
        'sub_category_id': question.subCategoryId ?? '',
        'topic_id': question.topicId ?? '',
        'sub_topic_id': question.subTopicId ?? '',
        'question_type': question.questionType ?? '',
        'title': question.title ?? '',
        'question_language': question.questionLanguage ?? '',
        'question': question.question ?? '',
        'option_language': question.optionLanguage ?? '',
        'option_a': question.optionA ?? '',
        'option_b': question.optionB ?? '',
        'option_c': question.optionC ?? '',
        'option_d': question.optionD ?? '',
        'answer': question.answer ?? '',
        'index': question.index.toString(),
        'points': question.points.toString(),
      });

      // Add image if available
      if (qImage != null && qImage.isNotEmpty) {
        request.files.add(
          http.MultipartFile.fromBytes(
            'q_image', // Field name in API
            qImage,
            filename: 'question_image.png', // Adjust filename if needed
            contentType: MediaType('image', 'png'), // Adjust MIME type if needed
          ),
        );
      }

      // Send request
      var response = await request.send();

      if (response.statusCode == 200) {
        await getStoryPhrases(
          main_category_id: question.mainCategoryId.toString(),
          sub_category_id: question.subCategoryId.toString(),
          topic_id: question.topicId.toString(),
          sub_topic_id: question.subTopicId.toString(),
        );
      } else {
        print('Failed to update question: ${await response.stream.bytesToString()}');
      }
    } catch (e) {
      print('Error updating question: $e');
    } finally {
      isLoading.value = false; // Set loading state to false
    }
  }

// Delete Fill in the blanks
  deleteFillInTheBlanksAPI({
    required String main_category_id,
    required String sub_category_id,
    required String topic_id,
    required String sub_topic_id,
    required String question_id,
  }) async {
    final response = await http.delete(
      Uri.parse(ApiString.delete_fill_blanks),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'main_category_id': main_category_id,
        'sub_category_id': sub_category_id,
        'topic_id': topic_id,
        'sub_topic_id': sub_topic_id,
        'question_id': question_id,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete phrase: ${response.body}');
    }
  }

  deleteImagePuzzleAPI({
    required String puzzle_id,
  }) async {
    final response = await http.delete(
      Uri.parse(ApiString.delete_puzzle_the_image),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'puzzle_id': puzzle_id,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete phrase: ${response.body}');
    }
  }

  deleteImagePuzzleEntryAPI({
    required String puzzle_id,
  }) async {
    final response = await http.delete(
      Uri.parse(ApiString.delete_puzzle_entry),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'puzzle_entry_id': puzzle_id,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete phrase: ${response.body}');
    }
  }

  deleteCardFlipEntryAPI({
    required String card_entry_id,
  }) async {
    final response = await http.delete(
      Uri.parse(ApiString.delete_card_flip_entry),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'card_entry_id': card_entry_id,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete phrase: ${response.body}');
    }
  }

  deleteCardFlip({
    required String question_id,
  }) async {
    final response = await http.delete(
      Uri.parse(ApiString.delete_card_flipping),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'card_flipping_id': question_id,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete card flip: ${response.body}');
    }
  }

  deleteMatchThePairsEntryAPI({
    required String pair_id,
  }) async {
    final response = await http.delete(
      Uri.parse(ApiString.delete_match_pair_question_entry),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'match_pair_entry_id': pair_id,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete phrase: ${response.body}');
    }
  }

  //Update Story
  updateStoryTableQuestionApi(StoryData question) async {
    isLoading.value = true;
    try {
      final response = await http.post(
        Uri.parse(ApiString.update_story),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'story_id':question.id,
          'main_category_id':question.mainCategoryId,
          'sub_category_id':question.subCategoryId,
          'topic_id': question.topicId,
          'sub_topic_id':question.subTopicId,
          'story_title': question.storyTitle,
          'story_img': question.storyImg,
          'content': question.content,
          'points': question.points,
          'index': question.index,
        }),
      );

      if (response.statusCode == 200) {
        await getStoryPhrases(main_category_id: question.mainCategoryId.toString(), sub_category_id: question.subCategoryId.toString(),
            topic_id: question.topicId.toString(), sub_topic_id: question.subTopicId.toString()
        );
      } else {
        print('Failed to update question: ${response.body}');
      }
    } catch (e) {
      print('Error updating question: $e');
    } finally {
      isLoading.value = false;
    }
  }


  deleteStoryAPI({
    required String main_category_id,
    required String sub_category_id,
    required String topic_id,
    required String sub_topic_id,
    required String question_id,
  }) async {
    final response = await http.delete(
      Uri.parse(ApiString.delete_fill_blanks),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'main_category_id': main_category_id,
        'sub_category_id': sub_category_id,
        'topic_id': topic_id,
        'sub_topic_id': sub_topic_id,
        'question_id': question_id,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete phrase: ${response.body}');
    }
  }


  //Update true false

  updateTrueFalseTableQuestionApi( TrueOrFalse question, List<int>? qImage) async {
    isLoading.value = true;
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(ApiString.update_true_false),
      );

      // Add headers
      request.headers.addAll({
        'Content-Type': 'multipart/form-data',
      });

      // Add fields
      request.fields.addAll({
        'true_false_id': question.id ?? '',
        'main_category_id': question.mainCategoryId ?? '',
        'sub_category_id': question.subCategoryId ?? '',
        'topic_id': question.topicId ?? '',
        'sub_topic_id': question.subTopicId ?? '',
        'question_type': question.questionType ?? '',
        'question': question.question ?? '',
        'answer': question.answer ?? '',
        'points': question.points.toString(),
        'index': question.index.toString(),
      });

      // Add image if available
      if (qImage != null && qImage.isNotEmpty) {
        request.files.add(
          http.MultipartFile.fromBytes(
            'q_image', // Field name in API
            qImage,
            filename: 'question_image.png', // Change filename if needed
            contentType: MediaType('image', 'png'), // Adjust MIME type if needed
          ),
        );
      }

      // Send request
      var response = await request.send();

      if (response.statusCode == 200) {
print('Question update successfully');
      } else {
        print('Failed to update question: ${await response.stream.bytesToString()}');
      }
    } catch (e) {
      print('Error updating question: $e');
    } finally {
      isLoading.value = false; // Set loading state to false
    }
  }


  //delete true false

  // deleteTrueFalseAPI({
  //   required String main_category_id,
  //   required String sub_category_id,
  //   required String topic_id,
  //   required String sub_topic_id,
  //   required String true_false_id,
  // }) async {
  //   final response = await http.delete(
  //     Uri.parse(ApiString.delete_true_false),
  //     headers: {
  //       'Content-Type': 'application/json',
  //     },
  //     body: jsonEncode({
  //       'main_category_id': main_category_id,
  //       'sub_category_id': sub_category_id,
  //       'topic_id': topic_id,
  //       'sub_topic_id': sub_topic_id,
  //       'question_id': true_false_id,
  //     }),
  //   );
  //
  //   if (response.statusCode != 200) {
  //     throw Exception('Failed to delete phrase: ${response.body}');
  //   }
  // }

  //update complete the word

  Future<void> updateCompleteTheWordTableQuestionApi( CompleteWordData question,List<int>? qImage,) async {
    isLoading.value = true;

    try {
      var uri = Uri.parse(ApiString.update_complete_the_word);
      var request = http.MultipartRequest('POST', uri);

      // Add JSON fields
      request.fields['question_id'] = question.id.toString();
      request.fields['question_type'] = question.questionType;
      request.fields['question'] = question.question;
      request.fields['title'] = question.title;
      request.fields['option_a'] = question.optionA;
      request.fields['option_b'] = question.optionB;
      request.fields['option_c'] = question.optionC;
      request.fields['option_d'] = question.optionD;
      request.fields['answer'] = question.answer;
      request.fields['index'] = question.index.toString();
      request.fields['points'] = question.points.toString();

      // Add the image file if provided
      if (qImage != null && qImage.isNotEmpty) {
        request.files.add(
          http.MultipartFile.fromBytes(
            'image',
            qImage,
            filename: 'question_image.png',
            contentType: MediaType('image', 'png'),
          ),
        );
      }

      // Send the request
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        print('Question update successfully');
      } else {
        print('Failed to update question: ${response.body}');
      }
    } catch (e) {
      print('Error updating question: $e');
    } finally {
      isLoading.value = false;
    }
  }

  //delete complete the word
  deleteCompleteTheWordAPI({required String question_id,
  }) async {
    final response = await http.delete(
      Uri.parse(ApiString.delete_complete_the_word),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({

        'question_id': question_id,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete phrase: ${response.body}');
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

  // Update complete the paragraph
  updateCompleteTheParagraphTableQuestionApi(CompleteParaData  question) async {
    isLoading.value = true;
    try {
      final response = await http.post(
        Uri.parse(ApiString.update_complete_the_paragraph),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'question_id':question.id,
          'question_type':question.questionType,
          'question':question.question,
          'title': question.title,
          'paragraph_content':question.paragraphContent,
          'option_a': question.optionA,
          'option_b': question.optionB,
          'option_c': question.optionC,
          'option_d': question.optionD,
          'option_e': question.optionE,
          'option_f': question.optionF,
          'answer': question.answer,
          'index': question.index,
          'points': question.points,
        }),
      );

      if (response.statusCode == 200) {
print('question updated successfully');
      } else {
        print('Failed to update question: ${response.body}');
      }
    } catch (e) {
      print('Error updating question: $e');
    } finally {
      isLoading.value = false; // Set loading state to false
    }
  }

//delete paragraph
  deleteCompleteTheParagraphAPI({
    required String question_ids,
  }) async {
    print("question_ids {$question_ids}");
    if (question_ids.isEmpty) {
      print('Error: No question IDs provided');
      return;
    }

    final response = await http.delete(
      Uri.parse(ApiString.delete_complete_the_paragraph),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'question_id': question_ids,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete phrase: ${response.body}');
    }
  }


  /// update Mcq api

  Future<void> updateMcqQuestionAPI({
    required String mcq_id,
    required String mainCategoryId,
    required String subCategoryId,
    required String topicId,
    required String subTopicId,
    required String questionType,
    required String title,
    required String question,
    List<int>? qImage, // Image bytes
    required String optionA,
    required String optionB,
    required String optionC,
    required String optionD,
    required String answer,
    required String points,
    required String index,
  }) async {
    isLoading.value = true;
    try {
      var request = http.MultipartRequest('POST', Uri.parse(ApiString.update_mcq));

      // Add text fields
      request.fields.addAll({
        'mcq_id': mcq_id,
        'main_category_id': mainCategoryId,
        'sub_category_id': subCategoryId,
        'topic_id': topicId,
        'sub_topic_id': subTopicId,
        'question_type': questionType,
        'question': question,
        'title': title,
        'option_a': optionA,
        'option_b': optionB,
        'option_c': optionC,
        'option_d': optionD,
        'answer': answer,
        'index': index,
        'points': points,
      });

      // Add image file if available
      if (qImage != null) {
        request.files.add(
          http.MultipartFile.fromBytes(
            'q_image',
            qImage,
            filename: 'question_image.jpg',
            contentType: MediaType('image', 'jpeg'),
          ),
        );
        print('image  is uploaded');
      }

      // Send the request
      var response = await request.send();
      var responseBody = await response.stream.bytesToString();

      print('Response Code: ${response.statusCode}');
      print('Response Body: $responseBody');

      if (response.statusCode == 200) {
        // await getAllMCQS(
        //   main_category_id: mainCategoryId.toString(),
        //   sub_category_id: subCategoryId.toString(),
        //   topic_id: topicId.toString(),
        //   sub_topic_id: subTopicId.toString(),
        // );
      } else {
        print('Failed to update question: ${await response.stream.bytesToString()}');
      }
    } catch (e) {
      print('Error updating question: $e');
    } finally {
      isLoading.value = false;
    }
  }


  updateGuessTheImageApi({
    required String question_id,
    required String title,
    List<int>? qImage,
    required String optionA,
    required String optionB,
    required String optionC,
    required String optionD,
    required String answer,
    required String points,
    required String index,
  }) async {
    isLoading.value = true;
    var uri = Uri.parse(ApiString.update_guess_the_image);
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
      request.fields['question_id'] = question_id;
      request.fields['title'] = title;
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
          showSnackbar(message: "Question updated successfully");
        } else {
          showSnackbar(message: "Failed to updated question");
        }
      } else {
        showSnackbar(message: "Failed to update question: ${response.reasonPhrase}");
      }
    } catch (e) {
      showSnackbar(message: "Error while updating question: $e");
    } finally {
      isLoading.value = false;
    }
  }

  //Delete MCq

  deleteMCQAPI({ required String question_id,
  }) async {
    final response = await http.delete(
      Uri.parse(ApiString.delete_mcq),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'question_id': question_id,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete phrase: ${response.body}');
    }
  }

  deleteReArrangeSentence({ required String question_id,
  }) async {
    final response = await http.delete(
      Uri.parse(ApiString.delete_complete_sentence),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'question_id': question_id,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete phrase: ${response.body}');
    }
  }

  deleteGuessTheImageAPI({ required String question_ids,
  }) async {
    final response = await http.delete(
      Uri.parse(ApiString.delete_guess_the_image),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'question_id': question_ids,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete phrase: ${response.body}');
    }
  }

  deleteTrueOrFalseAPI({ required String question_ids,
  }) async {
    final response = await http.delete(
      Uri.parse(ApiString.delete_true_false),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'question_id': question_ids,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete phrase: ${response.body}');
    }
  }

}
