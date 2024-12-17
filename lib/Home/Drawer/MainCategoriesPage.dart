import 'package:blissiqadmin/Global/constants/AppColor.dart';
import 'package:blissiqadmin/Home/Drawer/MyDrawer.dart';
import 'package:flutter/material.dart';

class MainCategoriesPage extends StatefulWidget {
  const MainCategoriesPage({super.key});

  @override
  State<MainCategoriesPage> createState() => _MainCategoriesPageState();
}

class _MainCategoriesPageState extends State<MainCategoriesPage> {
  String profileImage = "assets/icons/icon_white.png";

  List<Map<String, dynamic>> mainCategories = [];

  // Remove Main Category
  void _removeCategory(int index) {
    setState(() {
      mainCategories[index]['controller']?.dispose();
      mainCategories.removeAt(index);
    });
  }

  // Edit Main Category
  void _editCategory(int index) {
    TextEditingController categoryController =
    TextEditingController(text: mainCategories[index]['name']);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Main Category'),
          content: TextField(
            controller: categoryController,
            decoration: const InputDecoration(
              labelText: 'Main Category Name',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (categoryController.text.isNotEmpty) {
                  setState(() {
                    mainCategories[index]['name'] = categoryController.text;
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

  void _showSubCategories(int mainIndex) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Subcategories for ${mainCategories[mainIndex]['name']}'),
          content: SizedBox(
            width: 300,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: mainCategories[mainIndex]['subCategories'].length,
              itemBuilder: (context, subIndex) {
                return ListTile(
                  title: Text(mainCategories[mainIndex]['subCategories'][subIndex]),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      setState(() {
                        mainCategories[mainIndex]['subCategories']
                            .removeAt(subIndex);
                      });
                    },
                  ),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
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
          bool isWideScreen = constraints.maxWidth > 800;

          return Row(
            children: [
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
                    backgroundColor: Colors.blue.shade100,
                  ),
                  drawer: isWideScreen ? null : Drawer(child: MyDrawer()),
                  body: Padding(
                    padding: const EdgeInsets.all(16.0),
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
      children: [
        const Text("Add the Main Category:",
            style: TextStyle(
                fontSize: 18,
                color: Colors.black,
                fontWeight: FontWeight.bold)),
        Expanded(
          child: SingleChildScrollView(
            child: Table(
              border: TableBorder.all(color: Colors.grey),
              columnWidths: const {
                0: FlexColumnWidth(2),
                1: FlexColumnWidth(1),
                2: FlexColumnWidth(1),
                3: FlexColumnWidth(1),
                4: FlexColumnWidth(1),
                5: FlexColumnWidth(1),
              },
              children: [
                TableRow(
                  decoration: BoxDecoration(color: Colors.grey[300]),
                  children: [
                    // Main Category Header with Add Button
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          const Text(
                            'Main Category Name',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const Spacer(),
                          IconButton(
                            onPressed: _showAddCategoryDialog, // Existing function
                            icon: const Icon(Icons.add, color: Colors.black),
                            tooltip: 'Add Main Category',
                          ),
                        ],
                      ),
                    ),
                    // Subcategory Header with Add Button
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          const Text(
                            'Subcategory',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const Spacer(),
                          IconButton(
                            onPressed: () {
                              // Function to handle adding subcategory
                              print("Add Subcategory Pressed");
                            },
                            icon: const Icon(Icons.add, color: Colors.black),
                            tooltip: 'Add Subcategory',
                          ),
                        ],
                      ),
                    ),
                    // Topics Header with Add Button
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          const Text(
                            'Topics',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const Spacer(),
                          IconButton(
                            onPressed: () {
                              // Function to handle adding topics
                              print("Add Topics Pressed");
                            },
                            icon: const Icon(Icons.add, color: Colors.black),
                            tooltip: 'Add Topics',
                          ),
                        ],
                      ),
                    ),
                    // Subtopics Header with Add Button
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          const Text(
                            'Subtopics',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const Spacer(),
                          IconButton(
                            onPressed: () {
                              // Function to handle adding subtopics
                              print("Add Subtopics Pressed");
                            },
                            icon: const Icon(Icons.add, color: Colors.black),
                            tooltip: 'Add Subtopics',
                          ),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Edit',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Actions',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                ...mainCategories.map(
                      (category) {
                    int index = mainCategories.indexOf(category);
                    return TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(category['name'] ?? 'No Name',
                              style: const TextStyle(fontSize: 16)),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add, color: Colors.blue),
                          onPressed: () => _showSubCategories(index),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add, color: Colors.blue),
                          onPressed: () => _showSubCategories(index),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add, color: Colors.blue),
                          onPressed: () => _showSubCategories(index),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.black),
                          onPressed: () => _editCategory(index),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _removeCategory(index),
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
    TextEditingController categoryController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Main Category'),
          content: TextField(
            controller: categoryController,
            decoration: const InputDecoration(
              labelText: 'Main Category Name',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (categoryController.text.isNotEmpty) {
                  setState(() {
                    mainCategories.add({
                      'name': categoryController.text,
                      'subCategories': [],
                    });
                  });
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Add Main Category'),
            ),
          ],
        );
      },
    );
  }
}
