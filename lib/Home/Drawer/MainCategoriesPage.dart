import 'package:blissiqadmin/Global/Widgets/Button/CustomButton.dart';
import 'package:blissiqadmin/Global/constants/AppColor.dart';
import 'package:blissiqadmin/Global/constants/CommonSizedBox.dart';
import 'package:blissiqadmin/Global/constants/CustomTextField.dart';
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
  List<Map<String, String>> staticQuestionTypes = [
    {'name': 'Fill in the Blanks'},
    {'name': 'Match the Pair'},
    {'name': 'Complete Word'},
    {'name': 'Multiple Choice Question'},
    {'name': 'True/False'},
  ];

  void _showAddCategoryDialog() {
    TextEditingController categoryController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Main Category'),
          content: SizedBox(
            width: 300,
            child: CustomTextField(
                controller: categoryController, labelText: 'Category Name'),
          ),
          actions: [
            boxH30(),
            CustomButton(
              label: "Cancel",
              color: Colors.red,
              onPressed: () => Navigator.of(context).pop(),
            ),
            boxH20(),
            CustomButton(
              label: "Add Category",
              onPressed: () {
                if (categoryController.text.isNotEmpty) {
                  _controller.addCategory(categoryController.text);
                  Navigator.of(context).pop();
                }
              },
            )
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
                  0: FlexColumnWidth(1),
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
                              onPressed: () =>
                                  _showAddDialog(context, 'subCategory', 0),
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
                              onPressed: () =>
                                  _showAddDialog(context, 'topic', 0),
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
                              onPressed: () =>
                                  _showAddDialog(context, 'subTopic', 0),
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
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Center(
                          child: Row(
                            children: [
                              Text('Add Question Type',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black)),
                              // const Spacer(),
                              // IconButton(
                              //   // onPressed: () => _showAddDialog(context,'queType', 0),
                              //   icon:  CircleAvatar(
                              //     radius: 10,
                              //     backgroundColor: Colors.deepOrange.shade200,
                              //     child: const Icon(
                              //       Icons.add,
                              //       color: Colors.white,
                              //       size: 20,
                              //     ),
                              //   ),
                              //   padding: const EdgeInsets.all(0),
                              //   tooltip: 'Add Question Type',
                              // ),
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
                            onPressed: () =>
                                _showItems(context, index, 'subCategories'),
                          ),
                          TextButton(
                            child: const Text("View",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)),
                            onPressed: () =>
                                _showItems(context, index, 'topics'),
                          ),
                          TextButton(
                            child: const Text(
                              "View",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            onPressed: () =>
                                _showItems(context, index, 'subTopics'),
                          ),
                          TextButton(
                            child: const Text(
                              "Add",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            onPressed: () =>
                                _showItems(context, index, 'QueType'),
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
              content: SizedBox(
                width: 300,
                child: SingleChildScrollView(
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
                                    (category) =>
                                        category['name'] == selectedCategory,
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
                                    (category) =>
                                        category['name'] == selectedCategory,
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
                      boxH20(),
                      CustomTextField(
                          controller: controller,
                          labelText: 'Enter ${type.capitalizeFirst}')
                    ],
                  ),
                ),
              ),
              actions: [
                CustomButton(
                    label: 'Cancel',
                    onPressed: () => Navigator.of(context).pop()),
                boxH20(),
                CustomButton(
                  label: 'Add',
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
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$type for ${_controller.mainCategories[mainIndex]['name']}',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: SizedBox(
            width: 300,
            child: Obx(() {
              var items = _controller.mainCategories[mainIndex][type] ?? [];
              if (type == 'topics') {
                items = _controller.mainCategories[mainIndex]['topics'] ?? [];
              } else if (type == 'subTopics') {
                items = _controller.mainCategories[mainIndex]['topics']
                    .where((topic) => topic['subTopics'] is List)
                    .expand((topic) => (topic['subTopics'] as List?) ?? [])
                    .toList();
              } else if (type == 'QueType') {
                items =
                    staticQuestionTypes; // Ensure staticQuestionTypes is defined
              }

              return ListView.builder(
                shrinkWrap: true,
                itemCount: items.length,
                itemBuilder: (context, itemIndex) {
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    child: ListTile(
                      leading: Icon(Icons.category, color: Colors.blue),
                      title: Text(
                        items[itemIndex]['name'],
                        style: TextStyle(fontSize: 16),
                      ),
                      trailing: type == 'QueType'
                          ? IconButton(
                              icon: const CircleAvatar(
                                  radius: 15,
                                  child: Icon(Icons.add, color: Colors.blue)),
                              onPressed: () {
                                print('Add ${items[itemIndex]['name']}');
                              },
                            )
                          : IconButton(
                              icon:
                                  const Icon(Icons.delete, color: Colors.black),
                              onPressed: () {
                                int topicIndex = _controller
                                    .mainCategories[mainIndex]['topics']
                                    .indexWhere((topic) =>
                                        topic['subTopics']
                                            ?.contains(items[itemIndex]) ??
                                        false);
                                _controller.removeItem(
                                    mainIndex, type, itemIndex,
                                    topicIndex: topicIndex);
                              },
                            ),
                    ),
                  );
                },
              );
            }),
          ),
          actions: [
            CustomButton(
              label: "Close",
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
        );
      },
    );
  }
}
