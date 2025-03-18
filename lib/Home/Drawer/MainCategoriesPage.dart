import 'dart:io';

import 'package:blissiqadmin/Global/Widgets/Button/CustomButton.dart';
import 'package:blissiqadmin/Global/constants/AppColor.dart';
import 'package:blissiqadmin/Global/constants/CommonSizedBox.dart';
import 'package:blissiqadmin/Global/constants/CustomTextField.dart';
import 'package:blissiqadmin/Home/Controller/MainCategoryController.dart';
import 'package:blissiqadmin/Home/Drawer/MyDrawer.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../Global/constants/CustomAlertDialogue.dart';
import '../../controller/CategoryController.dart';
import 'Topics_screen.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class MainCategoriesPage extends StatefulWidget {
  const MainCategoriesPage({super.key});

  @override
  State<MainCategoriesPage> createState() => _MainCategoriesPageState();
}

class _MainCategoriesPageState extends State<MainCategoriesPage> {
  final CategoryController _controller = Get.find();
  List<TableRow> tableRows = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getData();
    });
  }

  getData() async{
    await _controller.getCategory();
      getRows();
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
            boxH30(),
            CustomButton(
              label: "Cancel",
              color: Colors.red,
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              onPressed: () async {
                if (categoryController.text.isNotEmpty) {
                  await _controller.addCategory(categoryname: categoryController.text);
                  Navigator.of(context).pop();
                  getData();
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
                  body: Obx(() => Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: _controller.isLoading.value
                        ? Center(
                      child: LoadingAnimationWidget.hexagonDots(
                        color: Colors.deepOrange,
                        size: 70,
                      ),
                    )
                        : _buildMainContent(constraints),
                  )),
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
          "Manage Categories, Subcategories, etc from here:",
          style: TextStyle(
              fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Obx(() => Table(
              border: TableBorder.all(color: Colors.grey),
              columnWidths: const {
                0: FlexColumnWidth(2),
                1: FlexColumnWidth(1),
                2: FlexColumnWidth(1),
                3: FlexColumnWidth(1),
                4: FlexColumnWidth(1),
                5: FlexColumnWidth(1),
              },
              children: getRows(),
            )),
          ),
        ),
      ],
    );
  }

  List<TableRow> getRows() {
    List<TableRow> rows = [];

    rows.add(TableRow(
      decoration: BoxDecoration(color: Colors.orange[100]),
      children: [
        // 1st column
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            children: [
              Text(
                'Main Category Name',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              // const Spacer(),
              // IconButton(
              //   onPressed: _showAddCategoryDialog,
              //   icon: CircleAvatar(
              //     radius: 10,
              //     backgroundColor: Colors.deepOrange.shade200,
              //     child: const Icon(
              //       Icons.add,
              //       color: Colors.white,
              //       size: 20,
              //     ),
              //   ),
              //   tooltip: 'Add Main Category',
              // ),
            ],
          ),
        ),
        // 2nd column
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
                onPressed: () => _showAddDialog(context, 'subCategory', 0),
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
      ],
    ));

  if (_controller.categories.isNotEmpty) {
      for (int index = 0; index < _controller.categories.length; index++) {
        var category = _controller.categories[index];
        rows.add(
          TableRow(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      category['category_name'] ?? 'No Name',
                      style: const TextStyle(fontSize: 16),
                    ),
                    // const Spacer(),
                    // IconButton(
                    //   icon: const Icon(Icons.delete, color: Colors.red),
                    //   onPressed: () {
                    //     onDelete(_controller.categories[index]['_id'], index,
                    //         "you want to delete this category?", "category");
                    //   },
                    // ),
                  ],
                ),
              ),
              TextButton(
                child: const Text(
                  "View",
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                ),
                onPressed: () async {
                  await _controller.getSubCategory(categoryId: _controller.categories[index]['_id']);
                  _showItems(context, index, 'subCategories', _controller.sub_categories);
                },
              ),
            ],
          ),
        );
      }
    };

    return rows;
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
            Uint8List? imageBytes; // To store the selected image bytes
            String? imageName; // To store the selected image name

            // Function to pick an image from the gallery
            pickImage() async {
              try {
                FilePickerResult? pickedFile = await FilePicker.platform.pickFiles(
                  type: FileType.custom,
                  allowMultiple: false,
                  allowedExtensions: ['png', 'jpg', 'jpeg'],
                );
                if (pickedFile != null && pickedFile.files.isNotEmpty) {
                  setState(() {
                    imageBytes = pickedFile.files.first.bytes;
                    imageName = 'image_${DateTime.now().millisecondsSinceEpoch}.png';
                  });
                }
              } catch (e) {
                if (kDebugMode) {
                  print('Error picking image: $e');
                }
              }
            }

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
                    /// Show image upload option only if the main category is "Vocabulary"
                    // if (selectedCategory == 'Vocabulary') ...[
                    //   const SizedBox(height: 16),
                    //   const Text('Upload Image:'),
                    //   const SizedBox(height: 8),
                    //   imageBytes == null
                    //       ? ElevatedButton(
                    //     onPressed: pickImage,
                    //     child: const Text('Pick Image from Gallery'),
                    //   )
                    //       : Column(
                    //     children: [
                    //       // Display the selected image
                    //       Image.memory(
                    //         imageBytes!,
                    //         height: 50,
                    //         width: 50,
                    //         fit: BoxFit.cover,
                    //       ),
                    //       const SizedBox(height: 8),
                    //       TextButton(
                    //         onPressed: pickImage,
                    //         child: const Text('Change Image'),
                    //       ),
                    //     ],
                    //   ),
                    // ],
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
                        maincategory_id:selectedCategoryId!,
                        //imageBytes: imageBytes,
                      //  imageName: imageName,
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

  void _showItems(BuildContext context, int mainIndex, String type, RxList subcatList) {
    RxList<dynamic> reorderedList = RxList.of(subcatList); // Copy of subcategory list

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('$type for ${_controller.categories[mainIndex]['category_name']}'),
          content: SizedBox(
            width: 500,
            child: Obx(() {
              return ReorderableListView.builder(
                shrinkWrap: true,
                itemCount: reorderedList.length,
                onReorder: (oldIndex, newIndex) {
                  if (newIndex > oldIndex) newIndex -= 1; // Adjust for shifting
                  var movedItem = reorderedList.removeAt(oldIndex);
                  reorderedList.insert(newIndex, movedItem);
                },
                itemBuilder: (context, itemIndex) {
                  var items = reorderedList[itemIndex];
                  return ListTile(
                    key: ValueKey(items['_id']),
                    title: Text(items['sub_category']),
                    trailing: SizedBox(
                      width: 200,
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => TopicsScreen(subcategory: items)),
                              );
                            },
                            child: Text('Topics'),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              onDelete(
                                items['main_category_id'],
                                itemIndex,
                                "You want to delete this subcategory?",
                                "subcategory",
                              );
                            },
                          ),
                        ],
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
            ElevatedButton(
              onPressed: () {
                String reorderedIds = reorderedList.map((item) => item['_id']).join('|');
                print(reorderedIds);
                Get.find<CategoryController>().updateSubCategoriesOrder(subCategoriesID: reorderedIds);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

}


