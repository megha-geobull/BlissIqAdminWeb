import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../Global/constants/ApiString.dart';
import '../Global/constants/common_snackbar.dart';

class CategoryController extends GetxController {
  RxBool isLoading = false.obs;
  RxList categories = [].obs;
  RxList sub_categories = [].obs;

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

      final response = await http.post(
        Uri.parse(ApiString.delete_main_category),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        if (responseData['status'] == 1) {
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

    try {

      final response = await http.get(
        Uri.parse(ApiString.get_main_category),
        headers: {"Content-Type": "application/json"},
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        if (responseData['status'] == 1) {
          categories.value = responseData['body']["data"];
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

      final response = await http.post(
        Uri.parse(ApiString.delete_sub_category),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        if (responseData['status'] == 1) {
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
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        if (responseData['status'] == 1) {
          sub_categories.value = responseData['body']["data"];
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
    //required List<File> images,
  }) async {
    isLoading.value = true;

    try {
      final Map<String, dynamic> body = {
        "topic_name": maincategory_id,
        "main_category_id": maincategory_id,
        "sub_category_id": sub_categoryId,
        //"image[]":image
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

      final response = await http.post(
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
  }) async {
    isLoading.value = true;

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
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        if (responseData['status'] == 1) {
          sub_categories.value = responseData['body']["data"];
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

}