import 'dart:io';

import 'package:blissiqadmin/Global/constants/AppColor.dart';
import 'package:blissiqadmin/Home/Drawer/MyDrawer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SubCategoryPage extends StatefulWidget {
  const SubCategoryPage({super.key});

  @override
  State<SubCategoryPage> createState() => _SubCategoryPageState();
}

class _SubCategoryPageState extends State<SubCategoryPage> {

  String profileImage = "assets/icons/icon_white.png";
  List<Map<String, dynamic>> toddlerSubCategories = [];


  void _removeCategory(int index) {
    setState(() {
      toddlerSubCategories[index]['controller']?.dispose();
      toddlerSubCategories.removeAt(index);
    });
  }

  void _editCategory(int index) {
    // Show a dialog to edit the category
    TextEditingController categoryController =
    TextEditingController(text: toddlerSubCategories[index]['name']);

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
                    toddlerSubCategories[index]['name'] = value;
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (categoryController.text.isNotEmpty) {
                  setState(() {
                    toddlerSubCategories[index]['name'] = categoryController.text;
                  });
                  Navigator.of(context).pop();
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
                      ? null
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
              const Text("Add the Toddler Sub Category :- ",
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
              },
              children: [
                TableRow(
                  decoration: BoxDecoration(color: Colors.grey[300]),
                  children: const [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Sub Category Name',
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
                ...toddlerSubCategories.map(
                      (category) {
                    int index = toddlerSubCategories.indexOf(category);
                    return TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            category['name'] ??
                                'No Name',
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
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
                ),
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
          title: const Text('Add Sub Category'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: categoryController,
                decoration: const InputDecoration(
                  labelText: 'Sub Category Name',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (categoryController.text.isNotEmpty) {
                  setState(() {
                    toddlerSubCategories.add({
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
