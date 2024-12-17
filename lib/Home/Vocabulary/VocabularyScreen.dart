import 'dart:io';

import 'package:blissiqadmin/Global/constants/AppColor.dart';
import 'package:blissiqadmin/Global/constants/CommonSizedBox.dart';
import 'package:blissiqadmin/Global/constants/CustomTextField.dart';
import 'package:blissiqadmin/Home/Conversational/ConversationalScreen.dart';
import 'package:blissiqadmin/Home/Drawer/MyDrawer.dart';
import 'package:blissiqadmin/Home/Grammer/GrammarScreen.dart';
import 'package:blissiqadmin/Home/HomePage.dart';
import 'package:blissiqadmin/Home/Toddler/ToddlerEnglishScreen.dart';
import 'package:blissiqadmin/Home/Vocabulary/VocabularyScreen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:get/get.dart' as getx;
import 'package:image_picker/image_picker.dart';

class VocabularyScreen extends StatefulWidget {
  @override
  _VocabularyScreenState createState() => _VocabularyScreenState();
}

class _VocabularyScreenState extends State<VocabularyScreen> {
  String profileImage = "assets/icons/icon_white.png";
  List<Map<String, dynamic>> vocabularyCategories = [];

  _pickImage(int index) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        vocabularyCategories[index]['image'] = kIsWeb
            ? pickedFile.path // Use the path for web as a URL.
            : File(pickedFile.path);
      });
    }
  }

  void _addCategory() {
    setState(() {
      vocabularyCategories.add({
        'name': '',
        'image': null,
        'controller': TextEditingController(),
      });
    });
  }

  void _removeCategory(int index) {
    setState(() {
      vocabularyCategories[index]['controller']?.dispose();
      vocabularyCategories.removeAt(index);
    });
  }

  void _editCategory(int index) {
    // Show a dialog to edit the category
    TextEditingController categoryController =
        TextEditingController(text: vocabularyCategories[index]['name']);
    String? categoryImage = vocabularyCategories[index]['image'];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Vocabulary Category'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: categoryController,
                decoration: const InputDecoration(
                  labelText: 'Category Name',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    vocabularyCategories[index]['name'] = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: () async {
                  final pickedFile = await ImagePicker()
                      .pickImage(source: ImageSource.gallery);
                  if (pickedFile != null) {
                    setState(() {
                      categoryImage = pickedFile.path;
                      vocabularyCategories[index]['image'] = categoryImage;
                    });
                  }
                },
                child: Container(
                  height: 50,
                  color: Colors.grey[200],
                  child: categoryImage != null
                      ? kIsWeb
                          ? Image.network(
                              categoryImage!,
                              fit: BoxFit.cover,
                            )
                          : Image.file(
                              File(categoryImage!),
                              fit: BoxFit.cover,
                            )
                      : const Icon(Icons.image, color: Colors.grey),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // Update the vocabulary category with the new data
                if (categoryController.text.isNotEmpty) {
                  setState(() {
                    vocabularyCategories[index]['name'] =
                        categoryController.text;
                    vocabularyCategories[index]['image'] = categoryImage;
                  });
                  Navigator.of(context).pop(); // Close the dialog
                }
              },
              child: const Text('Save Changes'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Check screen size for responsiveness
          bool isWideScreen = constraints.maxWidth > 800;

          return Row(
            children: [
              // Always visible drawer for wide screens
              if (isWideScreen)
                Container(
                  width: 250,
                  color: Colors.orange.shade100,
                  child: MyDrawer(),
                ),
              Expanded(
                child: Scaffold(
                  appBar: isWideScreen
                      ? null // Remove AppBar if the drawer is always visible
                      : AppBar(
                          title: const Text('Dashboard'),
                          scrolledUnderElevation: 0,
                          backgroundColor: Colors.blue.shade100,
                          actions: [
                            IconButton(
                              icon: const Icon(
                                Icons.person,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                // Handle notifications
                              },
                            ),
                          ],
                        ),
                  drawer: isWideScreen
                      ? null
                      : Drawer(
                          child: MyDrawer()),
                  body: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 16),
                    child: _buildMainContent(constraints),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMainContent(BoxConstraints constraints) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Row(
            children: [
              const Text("Add the Vocabulary Category :- ",
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold)),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: _showAddCategoryDialog,
                icon: const Icon(Icons.add, color: AppColor.red),
                label: const Text(
                  "Add",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Table(
              border: TableBorder.all(color: Colors.grey),
              columnWidths: const {
                0: FlexColumnWidth(2), // Category Name
                1: FlexColumnWidth(2), // Image
                2: FlexColumnWidth(1), // Remove button
                3: FlexColumnWidth(1), // Actions button
              },
              children: [
                TableRow(
                  decoration: BoxDecoration(color: Colors.grey[300]),
                  children: const [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Category Name',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Category Image',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Edit',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Actions',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                ...vocabularyCategories.map(
                  (category) {
                    int index = vocabularyCategories.indexOf(category);
                    return TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            category['name'] ??
                                'No Name', // Display the category name or fallback to 'No Name' if null
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () => _pickImage(index),
                            child: Container(
                              height: 50,
                              color: Colors.grey[200],
                              child: category['image'] != null
                                  ? kIsWeb
                                      ? Image.network(
                                          category['image'],
                                          fit: BoxFit.cover,
                                        )
                                      : Image.file(
                                          File(category['image']),
                                          fit: BoxFit.cover,
                                        )
                                  : const Icon(Icons.image, color: Colors.grey),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: IconButton(
                            icon: const Icon(Icons.edit, color: Colors.black),
                            onPressed: () => _editCategory(index),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _removeCategory(index),
                          ),
                        ),
                      ],
                    );
                  },
                ).toList(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showAddCategoryDialog() {
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController categoryController = TextEditingController();
        String? categoryImage;

        return AlertDialog(
          title: const Text('Add Vocabulary Category'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: categoryController,
                decoration: const InputDecoration(
                  labelText: 'Category Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: () async {
                  final pickedFile = await ImagePicker()
                      .pickImage(source: ImageSource.gallery);
                  if (pickedFile != null) {
                    setState(() {
                      categoryImage = pickedFile.path;
                    });
                  }
                },
                child: Container(
                  height: 50,
                  color: Colors.grey[200],
                  child: categoryImage != null
                      ? Image.file(
                          File(categoryImage!),
                          fit: BoxFit.cover,
                        )
                      : const Icon(Icons.image, color: Colors.grey),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (categoryController.text.isNotEmpty) {
                  setState(() {
                    vocabularyCategories.add({
                      'name': categoryController.text,
                      'image': categoryImage,
                      'controller': categoryController,
                    });
                  });
                  Navigator.of(context).pop(); // Close the dialog
                }
              },
              child: const Text('Add Category'),
            ),
          ],
        );
      },
    );
  }
}
