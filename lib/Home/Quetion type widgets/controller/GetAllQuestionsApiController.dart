import 'dart:convert';
import 'dart:developer';
import 'package:blissiqadmin/Global/constants/ApiString.dart';
import 'package:blissiqadmin/Global/constants/common_snackbar.dart';
import 'package:blissiqadmin/Home/Quetion%20type%20widgets/model/GetCompleteParagraphModel.dart';
import 'package:blissiqadmin/Home/Quetion%20type%20widgets/model/GetCompleteWordModel.dart';
import 'package:blissiqadmin/Home/Quetion%20type%20widgets/model/LearningSlideModel.dart';
import 'package:blissiqadmin/Home/Quetion%20type%20widgets/model/get_fill_in_the_blanks.dart';
import 'package:blissiqadmin/Home/Quetion%20type%20widgets/model/get_match_the_pairs.dart';
import 'package:blissiqadmin/Home/Quetion%20type%20widgets/model/get_rearrange_model.dart';
import 'package:blissiqadmin/Home/Quetion%20type%20widgets/model/get_story_model.dart';
import 'package:blissiqadmin/Home/Quetion%20type%20widgets/model/get_story_phrases_model.dart';
import 'package:blissiqadmin/Home/Quetion%20type%20widgets/model/get_trueOrfalse_model.dart';
import 'package:blissiqadmin/Home/Quetion%20type%20widgets/model/guess_the_image.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:blissiqadmin/Home/Quetion%20type%20widgets/model/get_mcqs.dart';

class GetAllQuestionsApiController extends GetxController{
  RxBool isLoading = false.obs;

  RxList<Mcqs> getMcqslits = <Mcqs>[].obs;
  RxList<ReArrange> getReArrangeList = <ReArrange>[].obs;
  RxList<TrueOrFalse> getTrueOrFalseList = <TrueOrFalse>[].obs;
  RxList<FillInTheBlanks> getFillInTheBlanksList = <FillInTheBlanks>[].obs;
  RxList<StoryData> getStoryDataList = <StoryData>[].obs;
  RxList<GuessTheImageData> guessTheImageList = <GuessTheImageData>[].obs;

