import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainCategoryController extends GetxController {
  var mainCategories = <Map<String, dynamic>>[].obs;

  // Edit a category
  void editCategory(int index, String newName) {
    mainCategories[index]['name'] = newName;
    update(); // to update UI after editing
  }

  // Remove a category
  void removeCategory(int index) {
    mainCategories[index]['controller']?.dispose();
    mainCategories.removeAt(index);
    update(); // to update UI after removal
  }
  // Remove items (subcategory, topic, or subtopic)
  void removeItem(int categoryIndex, String type, int itemIndex) {
    mainCategories[categoryIndex][type].removeAt(itemIndex);
    update();
  }

  // // Add a new category
  void addCategory(String categoryName) {
    mainCategories.add({
      'name': categoryName,
      'subCategories': <Map<String, dynamic>>[],  // Initialize subcategories as a list of maps
      'controller': TextEditingController(text: categoryName),
    });
  }

  void addItem(String type, String name, String? mainCategory, String? subCategory, String? topic) {
    int mainIndex = mainCategories.indexWhere((cat) => cat['name'] == mainCategory);
    if (mainIndex == -1) return;

    if (type == 'subCategory') {
      mainCategories[mainIndex]['subCategories'] ??= [];
      mainCategories[mainIndex]['subCategories'].add({'name': name});
    } else if (type == 'topic') {
      mainCategories[mainIndex]['topics'] ??= [];
      mainCategories[mainIndex]['topics'].add({'name': name});
    } else if (type == 'subTopic') {
      int subIndex = mainCategories[mainIndex]['topics']
          ?.indexWhere((topicItem) => topicItem['name'] == subCategory) ?? -1;
      if (subIndex == -1) return;

      mainCategories[mainIndex]['topics'][subIndex]['subTopics'] ??= [];
      mainCategories[mainIndex]['topics'][subIndex]['subTopics'].add({'name': name});
    }
    update();
  }

}

//
// // Add subcategory
// void addSubCategory(String category, String subCategory) {
//   var categoryData = mainCategories.firstWhere((categoryMap) => categoryMap['name'] == category);
//   categoryData['subCategories'].add({
//     'name': subCategory,
//     'topics': <String>[],  // Initialize topics as an empty list of strings
//   });
//   update();
// }
//
// // Add topic
// void addTopic(String category, String subCategory, String topic) {
//   var categoryIndex = mainCategories
//       .indexWhere((item) => item['name'] == category);
//   var subCategoryIndex = mainCategories[categoryIndex]['subCategories']
//       .indexWhere((item) => item['name'] == subCategory);
//
//   if (categoryIndex != -1 && subCategoryIndex != -1) {
//     mainCategories[categoryIndex]['subCategories'][subCategoryIndex]['topics']
//         .add(topic);
//     update(); // If you're using GetX, call update() here to update the UI.
//   }
// }
//
// // Add subtopic
// void addSubTopic(String category, String subCategory, String topic, String subTopic) {
//   var categoryData = mainCategories.firstWhere((categoryMap) => categoryMap['name'] == category);
//   var subCategoryData = categoryData['subCategories']
//       .firstWhere((subCategoryMap) => subCategoryMap['name'] == subCategory);
//   var topicData = subCategoryData['topics']
//       .firstWhere((topicMap) => topicMap == topic);
//   topicData.add(subTopic);
//   update();
// }
