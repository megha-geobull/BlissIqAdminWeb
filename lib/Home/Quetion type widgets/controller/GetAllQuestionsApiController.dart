import 'dart:convert';
import 'dart:developer';
import 'package:blissiqadmin/Global/constants/ApiString.dart';
import 'package:blissiqadmin/Global/constants/common_snackbar.dart';
import 'package:blissiqadmin/Home/Quetion%20type%20widgets/model/get_fill_in_the_blanks.dart';
import 'package:blissiqadmin/Home/Quetion%20type%20widgets/model/get_rearrange_model.dart';
import 'package:blissiqadmin/Home/Quetion%20type%20widgets/model/get_story_model.dart';
import 'package:blissiqadmin/Home/Quetion%20type%20widgets/model/get_trueOrfalse_model.dart';
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
  RxList<PhrasesData> getStoryPhrasesList = <PhrasesData>[].obs;
  RxList<PhrasesData> getConversationList = <PhrasesData>[].obs;

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

   getStoryDataBlanks({
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
    String? sub_topic_id}) async {
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
              .map((mcqJson) => PhrasesData.fromJson(mcqJson))
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


}