import 'package:blissiqadmin/Global/constants/AppColor.dart';
import 'package:blissiqadmin/Home/Controller/MainCategoryController.dart';
import 'package:blissiqadmin/Home/Drawer/MyDrawer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainCategoriesPage extends StatefulWidget {
  const MainCategoriesPage({super.key});

  @override
  State<MainCategoriesPage> createState() => _MainCategoriesPageState();
}

class _MainCategoriesPageState extends State<MainCategoriesPage> {
  final MainCategoryController _controller = Get.put(MainCategoryController());

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
              labelText: 'Category Name',
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
                  _controller.addCategory(categoryController.text);
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Add Category'),
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
        const Text(
          "Add the Main Category:",
          style: TextStyle(
              fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Obx(() {
              return Table(
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
                    decoration: BoxDecoration(color: Colors.orange[100]),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            const Text(
                              'Main Category Name',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                            const Spacer(),
                            IconButton(
                              onPressed: _showAddCategoryDialog,
                              icon: CircleAvatar(
                                radius: 10,
                                backgroundColor: Colors.deepOrange.shade200,
                                child: const Icon(
                                  Icons.add,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                              tooltip: 'Add Main Category',
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            const Text(
                              'Subcategory',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                            const Spacer(),
                            IconButton(
                              onPressed: () => _showAddDialog(context,'subCategory', 0),
                              icon: CircleAvatar(
                                radius: 10,
                                backgroundColor: Colors.deepOrange.shade200,
                                child: const Icon(
                                  Icons.add,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                              tooltip: 'Add Subcategory',
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            const Text(
                              'Topics',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                            const Spacer(),
                            IconButton(
                              onPressed: () => _showAddDialog(context,'topic', 0),
                              icon: CircleAvatar(
                                radius: 10,
                                backgroundColor: Colors.deepOrange.shade200,
                                child: const Icon(
                                  Icons.add,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                              tooltip: 'Add Topics',
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            const Text(
                              'Subtopics',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                            const Spacer(),
                            IconButton(
                              onPressed: () => _showAddDialog(context,'subTopic', 0),
                              icon: CircleAvatar(
                                radius: 10,
                                backgroundColor: Colors.deepOrange.shade200,
                                child: const Icon(
                                  Icons.add,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                              padding: const EdgeInsets.all(0),
                              tooltip: 'Add Subtopics',
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Row(
                            children: [
                              const Text('Question Type',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black)),
                              const Spacer(),
                              IconButton(
                                onPressed: () => _showAddDialog(context,'queType', 0),
                                icon:  CircleAvatar(
                                  radius: 10,
                                  backgroundColor: Colors.deepOrange.shade200,
                                  child: const Icon(
                                    Icons.add,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                                padding: const EdgeInsets.all(0),
                                tooltip: 'Add Question Type',
                              ),
                            ],
                          ),
                        ),
                      ),
                      // const Padding(
                      //   padding: EdgeInsets.all(8.0),
                      //   child: Center(
                      //     child: Text('Actions',
                      //         style: TextStyle(
                      //             fontWeight: FontWeight.bold,
                      //             color: Colors.black)),
                      //   ),
                      // ),
                    ],
                  ),
                  ..._controller.mainCategories.map(
                    (category) {
                      int index = _controller.mainCategories.indexOf(category);
                      return TableRow(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(category['name'] ?? 'No Name',
                                style: const TextStyle(fontSize: 16)),
                          ),
                          TextButton(
                            child: const Text("View",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)),
                            onPressed: () => _showItems(context,index, 'subCategories'),
                          ),
                          TextButton(
                            child: const Text("View",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)),
                            onPressed: () => _showItems(context,index, 'topics'),
                          ),
                          TextButton(
                            child: const Text(
                              "View",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            onPressed: () => _showItems(context,index, 'subTopics'),
                          ),
                          TextButton(
                            child: const Text(
                              "View",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            onPressed: () => _showItems(context,index, 'QueType'),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }


  void _showAddDialog(BuildContext context, String type, int? categoryIndex) {
    TextEditingController controller = TextEditingController();
    String? selectedCategory;
    String? selectedSubCategory;
    String? selectedTopic;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Add $type'),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (type != 'category') ...[
                      const Text('Main Category:'),
                      DropdownButton<String>(
                        hint: const Text('Choose Main Category'),
                        value: selectedCategory,
                        onChanged: (newValue) {
                          setState(() {
                            selectedCategory = newValue;
                            selectedSubCategory = null;
                            selectedTopic = null;
                          });
                        },
                        items: _controller.mainCategories
                            .map((category) => DropdownMenuItem<String>(
                          value: category['name'],
                          child: Text(category['name']),
                        ))
                            .toList(),
                      ),
                    ],
                    if (type == 'topic' || type == 'subTopic') ...[
                      const Text('Subcategory:'),
                      DropdownButton<String>(
                        hint: const Text('Choose Subcategory'),
                        value: selectedSubCategory,
                        onChanged: (newValue) {
                          setState(() {
                            selectedSubCategory = newValue;
                            selectedTopic = null;
                          });
                        },
                        items: _controller.mainCategories
                            .firstWhere(
                              (category) => category['name'] == selectedCategory,
                          orElse: () => {},
                        )['subCategories']
                            ?.map<DropdownMenuItem<String>>(
                              (subCategory) => DropdownMenuItem<String>(
                            value: subCategory['name'],
                            child: Text(subCategory['name']),
                          ),
                        )
                            ?.toList() ??
                            [],
                      ),
                    ],
                    if (type == 'subTopic') ...[
                      const Text('Topic:'),
                      DropdownButton<String>(
                        hint: const Text('Choose Topic'),
                        value: selectedTopic,
                        onChanged: (newValue) {
                          setState(() {
                            selectedTopic = newValue;
                          });
                        },
                        items: _controller.mainCategories
                            .firstWhere(
                              (category) => category['name'] == selectedCategory,
                          orElse: () => {},
                        )['topics']
                            ?.map<DropdownMenuItem<String>>(
                              (topic) => DropdownMenuItem<String>(
                            value: topic['name'],
                            child: Text(topic['name']),
                          ),
                        )
                            ?.toList() ??
                            [],
                      ),
                    ],
                    TextField(
                      controller: controller,
                      decoration: InputDecoration(
                        labelText: 'Enter ${type.capitalizeFirst}',
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (controller.text.isNotEmpty) {
                      _controller.addItem(
                        type,
                        controller.text,
                        selectedCategory,
                        selectedSubCategory,
                        selectedTopic,
                      );
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showItems(BuildContext context, int mainIndex, String type) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('$type for ${_controller.mainCategories[mainIndex]['name']}'),
          content: SizedBox(
            width: 300,
            child: Obx(() {
              var items = _controller.mainCategories[mainIndex][type] ?? [];
              return ListView.builder(
                shrinkWrap: true,
                itemCount: items.length,
                itemBuilder: (context, itemIndex) {
                  return ListTile(
                    title: Text(items[itemIndex]['name']),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        _controller.removeItem(mainIndex, type, itemIndex);
                      },
                    ),
                  );
                },
              );
            }),
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
}


