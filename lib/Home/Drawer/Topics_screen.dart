import 'package:blissiqadmin/Global/constants/AppColor.dart';
import 'package:blissiqadmin/Home/Controller/MainCategoryController.dart';
import 'package:blissiqadmin/Home/Drawer/MyDrawer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Global/constants/CustomAlertDialogue.dart';
import '../../controller/CategoryController.dart';

class TopicsScreen extends StatefulWidget {
   TopicsScreen({super.key,required this.subcategory});
    var subcategory;

  @override
  State<TopicsScreen> createState() => _TopicsScreenState();
}

class _TopicsScreenState extends State<TopicsScreen> {
  final CategoryController _controller = Get.put(CategoryController());
  List<TableRow> tableRows = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData() async{
    await _controller.get_topic(categoryId: widget.subcategory['main_category_id'], sub_categoryId: widget.subcategory['_id']);
    // Future.delayed(const Duration(seconds: 2), () {
    //   getRows();
    // });
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
          "Manage Topics and Subtopics from here:",
          style: TextStyle(
              fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
        ),
        SingleChildScrollView(
            child: SizedBox(
                height:MediaQuery.of(context).size.height/2,
                child:Obx(()=>
               ListView.builder(
                itemCount: _controller.topics.length,
                itemBuilder: (context, index) {
                  return ExpansionTile(
                      title: Row(children:[Text(_controller.topics[index]['topic_name']),
                       IconButton(
                        icon: Icon(Icons.add_circle_outline),
                        onPressed: () {
                          _showAddDialog(context,'subtopic',index,_controller.topics[index]);
                        })
                      ]),
                      onExpansionChanged: (isExpanded) {
                        if (isExpanded && _controller.sub_topics[index] == null) {
                          _controller.get_SubTopic(
                            categoryId:_controller.topics[index]['main_category_id'],
                            sub_categoryId:_controller.topics[index]['sub_category_id'],
                            topicId:_controller.topics[index]['_id'],
                          );
                        }
                      },
                      children: _controller.sub_topics.map((topic) {
                        return SubTopicTile(topic: topic);
                      }).toList()
                  );
                }),)
            ),
        ),
      ],
    );
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

  void _showAddDialog(BuildContext context, String type, int? categoryIndex,var topicDetails) {
    TextEditingController controller = TextEditingController();
    String? selectedCategoryId;
    String? selectedSubCategoryId;
    selectedCategoryId =topicDetails['main_category_id'];
    selectedSubCategoryId = topicDetails['sub_category_id'];

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
                      _controller.addTopic(
                          topic_name:controller.text,
                          sub_categoryId:selectedSubCategoryId!,
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

}

class SubTopicTile extends StatefulWidget {
  var topic;

  SubTopicTile({required this.topic});
  @override
  State<SubTopicTile> createState() => _SubTopicTileState();
}

class _SubTopicTileState extends State<SubTopicTile> {
  final CategoryController _controller = Get.put(CategoryController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller.get_SubTopic(categoryId: widget.topic['main_category_id'],
        sub_categoryId: widget.topic['sub_category_id'], topicId: widget.topic['_id']);
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(''),
      children:_controller.sub_topics.isEmpty? []:
      _controller.sub_topics.map((subtopic) {
        return Obx(()=>ListTile(
          title: Text(subtopic['sub_topic_name']),
          trailing: IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {

            },
          ),
        ));
      }).toList(),
    );
  }
}


