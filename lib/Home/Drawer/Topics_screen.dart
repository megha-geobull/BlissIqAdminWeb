import 'package:blissiqadmin/Global/Widgets/ExampleModel.dart';
import 'package:blissiqadmin/Global/constants/CustomAlertDialogue.dart';
import 'package:blissiqadmin/Home/Drawer/MyDrawer.dart';
import 'package:blissiqadmin/Home/Quetion%20type%20widgets/AddQuetionsWidgets/AddQuetionsWidgets.dart';
import 'package:blissiqadmin/controller/CategoryController.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';


class TopicsScreen extends StatefulWidget {
  TopicsScreen({super.key,required this.subcategory});
  var subcategory;

  @override
  State<TopicsScreen> createState() => _TopicsScreenState();
}

class _TopicsScreenState extends State<TopicsScreen> {
  final CategoryController _controller = Get.put(CategoryController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getData();
    });
  }

  getData() async{
    await _controller.get_topic(categoryId: widget.subcategory['main_category_id'],
        sub_categoryId: widget.subcategory['_id']);
    Future.delayed(const Duration(seconds: 2), () {
      if(_controller.topics.isNotEmpty) {
        _controller.get_SubTopic(
          categoryId: _controller.topics[0]['main_category_id'],
          sub_categoryId: _controller.topics[0]['sub_category_id'],
          topicId: _controller.topics[0]['_id'],
        );
      }
    });
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
                    child: Obx(() => Padding(
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
        Row(children:[const Text(
          "Manage Topics and Subtopics from here:",
          style: TextStyle(
              fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
        ),
          Spacer(),
          InkWell(
              onTap: (){
                _showAddDialog(context,'topic',0,'');
              },
              child: const Text('Add Topic')),

          IconButton(
              icon: Icon(Icons.add_circle_outline),
              onPressed: () {
                _showAddDialog(context,'topic',0,'');
              })
        ]),
        Obx(()=>_controller.isLoading==true?Container(child:Center(child: Text('Loading Topics...'),)):
        _controller.isLoading==false && _controller.topics.isEmpty?
        Container(child:Center(child:Text('No Topics available'))):
       SingleChildScrollView(
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height / 1.5,
                        child: Obx(
                          () => ListView.builder(
                            itemCount: _controller.topics.length,
                            itemBuilder: (context, index) {
                              final topic = _controller.topics[index];
                              final topicId = topic['_id']; // Assuming this uniquely identifies each topic

                              return Card(
                                color: Colors.white,
                                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                                elevation: 0.4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: ExpansionTile(
                                  shape: Border.all(color: Colors.grey.shade200, width: 0.8),
                                  title: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        topic['topic_name'],
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.add_circle_outline, color: Colors.green),
                                            onPressed: () {
                                              _showAddDialog(context, 'subtopic', index, topic);
                                            },
                                          ),
                                          IconButton(
                                            icon: Image.asset(
                                              'assets/question.png',
                                              width: 30,
                                              height: 30,
                                              fit: BoxFit.cover,
                                            ),
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => AddQuestionsWidgets(),
                                                ),
                                              );
                                            },
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.delete, color: Colors.red),
                                            onPressed: () {
                                              onDelete(topic, index, "You want to delete this Topic?", 'topic', '');
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  onExpansionChanged: (isExpanded) {
                                    if (isExpanded && !_controller.subtopicsMap.containsKey(topicId)) {
                                      // Fetch subtopics only if not already fetched
                                      _controller.get_SubTopic(
                                        categoryId: topic['main_category_id'],
                                        sub_categoryId: topic['sub_category_id'],
                                        topicId: topicId,
                                      );
                                    }
                                  },
                                  children: [
                                    Obx(() {
                                      final subtopics = _controller.subtopicsMap[topicId] ?? [];
                                      return Column(
                                        children: subtopics.map((subTopic) {
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                                            child: Card(
                                              elevation: 3,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              child: ListTile(
                                                contentPadding: const EdgeInsets.all(16),
                                                title: Text(
                                                  subTopic['sub_topic_name'],
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                trailing: IconButton(
                                                  icon: const Icon(Icons.delete, color: Colors.red),
                                                  onPressed: () {
                                                    onDelete(
                                                      subTopic,
                                                      index,
                                                      "You want to delete this Subtopic?",
                                                      'subtopic',
                                                      subTopic['_id'],
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                      );
                                    }),
                                  ],
                                ),
                              );
                            },
                          )
                          ,
                        ),
                      ),
                    ),
        ),
      ],
    );
  }


  void onDelete(var topic, int index, String title, String type, String subtopic_id) {
    showDialog(
      context: context,
      builder: (context) => CustomAlertDialog(
        title: 'Are you sure',
        content: title,
        yesText: 'Yes',
        noText: 'No', onYesPressed: () {
        Navigator.pop(context);
        if(type=="topic") {
          _controller.deleteTopic(
              categoryId: topic['main_category_id'], sub_categoryId: topic['sub_category_id'],topicId:topic['_id'] );
          _controller.topics.removeAt(index);
        }else{
          _controller.deleteSub_Topic(
              categoryId: topic['main_category_id'], sub_categoryId: topic['sub_category_id'],topicId:topic['topic_id'],sub_topicId: subtopic_id );
          _controller.subtopicsMap[topic['topic_id']]?.removeAt(index);
        }
      },
      ),
    );
  }

  void _showAddDialog(BuildContext context, String type, int? categoryIndex,var topicDetails) {
    TextEditingController controller = TextEditingController();
    String? selectedCategoryId;
    String? selectedSubCategoryId;
    String? selectedTopicId;
    if(type=="subtopic"){
      selectedCategoryId =topicDetails['main_category_id'];
      selectedSubCategoryId = topicDetails['sub_category_id'];
      selectedTopicId = topicDetails['_id']??'';
    }
    else{
      selectedCategoryId =widget.subcategory['main_category_id'];
      selectedSubCategoryId = widget.subcategory['_id'];
      selectedTopicId='';
    }

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Container(
                padding: const EdgeInsets.all(16.0),
                constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Add $type', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    TextField(
                      controller: controller,
                      decoration: InputDecoration(
                        labelText: 'Enter ${type.capitalizeFirst}',
                      ),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () async {
                        // Open image picker to select multiple images
                        //final List<XFile>? images = await ImagePicker().pickMultiImage();
                        List<PlatformFile>? images = (await FilePicker.platform.pickFiles(
                          type: FileType.custom,
                          allowMultiple: false,
                          onFileLoading: (FilePickerStatus status) =>
                              print("status .... $status"),
                          allowedExtensions: ['png', 'jpg', 'jpeg'],
                        ))
                            ?.files;
                        if (images != null) {
                          for (var image in images) {
                            // Preload bytes for the image
                            final bytes = await image.bytes;
                            // Add to tempList with bytes
                            _controller.tempList.add(
                              ImageWithText(file: image, path: '', bytes: bytes,imageName:image.name ),
                            );
                          }
                          setState(() {});
                        }
                      },
                      child: Text('Add Examples'),
                    ),
                    SizedBox(height: 10),
                    if (_controller.tempList.isNotEmpty)
                      Expanded(
                        child: ListView.builder(
                          itemCount: _controller.tempList.length,
                          itemBuilder: (context, index) {
                            final item = _controller.tempList[index];
                            return Card(
                                margin: const EdgeInsets.symmetric(vertical: 5),
                                child: Container(
                                  width:300,
                                  child:
                                  Row(
                                    children: [
                                      //Image.file(File(item.path)),
                                      SizedBox(
                                        height:100,width: 100,
                                        child:Image.memory(item.bytes!),),//Display selected image
                                      SizedBox(
                                          width:250,
                                          child:TextField(
                                            decoration: const InputDecoration(
                                              labelText: 'Enter Name for Example',
                                            ),
                                            onChanged: (value) {
                                              item.name = value;
                                            },
                                          ))
                                      ,
                                      IconButton(
                                        icon: Icon(Icons.delete, color: Colors.red),
                                        onPressed: () {
                                          setState(() {
                                            _controller.tempList.removeAt(index);
                                          });
                                        },
                                      ),
                                    ],
                                  ),)
                            );
                          },
                        ),
                      ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (controller.text.isNotEmpty) {
                              if (type == "subtopic") {
                                _controller.addSubTopic(
                                  subtopic_name: controller.text,
                                  sub_categoryId: selectedSubCategoryId!,
                                  maincategory_id: selectedCategoryId!,
                                  topicId: selectedTopicId!,
                                );
                                _controller.sub_topics.refresh();
                              } else if (type == "topic") {
                                _controller.addTopic(
                                  topic_name: controller.text,
                                  maincategory_id: widget.subcategory['main_category_id']!,
                                  sub_categoryId: widget.subcategory['_id']!,
                                  examples: _controller.tempList,
                                );
                                _controller.topics.refresh();
                              }
                              Navigator.of(context).pop();
                            }
                          },
                          child: const Text('Add'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

}