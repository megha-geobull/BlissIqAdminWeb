import 'dart:developer';
import 'package:csv/csv.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../Global/Widgets/ExampleModel.dart';
import '../Global/constants/ApiString.dart';
import '../Global/constants/common_snackbar.dart';
import '../Global/utils/shared_preference/shared_preference_services.dart';
import 'dart:html' as html;

import '../Home/Quetion type widgets/model/AllDataModel.dart';

class CategoryController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool issubTopicLoading = false.obs;
  RxList categories = [].obs;
  RxList sub_categories = [].obs;
  RxList topics = [].obs;
  RxList sub_topics = [].obs;
  List<AllDatas> learningPath = [];
  RxList<ImageWithText> tempList = <ImageWithText>[].obs;
  var subtopicsMap = <String, List<dynamic>>{}.obs;

  addCategory({
    required String categoryname,
  }) async {
    isLoading.value = true;

    try {
      final Map<String, dynamic> body = {
        "category_name": categoryname,
      };

      final response = await http.post(
        Uri.parse(ApiString.add_main_category),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        if (responseData['status'] == 1) {
          getCategory();
          showSnackbar(message: "Category added successfully");
        } else {
          showSnackbar(message: "Failed to add category");
        }
      }
    } catch (e) {
      showSnackbar(message: "Error while add $e");
    } finally {
      isLoading.value = false;
    }
  }

  deleteCategory({
    required String categoryId,
  }) async {
    isLoading.value = true;

    try {
      final Map<String, dynamic> body = {
        "main_category_id": categoryId,
      };

      final response = await http.delete(
        Uri.parse(ApiString.delete_main_category),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        if (responseData['status'] == 1) {
          getCategory();
          showSnackbar(message: "Category deleted successfully");
        } else {
          showSnackbar(message: "Failed to delete category");
        }
      }
    } catch (e) {
      showSnackbar(message: "Error while delete $e");
    } finally {
      isLoading.value = false;
    }
  }

  getCategory() async {
    isLoading.value = true;
    categories.clear();
    try {

      final response = await http.get(
        Uri.parse(ApiString.get_main_category),
        headers: {"Content-Type": "application/json"},
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        if (responseData['status'] == 1) {
          categories.value = responseData["data"];
        } else {
          showSnackbar(message: "Failed to fetch category");
        }
      }
    } catch (e) {
      showSnackbar(message: "Error while fetch category $e");
      log(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  addSubCategory({
    required String subcategory,
    required String maincategory_id,
  }) async {
    isLoading.value = true;

    try {
      final Map<String, dynamic> body = {
        "main_category_id": maincategory_id,
        "sub_category": subcategory,
      };

      final response = await http.post(
        Uri.parse(ApiString.add_sub_category),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        if (responseData['status'] == 1) {
          showSnackbar(message: "Subcategory added successfully");
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

  deleteSubCategory({
    required String categoryId,
    required String sub_categoryId,
  }) async {
    isLoading.value = true;

    try {
      final Map<String, dynamic> body = {
        "main_category_id": categoryId,
        "sub_category_id": sub_categoryId,
      };

      final response = await http.delete(
        Uri.parse(ApiString.delete_sub_category),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        if (responseData['status'] == 1) {
          getSubCategory(categoryId: categoryId);
          showSnackbar(message: "Subcategory deleted successfully");
        } else {
          showSnackbar(message: "Failed to delete Subcategory");
        }
      }
    } catch (e) {
      showSnackbar(message: "Error while delete $e");
    } finally {
      isLoading.value = false;
    }
  }

  getSubCategory({
    required String categoryId,
  }) async {
    isLoading.value = true;
    sub_categories.clear();
    try {
      final Map<String, dynamic> body = {
        "main_category_id": categoryId,
      };
      final response = await http.post(
        Uri.parse(ApiString.get_sub_category),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        if (responseData['status'] == 1) {
          sub_categories.value = responseData["data"];
        } else {
          showSnackbar(message: "Failed to fetch category");
        }
      }
    } catch (e) {
      showSnackbar(message: "Error while delete $e");
    } finally {
      isLoading.value = false;
    }
  }

  addTopic({
    required String topic_name,
    required String maincategory_id,
    required String sub_categoryId,
    required RxList<ImageWithText> examples
  }) async {
    isLoading.value = true;
    var uri =Uri.parse(ApiString.add_topics);
    try {

      var request = http.MultipartRequest("POST", uri);
      //for (int index = 0; index < examples.length; index++) {
      if(examples.isNotEmpty) {
        try {
          // request.files.add(
          //   http.MultipartFile(
          //     'image',
          //     examples[0].file.readAsBytes().asStream(),
          //     await examples[0].file.length(),
          //     filename: examples[0].file.path
          //         .split('/')
          //         .last,),);
          request.files.add(
            http.MultipartFile.fromBytes(
              'image',
              examples[0].bytes,
              //contentType: MediaType('application', 'x-tar'),
              filename: examples[0].imageName,
            ),
          );
          print(examples[0].imageName);
        }
        catch (exception) {
          request.fields["image"] = '';
        }
        //}
        //for (int index = 0; index < examples.length; index++) {
        request.fields['exg_name'] = examples[0].name;
        print(request.fields['exg_name[]']);
      }
      //}
      request.fields["topic_name"] = topic_name;
      request.fields["main_category_id"] = maincategory_id;
      request.fields["sub_category_id"] = sub_categoryId;
      //request.fields["exg_name[]"] = examples;
      http.Response response = await http.Response.fromStream(await request.send());

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 201) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        if (responseData['status'] == 1) {
          get_topic(categoryId: maincategory_id,sub_categoryId: sub_categoryId);
          showSnackbar(message: "Topic added successfully");
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

  deleteTopic({
    required String categoryId,
    required String sub_categoryId,
    required String topicId,
  }) async {
    isLoading.value = true;

    try {
      final Map<String, dynamic> body = {
        "main_category_id": categoryId,
        "sub_category_id": sub_categoryId,
        "topic_id": topicId,
      };

      final response = await http.delete(
        Uri.parse(ApiString.delete_topic),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        if (responseData['status'] == 1) {
          showSnackbar(message: "Topic deleted successfully");
        } else {
          showSnackbar(message: "Failed to delete Topic");
        }
      }
    } catch (e) {
      showSnackbar(message: "Error while delete $e");
    } finally {
      isLoading.value = false;
    }
  }

  get_topic({
    required String categoryId,
    required String sub_categoryId,
  }) async {
    isLoading.value = true;
    topics.clear();
    try {
      final Map<String, dynamic> body = {
        "main_category_id": categoryId,
        "sub_category_id": sub_categoryId,
      };
      final response = await http.post(
        Uri.parse(ApiString.get_topics),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        if (responseData['status'] == 1) {
          topics.value = responseData["data"];
          isLoading.value = false;
        } else {
          showSnackbar(message: "Failed to fetch topic");
        }
      }
    } catch (e) {
      showSnackbar(message: "Error while fetch $e");
    } finally {
      isLoading.value = false;
    }
  }

  addSubTopic({
    required String subtopic_name,
    required String maincategory_id,
    required String sub_categoryId,
    required String topicId,
  }) async {
    isLoading.value = true;

    try {
      final Map<String, dynamic> body = {
        "main_category_id": maincategory_id,
        "sub_category_id": sub_categoryId,
        "topic_id": topicId,
        "sub_topic_name": subtopic_name,
      };

      final response = await http.post(
        Uri.parse(ApiString.add_subtopics),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );
      print(ApiString.add_subtopics);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 201) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        if (responseData['status'] == 1) {
          showSnackbar(message: "Subtopic added successfully");
          get_SubTopic(categoryId: maincategory_id, sub_categoryId: sub_categoryId, topicId: topicId);
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

  get_SubTopic({
    required String categoryId,
    required String sub_categoryId,
    required String topicId,
  }) async {
    issubTopicLoading.value = true;
    sub_topics.clear();
    try {
      final Map<String, dynamic> body = {
        "main_category_id": categoryId,
        "sub_category_id": sub_categoryId,
        "topic_id": topicId,
      };
      final response = await http.post(
        Uri.parse(ApiString.get_subtopics),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        if (responseData['status'] == 1) {
          sub_topics.value = responseData["data"];
          subtopicsMap[topicId] = sub_topics.value;
        } else {
          showSnackbar(message: "Failed to fetch subtopic");
        }
      }else
      if (response.statusCode == 204) {
        //showSnackbar(message: "No subtopics available");
      }
    } catch (e) {
      showSnackbar(message: "Error while fetch $e");
    } finally {
      issubTopicLoading.value = false;
    }
  }

  deleteSub_Topic({
    required String categoryId,
    required String sub_categoryId,
    required String topicId,
    required String sub_topicId,
    }) async {
    isLoading.value = true;

    try {
      final Map<String, dynamic> body = {
        "main_category_id": categoryId,
        "sub_category_id": sub_categoryId,
        "topic_id": topicId,
        "sub_topic_id": sub_topicId,
      };

      final response = await http.delete(
        Uri.parse(ApiString.delete_subtopics),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );
      print(body.toString());
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        if (responseData['status'] == 1) {
          showSnackbar(message: "SubTopic deleted successfully");
        } else {
          showSnackbar(message: "Failed to delete SubTopic");
        }
      }
    } catch (e) {
      showSnackbar(message: "Error while delete $e");
    } finally {
      isLoading.value = false;
    }
  }

  getUserId() async {
    return await getDataFromLocalStorage(
      dataType: "STRING",
      prefKey: "user_id",
    ) as String?;
  }

  getlearningPath() async {
    isLoading.value = true;
    learningPath.clear();
    String? fetchedUserId = await getUserId();
    try {
      final Map<String, dynamic> body = {
        "user_id": fetchedUserId,
      };
      final response = await http.post(
        Uri.parse(ApiString.get_my_learning_path),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      print('Response status: ${response.statusCode}');
      //print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        if (responseData['status'] == 1) {
          learningPath = (responseData["data"] as List<dynamic>)
              .map((item) => AllDatas.fromJson(item))
              .toList();
          exportToCSV(learningPath);
        } else {
          //showSnackbar(message: "Failed to fetch category");
        }
      }
    } catch (e) {
      showSnackbar(message: "Error while fetch learning path $e");
      log(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void exportToCSV(List<AllDatas> dataList) async {
    print("inside csv generate");
    List<List<String>> csvData = [
      [
        "Category ID",
        "Category Name",
        "Subcategory ID",
        "Subcategory Name",
        "Topic ID",
        "Topic Name",
        "Subtopic ID",
        "Subtopic Name"
      ]
    ];

    // Recursively process JSON data
    void processCategory(AllDatas category) {
      final categoryId = category.id;
      final categoryName = category.categoryName;
      final subCategories = category.subCategories ?? [];

      for (final subCategory in subCategories) {
        final subCategoryId = subCategory.id;
        final subCategoryName = subCategory.subCategory;
        final topics = subCategory.topics ?? [];

        for (final topic in topics) {
          final topicId = topic.id;
          final topicName = topic.topicName;
          final subTopics = topic.subTopics ?? [];

          if (subTopics.isEmpty) {
            // No subtopics, add row for topic only
            csvData.add([
              categoryId,
              categoryName,
              subCategoryId,
              subCategoryName,
              topicId,
              topicName,
              "",
              ""
            ]);
          } else {
            // Add rows for each subtopic
            for (final subTopic in subTopics) {
              final subTopicId = subTopic.id;
              final subTopicName = subTopic.subTopicName;
              csvData.add([
                categoryId,
                categoryName,
                subCategoryId,
                subCategoryName,
                topicId,
                topicName,
                subTopicId,
                subTopicName
              ]);
            }
          }
        }
      }
    }

    // Process all categories
    for (final category in dataList) {
      print("First category"+categories.toString());
      processCategory(category);
    }

    // Convert to CSV format
    final csvConverter = const ListToCsvConverter();
    final csvString = csvConverter.convert(csvData);
    if (kIsWeb) {
      log("Website file save");
      final bytes = utf8.encode(csvString);
      final blob = html.Blob([bytes]);
      final url = html.Url.createObjectUrlFromBlob(blob);

      final anchor = html.AnchorElement()
        ..href = url
        ..style.display = 'none'
        ..download = 'All_ID_data.csv';

      html.document.body!.children.add(anchor);
      anchor.click();
      html.document.body!.children.remove(anchor);

      html.Url.revokeObjectUrl(url);
    }
    // Save CSV file
    // final directory = await getTemporaryDirectory();
    // final filePath = "${directory.path}/CategoryData.csv";
    // final file = File(filePath)..writeAsStringSync(csvString);

    //print("CSV file saved at: $filePath");
  }

}