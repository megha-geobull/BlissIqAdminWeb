import 'package:blissiqadmin/Global/constants/AppColor.dart';
import 'package:blissiqadmin/Home/Controller/MainCategoryController.dart';
import 'package:blissiqadmin/Home/Drawer/MyDrawer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Global/constants/CustomAlertDialogue.dart';
import '../../controller/CategoryController.dart';
import 'Topics_screen.dart';

class MainCategoriesPage extends StatefulWidget {
  const MainCategoriesPage({super.key});

  @override
  State<MainCategoriesPage> createState() => _MainCategoriesPageState();
}

class _MainCategoriesPageState extends State<MainCategoriesPage> {
  final CategoryController _controller = Get.put(CategoryController());
  List<TableRow> tableRows = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData() async{
    await _controller.getCategory();
    Future.delayed(const Duration(seconds: 2), () {
      getRows();
    });
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
                  _controller.addCategory(categoryname: categoryController.text);
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
          "Manage Categories,Subcategories,etc from here:",
          style: TextStyle(
              fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
        ),
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
                children: tableRows,
              )
             //}),
          ),
        ),
      ],
    );
  }

  getRows(){
    tableRows.add(TableRow(
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
        // Padding(
        //   padding: const EdgeInsets.all(8.0),
        //   child: Row(
        //     children: [
        //       const Text(
        //         'Topics',
        //         style: TextStyle(
        //             fontWeight: FontWeight.bold,
        //             color: Colors.black),
        //       ),
        //       const Spacer(),
        //       IconButton(
        //         onPressed: () => _showAddDialog(context,'topic', 0),
        //         icon: CircleAvatar(
        //           radius: 10,
        //           backgroundColor: Colors.deepOrange.shade200,
        //           child: const Icon(
        //             Icons.add,
        //             color: Colors.white,
        //             size: 20,
        //           ),
        //         ),
        //         tooltip: 'Add Topics',
        //       ),
        //     ],
        //   ),
        // ),
        // Padding(
        //   padding: const EdgeInsets.all(8.0),
        //   child: Row(
        //     children: [
        //       const Text(
        //         'Subtopics',
        //         style: TextStyle(
        //             fontWeight: FontWeight.bold,
        //             color: Colors.black),
        //       ),
        //       const Spacer(),
        //       IconButton(
        //         onPressed: () => _showAddDialog(context,'subTopic', 0),
        //         icon: CircleAvatar(
        //           radius: 10,
        //           backgroundColor: Colors.deepOrange.shade200,
        //           child: const Icon(
        //             Icons.add,
        //             color: Colors.white,
        //             size: 20,
        //           ),
        //         ),
        //         padding: const EdgeInsets.all(0),
        //         tooltip: 'Add Subtopics',
        //       ),
        //     ],
        //   ),
        // ),
        // Padding(
        //   padding: const EdgeInsets.all(8.0),
        //   child: Center(
        //     child: Row(
        //       children: [
        //         const Text('Question Type',
        //             style: TextStyle(
        //                 fontWeight: FontWeight.bold,
        //                 color: Colors.black)),
        //         const Spacer(),
        //         IconButton(
        //           onPressed: () => _showAddDialog(context,'queType', 0),
        //           icon:  CircleAvatar(
        //             radius: 10,
        //             backgroundColor: Colors.deepOrange.shade200,
        //             child: const Icon(
        //               Icons.add,
        //               color: Colors.white,
        //               size: 20,
        //             ),
        //           ),
        //           padding: const EdgeInsets.all(0),
        //           tooltip: 'Add Question Type',
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
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
    ));
      if (_controller.categories.isNotEmpty) {
        for (int index = 0; index < _controller.categories.length; index++) {
          var category = _controller.categories[index];
          tableRows.add(
            TableRow(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child:Row(children: [
                    Text(
                      category['category_name'] ?? 'No Name',
                      style: const TextStyle(fontSize: 16),
                    ),
                    Spacer(),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        onDelete(_controller.categories[index]['_id'],index,"you want to delete this category?","category");
                      },
                    ),
                  ],)
                ),
                TextButton(
                  child: const Text(
                    "View",
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () async {
                    await _controller.getSubCategory(categoryId:_controller.categories[index]['_id']);
                    _showItems(context, index, 'subCategories',_controller.sub_categories);
                    },
                ),
                // TextButton(
                //   child: const Text(
                //     "View",
                //     style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                //   ),
                //   onPressed: () async{
                //     await _controller.get_topic(categoryId:_controller.categories[index]['_id'],sub_categoryId:_controller.sub_categories[index]['_id'] );
                //     _showItems(context, index, 'topics',_controller.topics);},
                // ),
                // TextButton(
                //   child: const Text(
                //     "View",
                //     style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                //   ),
                //   onPressed: () => _showItems(context, index, 'subTopics',_controller.sub_categories),
                // ),
                // TextButton(
                //   child: const Text(
                //     "View",
                //     style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                //   ),
                //   onPressed: () => _showItems(context, index, 'QueType',_controller.sub_categories),
                // ),
              ],
            ),
          );
        }
      };
      setState(() {
        tableRows;
      });
  }

  void onDelete(String productId,int index,String title,String type) {
    showDialog(
      context: context,
      builder: (context) => CustomAlertDialog(
        title: 'Are you sure',
        content: title,
        yesText: 'Yes',
        noText: 'No', onYesPressed: () {
        if(type=="category") {
          Navigator.pop(context);
          _controller.deleteCategory(
              categoryId: _controller.categories[index]['_id']);
          _controller.categories.removeAt(index);
          tableRows.removeAt(index + 1);
        }else{
          _controller.deleteSubCategory(categoryId:_controller.sub_categories[index]['main_category_id'],sub_categoryId: _controller.sub_categories[index]['_id'],);
          _controller.sub_categories.removeAt(index);
          }
        },
      ),
    );
  }

  void _showAddDialog(BuildContext context, String type, int? categoryIndex) {
    TextEditingController controller = TextEditingController();
    String? selectedCategory;
    String? selectedCategoryId;
    String? selectedSubCategoryId;
    selectedCategoryId =_controller.categories[0]['_id'];
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
                            int selectedIndex = _controller.categories.indexWhere((product) => product['category_name'] == selectedCategory);
                            selectedCategoryId =_controller.categories[selectedIndex]['_id'];
                            selectedSubCategory = null;
                            selectedTopic = null;
                            _controller.getSubCategory(categoryId: selectedCategoryId!);
                          });
                          _controller.sub_categories.refresh();
                        },
                        items: _controller.categories
                            .map((category) => DropdownMenuItem<String>(
                          value: category['category_name'],
                          child: Text(category['category_name']),
                        ))
                            .toList(),
                      ),
                    ],
                    if (type == 'topic' || type == 'subTopic') ...[
                      const Text('Subcategory:'),
                      Obx(()=>
                          DropdownButton<String>(
                            hint: const Text('Choose Subcategory'),
                            value: selectedSubCategory,
                            onChanged: (newValue) {
                              setState(() {
                                selectedSubCategory = newValue;
                                int selectedIndex = _controller.sub_categories.indexWhere((product) => product['category_name'] == selectedCategory);
                                selectedSubCategoryId =_controller.sub_categories[selectedIndex]['_id'];
                                selectedTopic = null;
                              });
                            },
                            items: _controller.sub_categories
                                .firstWhere(
                                  (subcategory) => subcategory['sub_category'] == selectedSubCategory,
                              orElse: () => {},
                            )['subCategories']
                                ?.map<DropdownMenuItem<String>>(
                                  (subCategory) => DropdownMenuItem<String>(
                                value: subCategory['sub_category'],
                                child: Text(subCategory['sub_category']),
                              ),
                            )?.toList() ?? [],
                          )),
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
                        items: _controller.categories
                            .firstWhere(
                              (category) => category['name'] == selectedCategory,
                          orElse: () => {},
                        )['topics']?.map<DropdownMenuItem<String>>(
                              (topic) => DropdownMenuItem<String>(
                            value: topic['name'],
                            child: Text(topic['name']),
                          ),
                        )?.toList() ?? [],
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
                      _controller.addSubCategory(
                        subcategory:controller.text,
                        maincategory_id:selectedCategoryId!
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

  void _showItems(BuildContext context, int mainIndex, String type,RxList subcatList) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('$type for ${_controller.categories[mainIndex]['category_name']}'),
          content: SizedBox(
            width: 300,
            child: Obx(() {
              return ListView.builder(
                shrinkWrap: true,
                itemCount: _controller.sub_categories.length,
                itemBuilder: (context, itemIndex) {
                  var items = _controller.sub_categories[itemIndex];
                  return ListTile(
                    title: Text(items['sub_category']),
                    trailing: SizedBox(
                      width: 200,
                      child: Row(
                        children:[
                          InkWell(
                              onTap: (){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          TopicsScreen( subcategory: items,)),
                                );
                                //Navigator.pop(context);
                              },
                              child: Text('Topics')),
                          IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            onDelete(_controller.sub_categories[itemIndex]['main_category_id'],itemIndex,"you want to delete this subcategory?","subcategory");
                          },
                        ),
                        ]
                      ),
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


