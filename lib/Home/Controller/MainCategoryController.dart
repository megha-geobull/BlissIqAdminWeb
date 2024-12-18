import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainCategoryController extends GetxController {
  var mainCategories = <Map<String, dynamic>>[].obs;


  void addCategory(String categoryName) {
    mainCategories.add({
      'name': categoryName,
      'subCategories': <Map<String, dynamic>>[],
      'topics': <Map<String, dynamic>>[],
      'subTopics': <Map<String, dynamic>>[],
      'queType': <Map<String, dynamic>>[],
    });
    update();
  }

  // Add items (subcategory, topic, or subtopic)
  void addItem(String type, String name, String? mainCategory, String? subCategory, String? topic,) {
    int mainIndex = mainCategories.indexWhere((cat) => cat['name'] == mainCategory);
    if (mainIndex == -1) return;

    if (type == 'subCategory') {
      mainCategories[mainIndex]['subCategories'] ??= [];
      mainCategories[mainIndex]['subCategories'].add({'name': name});
    } else if (type == 'topic') {
      mainCategories[mainIndex]['topics'] ??= [];
      mainCategories[mainIndex]['topics'].add({'name': name, 'subTopics': <Map<String, dynamic>>[]});
    } else if (type == 'subTopic') {
      int topicIndex = mainCategories[mainIndex]['topics']
          ?.indexWhere((topicItem) => topicItem['name'] == topic) ?? -1;
      if (topicIndex == -1) return;

      mainCategories[mainIndex]['topics'][topicIndex]['subTopics'] ??= [];
      mainCategories[mainIndex]['topics'][topicIndex]['subTopics'].add({'name': name});
    }
    update();
  }

  // Remove items (subcategory, topic, or subtopic)
  void removeItem(int categoryIndex, String type, int itemIndex, {int? topicIndex}) {
    if (type == 'subCategory') {
      mainCategories[categoryIndex]['subCategories'].removeAt(itemIndex);
    } else if (type == 'topic') {
      mainCategories[categoryIndex]['topics'].removeAt(itemIndex);
    } else if (type == 'subTopic' && topicIndex != null) {
      mainCategories[categoryIndex]['topics'][topicIndex]['subTopics'].removeAt(itemIndex);
    }
    update();
  }
}