  RxList<StoryPhrases> getStoryPhrasesList = <StoryPhrases>[].obs;
  RxList<PhrasesData> getConversationList = <PhrasesData>[].obs;
  RxList<MatchPairs> getMatchPairsList = <MatchPairs>[].obs;


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
    String? sub_topic_id}) async {
    isLoading.value = true;
    getCompleteParaData.clear();
    print("Hi Hellow");
    try {
      var body = {
        'main_category_id':main_category_id,
        'sub_category_id':sub_category_id,
        'topic_id':topic_id,
        'sub_topic_id':sub_topic_id??''
      };
      print(main_category_id);
      print(sub_category_id);
      print(topic_id);
      print(sub_topic_id);


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
              .map((mcqJson) => PhrasesData.fromJson(mcqJson))
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
        //body:jsonEncode(body),
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



  //Update Story Phrases
  updateStoryPhrasesTableQuestionApi(StoryPhrases question) async {
    isLoading.value = true;
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
          'phrase_name': question.phraseName,
          'index': question.index,
          'points': question.points,
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
      isLoading.value = false; // Set loading state to false
    }
  }




  //delete story phrases
  deleteStoryPhraseAPI({
    required String main_category_id,
    required String sub_category_id,
    required String topic_id,
    required String sub_topic_id,
    //required String true_false_id,
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
        'phrase_ids': phrase_ids,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete phrase: ${response.body}');
    }
  }

  // Update Rearrange thw word
  updateRearrangeTheWordTableQuestionApi(ReArrange question) async {
    isLoading.value = true;
    try {
      final response = await http.post(
        Uri.parse(ApiString.update_rearrange),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'rearrange_id':question.id,
          'main_category_id':question.mainCategoryId,
          'sub_category_id':question.subCategoryId,
          'topic_id': question.topicId,
          'sub_topic_id':question.subTopicId,
          'question_type': question.questionType,
          'title': question.title,
          'question':question.question,
          'q_image':question.qImage,
          'answer':question.answer,
          'index':question.index,
          'points': question.points,
        }),
      );

      if (response.statusCode == 200) {
        await getAllRe_Arrange(main_category_id: question.mainCategoryId.toString(), sub_category_id: question.subCategoryId.toString(),
            topic_id: question.topicId.toString(), sub_topic_id: question.subTopicId.toString()
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

  updateFillInTheBlanksTableQuestionApi(FillInTheBlanks question) async {
    isLoading.value = true;
    try {
      final response = await http.post(
        Uri.parse(ApiString.update_fill_blanks),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'fill_blank_id':question.id,
          'main_category_id':question.mainCategoryId,
          'sub_category_id':question.subCategoryId,
          'topic_id': question.topicId,
          'sub_topic_id':question.subTopicId,
          'question_type': question.questionType,
          'title': question.title,
          'question_language': question.questionLanguage,
          'question': question.question,
          'q_image': question.qImage,
          'option_language': question.optionLanguage,
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
        await getStoryPhrases(main_category_id: question.mainCategoryId.toString(), sub_category_id: question.subCategoryId.toString(),
            topic_id: question.topicId.toString(), sub_topic_id: question.subTopicId.toString()
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

  updateTrueFalseTableQuestionApi(TrueOrFalse question) async {
    isLoading.value = true;
    try {
      final response = await http.post(
        Uri.parse(ApiString.update_true_false),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'true_false_id':question.id,
          'main_category_id':question.mainCategoryId,
          'sub_category_id':question.subCategoryId,
          'topic_id': question.topicId,
          'sub_topic_id':question.subTopicId,
          'question_type': question.questionType,
          'question': question.question,
          'q_image': question.qImage,
          'answer': question.answer,
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
      isLoading.value = false; // Set loading state to false
    }
  }


  //delete true false

  deleteTrueFalseAPI({
    required String main_category_id,
    required String sub_category_id,
    required String topic_id,
    required String sub_topic_id,
    required String true_false_id,
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
        'question_id': true_false_id,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete phrase: ${response.body}');
    }
  }

  //update complete the word
  updateCompleteTheWordTableQuestionApi(CompleteWordData question) async {
    isLoading.value = true;
    try {
      final response = await http.post(
        Uri.parse(ApiString.update_complete_the_word),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'question_id':question.id,
          'question_type':question.questionType,
          'question':question.question,
          'title': question.title,
          'option_a':question.optionA,
          'option_b': question.optionB,
          'option_c': question.optionC,
          'option_d': question.optionD,
          'answer': question.answer,
          'index': question.index,
          'points': question.points,
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
      isLoading.value = false; // Set loading state to false
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
          'option_a': question.optionB,
          'option_b': question.optionB,
          'option_c': question.optionC,
          'option_d': question.optionD,
          'option_e': question.optionB,
          'option_f': question.optionB,
          'answer': question.answer,
          'index': question.index,
          'points': question.points,
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
      isLoading.value = false; // Set loading state to false
    }
  }

//delete paragraph
  deleteCompleteTheParagraphAPI({
    required String question_id,
  }) async {
    final response = await http.delete(
      Uri.parse(ApiString.delete_complete_the_paragraph),
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

  updateGuessTheImageApi(GuessTheImageData question) async {
    isLoading.value = true;
    try {
      print(question.topicId);
      final response = await http.post(
        Uri.parse(ApiString.update_guess_the_image),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'question_id': question.id,
          'main_category_id': question.mainCategoryId,
          'sub_category_id': question.subCategoryId,
          'topic_id': question.topicId,
          'sub_topic_id': question.subTopicId,
          'question_type': question.questionType,
          'title': question.title,
          'option_a': question.optionA,
          'option_b': question.optionB,
          'option_c': question.optionC,
          'option_d': question.optionD,
          'answer': question.answer,
          'q_image': question.qImage,
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

}
