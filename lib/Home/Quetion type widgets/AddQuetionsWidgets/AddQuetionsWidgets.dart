import 'package:blissiqadmin/Global/Widgets/Button/CustomButton.dart';
import 'package:blissiqadmin/Global/constants/CommonSizedBox.dart';
import 'package:blissiqadmin/Global/constants/CustomTextField.dart';
import 'package:blissiqadmin/Home/Drawer/MyDrawer.dart';
import 'package:blissiqadmin/Home/Quetion%20type%20widgets/add_match_the_pairs.dart';
import 'package:blissiqadmin/controller/CategoryController.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:csv/csv.dart';
import 'package:share_extend/share_extend.dart';
// import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
// import 'package:excel/excel.dart' as excel;


class AddQuestionsWidgets extends StatefulWidget {
  @override
  _AddQuestionsWidgetsState createState() => _AddQuestionsWidgetsState();
}

class _AddQuestionsWidgetsState extends State<AddQuestionsWidgets> {

  final TextEditingController questionController = TextEditingController();
  final List<TextEditingController> optionControllers =
      List.generate(4, (_) => TextEditingController());
  final List<TextEditingController> paragraphOptionControllers =
  List.generate(6, (_) => TextEditingController());
  TextEditingController correctAnswerController = TextEditingController();
  TextEditingController pointsController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController storyContentController = TextEditingController();
  TextEditingController storyPhrasesController = TextEditingController();

  Uint8List? selectedImage;
  List<TableRow> tableRows = [];

  final List<String> mainCategories = [];
  final List<String> subCategories = [];
  final List<String> topics = [];
  final List<String> subTopics = [];

  final List<String> tabs = [
    "Conversational English",
    "A1",
    "Greetings",
    "Story",
    "Phrases",
    "Quizes",
    "Conversation"
  ];

  int selectedIndex = 0;
  String? selectedMainCategory;
  String? selectedSubCategory;
  String? selectedTopic;
  String? selectedSubtopic;

  String? mainCategoryId;
  String? subCategoryId;

  String? imagePath;
  final ImagePicker _picker = ImagePicker();
  // Function to pick an image from the gallery
  Future<void> pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        imagePath = pickedFile.path;
      });
    }
  }

  String? selectedQuestionType = "Multiple Choice Question";
  List<String> questionTypes = [
    "Multiple Choice Question",
    "Re-Arrange the Word",
    "Complete the Word",
    "True/False",
    "Story",
    "Phrases",
    "Conversation",
    "Fill in the blanks",
    "Match the pairs",
    "Complete the paragraph",
  ];
  final CategoryController _controller = Get.put(CategoryController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final Uint8List imageData = await image.readAsBytes();
      setState(() {
        selectedImage = imageData;
      });
    }
  }



  void _exportTableToCSV() async {
    List<List<dynamic>> rows = [];

    // Header Row
    List<String> headers = [
      "Type",
      "Question",
      "Option 1",
      "Option 2",
      "Option 3",
      "Option 4",
      "Answer",
      "Points",
      "Main Category ID",
      "Sub Category ID",
      "Topic ID",
      "Sub Topic ID",
      "Question Type",
      "Title",
      "Question Image",
    ];
    rows.add(headers);

    List<dynamic> sampleData = [
      "add-mcq",
      "",
      "main_category_id",
      "sub_category_id",
      "topic_id",
      "sub_topic_id",
      "question_type",
      "title",
      "question",
      "q_image",
      "option_a",
      "option_b",
      "option_c",
      "option_d",
      "answer",
      "points",
    ];
    rows.add(sampleData);

    // Extract Data from Table Rows
    for (var row in tableRows) {
      List<dynamic> rowData = [];

      for (var cell in row.children) {
        // Extract text from each table cell
        if (cell is Padding && cell.child is Text) {
          rowData.add((cell.child as Text).data);
        } else {
          rowData.add("");  // Fallback if the data is not found
        }
      }

      rows.add(rowData);
    }

    // Convert to CSV String
    String csvString = const ListToCsvConverter().convert(rows);

    // Save CSV to Temporary Directory
    final directory = await Directory.systemTemp.createTemp();
    final file = File('${directory.path}/questions_data.csv');
    await file.writeAsString(csvString);

    // Share the File
    if (file.existsSync()) {
      ShareExtend.share(file.path, "file");
    }
  }



  getData() async {
    await _controller.getCategory();
    setState(() {});
  }

  Widget _buildTabs() {
    return Column(
      children: [
        /// Select Main Category
        Row(
          children: [
            // Main Category Dropdown
            Expanded(
              child: DropdownButtonFormField<String>(
                value: selectedMainCategory,
                hint: Text("Select Main Category"),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                ),
                items: _controller.categories.map<DropdownMenuItem<String>>((category) {
                  String categoryName = category['category_name'].toString();
                  return DropdownMenuItem<String>(
                    value: categoryName,
                    child: Text(categoryName),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedMainCategory = value;
                    selectedSubCategory = null;
                    selectedTopic = null;
                    selectedSubtopic = null; // Reset subtopic as well
                    // Fetch subcategories based on the selected main category
                    mainCategoryId = _controller.categories.firstWhere((cat) => cat['category_name'] == value)['_id'];
                    _controller.getSubCategory(categoryId: mainCategoryId.toString()).then((_) {
                      setState(() {}); // Update the state after fetching subcategories
                    });
                  });
                },
              ),
            ),
            boxW10(),
            // Sub Category Dropdown
            Expanded(
              child: DropdownButtonFormField<String>(
                value: selectedSubCategory,
                hint: Text("Select Sub Category"),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                ),
                items: _controller.sub_categories.map<DropdownMenuItem<String>>((subCategory) {
                  String subCategoryName = subCategory['sub_category'].toString();
                  return DropdownMenuItem<String>(
                    value: subCategoryName,
                    child: Text(subCategoryName),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedSubCategory = value;
                    selectedTopic = null; // Reset topic when subcategory changes
                    selectedSubtopic = null; // Reset subtopic as well
                    subCategoryId = _controller.sub_categories.firstWhere((subcategory) => subcategory['sub_category'] == value)['_id'];
                    print( mainCategoryId.toString());
                    print(subCategoryId.toString());
                    _controller.get_topic(categoryId: mainCategoryId.toString(), sub_categoryId: subCategoryId.toString()).then((_) {
                      setState(() {}); // Update the state after fetching topics
                    });
                  });
                },
              ),
            ),
          ],
        ),

        boxH20(),
        // Select Topic
// Select Topic
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.3,
          child: DropdownButtonFormField<String>(
            value: selectedTopic,
            hint: Text("Select Topic"),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(color: Colors.grey.shade400),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            ),
            items: _controller.topics.map<DropdownMenuItem<String>>((topic) {
              return DropdownMenuItem<String>(
                value: topic['topic_name'],
                child: Text(topic['topic_name']),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedTopic = value;
                selectedSubtopic = null; // Reset subtopic when topic changes
                // Fetch subtopics based on the selected topic
                String topicId = _controller.topics.firstWhere((t) => t['topic_name'] == value)['_id'];
                _controller.get_SubTopic(topicId: topicId, categoryId: mainCategoryId.toString(), sub_categoryId: subCategoryId.toString()).then((_) {
                  setState(() {});
                });
              });
            },
          ),
        ),

        // // Select Subtopic
        // DropdownButtonFormField<String>(
        //   value: selectedSubtopic,
        //   hint: Text("Select Subtopic"),
        //   items: _controller.sub_topics.map<DropdownMenuItem<String>>((subtopic) {
        //     return DropdownMenuItem<String>(
        //       value: subtopic['name'],
        //       child: Text(subtopic['name']),
        //     );
        //   }).toList(),
        //   onChanged: (value) {
        //     setState(() {
        //       selectedSubtopic = value;
        //     });
        //   },
        // ),

      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isWideScreen = constraints.maxWidth > 800;

          return Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (isWideScreen)
                Container(
                  width: 250,
                  color: Colors.orange.shade100,
                  child: const MyDrawer(),
                ),
              Expanded(
                child: Scaffold(
                  backgroundColor: Colors.grey.shade100,
                  appBar: isWideScreen
                      ? null
                      : AppBar(
                          title: const Text('Dashboard'),
                          backgroundColor: Colors.blue.shade100,
                        ),
                  drawer: isWideScreen ? null : Drawer(child: const MyDrawer()),
                  body: Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.9,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Conversational English',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.orange.shade800,
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  _buildTabs(),
                                  SizedBox(height: 20),
                                  _buildQuestionsTable(),
                                ],
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              flex: 1,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.18,
                                        child: DropdownButtonFormField<String>(
                                          value: selectedQuestionType,
                                          dropdownColor: Colors.grey.shade50,
                                          decoration: InputDecoration(
                                            labelText: "Select Question Type",
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            filled: true,
                                            fillColor: Colors.white,
                                          ),
                                          items: questionTypes
                                              .map((type) => DropdownMenuItem(
                                                    value: type,
                                                    child: Text(type),
                                                  ))
                                              .toList(),
                                          onChanged: (value) {
                                            setState(() {
                                              selectedQuestionType = value;
                                            });
                                          },
                                        ),
                                      ),
                                      const Spacer(),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.05,
                                        child: CustomTextField(
                                          controller: pointsController,
                                          maxLines: 1,
                                          labelText: "Points",
                                        ),
                                      ),
                                    ],
                                  ),
                                  boxH10(),
                                  // Display the appropriate question type UI based on selection
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.4,
                                      height:
                                          MediaQuery.of(context).size.width *
                                              0.4,
                                      child: _buildQuestionTypeContent()),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }



  // Widget _buildTabs() {
  //   return DropdownButtonFormField<String>(
  //     value: selectedMainCategory,
  //     hint: Text("Select Main Category"),
  //     items: _controller.categories.map((category) => DropdownMenuItem<String>(
  //       value: category.toString(),  // Explicitly cast to String
  //       child: Text(  category['category_name'].toString()),
  //     ))
  //         .toList(),
  //     onChanged: (value) {
  //       setState(() {
  //         selectedMainCategory = value;
  //       });
  //     },
  //   );
  // }


  // Widget _buildTabs() {
  //   return SizedBox(
  //     width: double.infinity,
  //     child: Card(
  //       color: Colors.white,
  //       elevation: 1.0,
  //       child: Padding(
  //         padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
  //         child: Wrap(
  //           spacing: 8.0,
  //           runSpacing: 8.0,
  //           children: List.generate(tabs.length, (index) {
  //             final bool isActive = index == selectedIndex;
  //             return Container(
  //               width: MediaQuery.of(context).size.width * 0.16,
  //               height: MediaQuery.of(context).size.width * 0.04,
  //               margin: const EdgeInsets.symmetric(vertical: 5),
  //               decoration: BoxDecoration(
  //                 color: isActive ? Colors.orange.shade100 : Colors.white,
  //                 borderRadius: BorderRadius.circular(8),
  //                 border: Border.all(
  //                   color: isActive ? Colors.orange : Colors.grey,
  //                   width: 1,
  //                 ),
  //                 boxShadow: isActive
  //                     ? [
  //                         BoxShadow(
  //                           color: Colors.orange.withOpacity(0.3),
  //                           blurRadius: 5,
  //                           offset: const Offset(0, 3),
  //                         )
  //                       ]
  //                     : [],
  //               ),
  //               child: TextButton(
  //                 onPressed: () {
  //                   setState(() {
  //                     selectedIndex = index;
  //                   });
  //                 },
  //                 style: TextButton.styleFrom(
  //                   padding: const EdgeInsets.symmetric(
  //                     vertical: 12,
  //                     horizontal: 20,
  //                   ),
  //                   shape: RoundedRectangleBorder(
  //                     borderRadius: BorderRadius.circular(8),
  //                   ),
  //                 ),
  //                 child: Text(
  //                   tabs[index],
  //                   style: TextStyle(
  //                     color: isActive ? Colors.black : Colors.grey.shade700,
  //                     fontWeight: FontWeight.bold,
  //                     fontSize: 16,
  //                   ),
  //                 ),
  //               ),
  //             );
  //           }),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  ///
  // Widget _buildQuestionsTable() {
  //   return Card(
  //     elevation: 1.0,
  //     color: Colors.white,
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.circular(8),
  //     ),
  //     child: Container(
  //       padding: const EdgeInsets.all(16.0),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Row(
  //             children: [
  //               const Text(
  //                 'Question Data',
  //                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
  //               ),
  //               const Spacer(),
  //
  //               CircleAvatar(
  //                 backgroundColor: Colors.orange.shade100,
  //                 child: IconButton(
  //                   icon: Image.asset('assets/excel.png', width: 24, height: 24),
  //                   onPressed: _exportTableToCSV,
  //                   tooltip: 'Import Excel Data',
  //                 ),
  //               )
  //             ],
  //           ),
  //           SizedBox(height: 10),
  //           Table(
  //             border: TableBorder.all(
  //               color: Colors.grey.shade300,
  //               borderRadius: BorderRadius.circular(8),
  //             ),
  //             columnWidths: const {
  //               0: FlexColumnWidth(1),
  //               1: FlexColumnWidth(2),
  //               2: FlexColumnWidth(1),
  //               3: FlexColumnWidth(1),
  //               4: FlexColumnWidth(1),
  //               5: FlexColumnWidth(1),
  //               6: FlexColumnWidth(1),
  //             },
  //             children: [
  //               TableRow(
  //                 decoration: BoxDecoration(
  //                   color: Colors.orange.shade100,
  //                   borderRadius: BorderRadius.circular(8),
  //                 ),
  //                 children: [
  //                   _buildTableHeader("Type"),
  //                   _buildTableHeader("Question"),
  //                   _buildTableHeader("Option 1"),
  //                   _buildTableHeader("Option 2"),
  //                   _buildTableHeader("Option 3"),
  //                   _buildTableHeader("Option 4"),
  //                   _buildTableHeader("Answer"),
  //                 ],
  //               ),
  //               ...tableRows,
  //             ],
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
  //
  // Widget _buildTableHeader(String title) {
  //   return Padding(
  //     padding: const EdgeInsets.all(8.0),
  //     child: Text(
  //       title,
  //       style: const TextStyle(
  //         fontWeight: FontWeight.bold,
  //         fontSize: 16,
  //       ),
  //       textAlign: TextAlign.center,
  //     ),
  //   );
  // }
  Widget _buildQuestionsTable() {
    return Card(
      elevation: 1.0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Question Data',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const Spacer(),

                CircleAvatar(
                  backgroundColor: Colors.orange.shade100,
                  child: IconButton(
                    icon: Image.asset('assets/excel.png', width: 24, height: 24),
                    onPressed: _exportTableToCSV,
                    tooltip: 'Export to Excel',
                  ),
                )
              ],
            ),
            SizedBox(height: 10),
            Table(
              border: TableBorder.all(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(8),
              ),
              columnWidths: const {
                0: FlexColumnWidth(1),  // Type
                1: FlexColumnWidth(2),  // Question
                2: FlexColumnWidth(1),  // Option 1
                3: FlexColumnWidth(1),  // Option 2
                4: FlexColumnWidth(1),  // Option 3
                5: FlexColumnWidth(1),  // Option 4
                6: FlexColumnWidth(1),  // Answer
                7: FlexColumnWidth(1),  // Points
                8: FlexColumnWidth(1),  // Main Category ID
                9: FlexColumnWidth(1),  // Sub Category ID
                10: FlexColumnWidth(1), // Topic ID
                11: FlexColumnWidth(1), // Sub Topic ID
                12: FlexColumnWidth(1), // Question Type
                13: FlexColumnWidth(1), // Title
                14: FlexColumnWidth(1), // Question Image
              },
              children: [
                TableRow(
                  decoration: BoxDecoration(
                    color: Colors.orange.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  children: [
                    _buildTableHeader("Type"),
                    _buildTableHeader("Question"),
                    _buildTableHeader("Option 1"),
                    _buildTableHeader("Option 2"),
                    _buildTableHeader("Option 3"),
                    _buildTableHeader("Option 4"),
                    _buildTableHeader("Answer"),
                    _buildTableHeader("Points"),
                    _buildTableHeader("Main Category ID"),
                    _buildTableHeader("Sub Category ID"),
                    _buildTableHeader("Topic ID"),
                    _buildTableHeader("Sub Topic ID"),
                    _buildTableHeader("Question Type"),
                    _buildTableHeader("Title"),
                    _buildTableHeader("Question Image"),
                  ],
                ),
                ...tableRows,
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTableHeader(String title) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }


  ///question type content
  Widget _buildQuestionTypeContent() {
    switch (selectedQuestionType) {
      case "Multiple Choice Question":
        return _buildMultipleChoiceQueContent();
      case "Complete the Word":
        return _buildCompleteWordContent();
      case "Re-Arrange the Word":
        return _reArrangeWord();
      case "True/False":
        return _buildTrueFalseContent();
      case "Story":
        return _buildStoryContent();
      case "Phrases":
        return _buildPhrasesContent();
      case "Conversation":
        return _buildConversationContent();
        case "Fill in the blanks":
        return _buildFillInTheBlanksContent();
        case "Match the pairs":
        return AddMatchPairs();
        case "Complete the paragraph":
        return _buildCompleteTheParagraphContent();
      default:
        return Container();
    }
  }

  void _submitQuestion() {
    // Create a list to hold the options or default values ("-")
    final List<String> options = optionControllers
        .map((controller) => controller.text.isNotEmpty ? controller.text : "-")
        .toList();

    // Add a new table row with data or default values ("-")
    tableRows.add(TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(selectedQuestionType ?? "-"),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(questionController.text.isNotEmpty
              ? questionController.text
              : "-"),
        ),
        ...options.map((option) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(option),
            )),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(correctAnswerController.text.isNotEmpty
              ? correctAnswerController.text
              : "-"),
        ),
      ],
    ));

    // Clear the input fields after submission
    setState(() {
      questionController.clear();
      optionControllers.forEach((controller) => controller.clear());
      correctAnswerController.clear();
    });
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  Widget _buildMultipleChoiceQueContent() {
    return DottedBorder(
      color: Colors.orange,
      strokeWidth: 1,
      dashPattern: [4, 4],
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Question',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            boxH08(),
            CustomTextField(
              controller: questionController,
              maxLines: 1,
              labelText: "Enter your question",
            ),
            boxH10(),
            const Text(
              'Upload Story Image',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _pickImage,
              child: DottedBorder(
                color: Colors.grey,
                strokeWidth: 1,
                dashPattern: [4, 4],
                child: Container(
                  width: double.infinity,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: selectedImage == null
                        ? const Text(
                      "Tap to upload story image",
                      style: TextStyle(color: Colors.grey),
                    )
                        : Image.memory(
                      selectedImage!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                ),
              ),
            ),
            boxH15(),
            const Text(
              'Enter Options',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            boxH08(),
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Number of items per row
                crossAxisSpacing: 10.0, // Spacing between columns
                mainAxisSpacing: 5.0, // Spacing between rows
                childAspectRatio: 2.8, // Adjust height and width of grid items
              ),
              itemCount: optionControllers.length,
              itemBuilder: (context, index) {
                return CustomTextField(
                  controller: optionControllers[index],
                  labelText: "Option ${index + 1}",
                );
              },
            ),
            const Text(
              'Correct answer',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            boxH08(),
            CustomTextField(
              controller: correctAnswerController,
              labelText: "Enter correct answer",
            ),
            boxH15(),
            CustomButton(
              label: "Add Question",
              onPressed: _submitQuestion,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrueFalseContent() {
    // Implement the UI for "True/False" question type
    return DottedBorder(
      color: Colors.orange,
      strokeWidth: 1,
      dashPattern: [4, 4],
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text(
              'Enter true false question:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            boxH20(),
            CustomTextField(
              controller: questionController,
              maxLines: 1,
              labelText: "Enter your question",
            ),
            boxH20(),
            const Text(
              'Upload Story Image',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _pickImage,
              child: DottedBorder(
                color: Colors.grey,
                strokeWidth: 1,
                dashPattern: [4, 4],
                child: Container(
                  width: double.infinity,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: selectedImage == null
                        ? const Text(
                      "Tap to upload story image",
                      style: TextStyle(color: Colors.grey),
                    )
                        : Image.memory(
                      selectedImage!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                ),
              ),
            ),
            boxH20(),
            CustomTextField(
              controller: correctAnswerController,
              labelText: "Enter correct answer",
            ),
            const SizedBox(height: 20),
            CustomButton(
              label: "Add Question",
              onPressed: _submitQuestion,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompleteWordContent() {
    // Implement the UI for "Complete the Word" question type
    return DottedBorder(
      color: Colors.orange,
      strokeWidth: 1,
      dashPattern: [4, 4],
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Enter your question',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            boxH08(),
            CustomTextField(
              controller: questionController,
              maxLines: 1,
              labelText: "Enter your question (e.g:- C_t, Man_o)",
            ),
            boxH20(),
            const Text(
              'Enter Options (e.g:- a, b, c)',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            boxH08(),
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Number of items per row
                crossAxisSpacing: 10.0, // Spacing between columns
                mainAxisSpacing: 5.0, // Spacing between rows
                childAspectRatio: 2.8, // Adjust height and width of grid items
              ),
              itemCount: optionControllers.length,
              itemBuilder: (context, index) {
                return CustomTextField(
                  controller: optionControllers[index],
                  labelText: "Option ${index + 1}",
                );
              },
            ),
            const Text(
              'Enter correct answer',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            boxH08(),
            CustomTextField(
              controller: correctAnswerController,
              labelText: "Enter correct answer",
            ),
            const SizedBox(height: 20),
            CustomButton(
              label: "Add Question",
              onPressed: _submitQuestion,
            ),
          ],
        ),
      ),
    ); // Placeholder for the actual implementation
  }

  Widget _buildStoryContent() {
    // Implement the UI for "Story" question type
    return DottedBorder(
      color: Colors.orange,
      strokeWidth: 1,
      dashPattern: [4, 4],
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Enter Story title',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            boxH08(),
            CustomTextField(
              controller: questionController,
              maxLines: 1,
              labelText: "Enter Story title",
            ),
            boxH20(),
            const Text(
              'Upload Story Image',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _pickImage,
              child: DottedBorder(
                color: Colors.grey,
                strokeWidth: 1,
                dashPattern: [4, 4],
                child: Container(
                  width: double.infinity,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: selectedImage == null
                        ? const Text(
                      "Tap to upload story image",
                      style: TextStyle(color: Colors.grey),
                    )
                        : Image.memory(
                      selectedImage!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                ),
              ),
            ),
            boxH20(),
            const Text(
              'Enter Story Content',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            boxH08(),
            CustomTextField(
              controller: storyContentController,
              labelText: "Enter story content",
              maxLines: 6,
            ),
            boxH20(),
            CustomButton(
              label: "Add Question",
              onPressed: _submitQuestion,
            ),
          ],
        ),
      ),
    ); // Placeholder for the actual implementation
  }

  Widget _reArrangeWord() {
    // Implement the UI for "Story" question type
    return DottedBorder(
      color: Colors.orange,
      strokeWidth: 1,
      dashPattern: [4, 4],
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Enter title',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            boxH08(),
            CustomTextField(
              controller: questionController,
              maxLines: 1,
              labelText: "Enter title",
            ),
            boxH10(),
            const Text(
              'Enter the re-arrange word/sentence',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            boxH08(),
            CustomTextField(
              controller: questionController,
              maxLines: 1,
              labelText: "Enter the re-arrange word/sentence",
            ),
            boxH10(),
            const Text(
              'Upload Story Image',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _pickImage,
              child: DottedBorder(
                color: Colors.grey,
                strokeWidth: 1,
                dashPattern: [4, 4],
                child: Container(
                  width: double.infinity,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: selectedImage == null
                        ? const Text(
                      "Tap to upload story image",
                      style: TextStyle(color: Colors.grey),
                    )
                        : Image.memory(
                      selectedImage!,
                      fit: BoxFit.fill,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                ),
              ),
            ),
            boxH50(),
            CustomButton(
              label: "Add Question",
              onPressed: _submitQuestion,
            ),
          ],
        ),
      ),
    ); // Placeholder for the actual implementation
  }

  Widget _buildConversationContent() {
    // Implement the UI for "Conversation" question type
    return DottedBorder(
      color: Colors.orange,
      strokeWidth: 1,
      dashPattern: [4, 4],
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Enter conversation question',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            boxH08(),
            CustomTextField(
              controller: questionController,
              maxLines: 1,
              labelText: "Enter question",
            ),
            boxH20(),
            const Text(
              'Enter correct answer',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            boxH08(),
            CustomTextField(
              controller: correctAnswerController,
              labelText: "Enter correct answer",
            ),
            boxH20(),
            CustomButton(
              label: "Add Question",
              onPressed: _submitQuestion,
            ),
          ],
        ),
      ),
    ); // Placeholder for the actual implementation
  }

  Widget _buildPhrasesContent() {
    // Implement the UI for "Phrases" question type
    return DottedBorder(
      color: Colors.orange,
      strokeWidth: 1,
      dashPattern: [4, 4],
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Enter Story phrases',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            boxH08(),
            CustomTextField(
              controller: storyPhrasesController,
              labelText: "Enter story phrases",
              maxLines: 1,
            ),
            boxH20(),
            const Text(
              'Enter correct answer',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            boxH08(),
            CustomTextField(
              controller: correctAnswerController,
              labelText: "Enter correct answer",
            ),
            boxH20(),
            CustomButton(
              label: "Add Question",
              onPressed: _submitQuestion,
            ),
          ],
        ),
      ),
    ); // Placeholder for the actual implementation
  }

  Widget _buildFillInTheBlanksContent() {
    // Implement the UI for "Phrases" question type
    return DottedBorder(
      color: Colors.orange,
      strokeWidth: 1,
      dashPattern: [4, 4],
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title and Points Row
              const Text(
                'Question title:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              CustomTextField(
                controller: titleController,
                labelText: 'Enter question title here...',
              ),
              const SizedBox(height: 16),
              const Text(
                'Question:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              CustomTextField(
                controller: questionController,
                labelText: 'Enter your question here...',
                maxLines: 3,
              ),
          
              const SizedBox(height: 16),
              const Text(
                'Question Image (Optional):',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: pickImage,
                child: Container(
                  height: imagePath == null ? 80 : 250,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: imagePath == null
                      ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.image, size: 40),
                      Text('Tap to add image'),
                    ],
                  )
                      : kIsWeb
                      ? Image.network(
                    imagePath!,
                    fit: BoxFit.cover,
                  )
                      : Image.file(
                    File(imagePath!),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              boxH05(),
              const Text(
                'Enter Options',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              boxH08(),
              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Number of items per row
                  crossAxisSpacing: 10.0, // Spacing between columns
                  mainAxisSpacing: 5.0, // Spacing between rows
                  childAspectRatio: 2.8, // Adjust height and width of grid items
                ),
                itemCount: optionControllers.length,
                itemBuilder: (context, index) {
                  return CustomTextField(
                    controller: optionControllers[index],
                    labelText: "Option ${index + 1}",
                  );
                },
              ),
              const Text(
                'Correct answer',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              boxH08(),
              CustomTextField(
                controller: correctAnswerController,
                labelText: "Enter correct answer",
              ),
              boxH15(),
              CustomButton(
                label: "Add Question",
                onPressed: _submitQuestion,
              ),
            ],
          ),
        ),
      ),
    ); // Placeholder for the actual implementation
  }

  Widget _buildCompleteTheParagraphContent() {
    return DottedBorder(
      color: Colors.orange,
      strokeWidth: 1,
      dashPattern: [4, 4],
      child: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Question title',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              boxH08(),
              CustomTextField(
                controller: titleController,
                maxLines: 1,
                labelText: "Enter your question title",
              ),
              boxH10(),
              const Text(
                'Paragraph',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              boxH08(),
              CustomTextField(
                controller: questionController,
                maxLines: 5,
                labelText: "Enter your paragraph",
              ),
              boxH15(),
              const Text(
                'Enter Options',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              boxH08(),
              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Number of items per row
                  crossAxisSpacing: 10.0, // Spacing between columns
                  mainAxisSpacing: 5.0, // Spacing between rows
                  childAspectRatio: 2.8, // Adjust height and width of grid items
                ),
                itemCount: paragraphOptionControllers.length,
                itemBuilder: (context, index) {
                  return CustomTextField(
                    controller: paragraphOptionControllers[index],
                    labelText: "Option ${index + 1}",
                  );
                },
              ),
              const Text(
                "Correct options ',' separated",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              boxH08(),
              CustomTextField(
                controller: correctAnswerController,
                labelText: "",
                hintText:"mouse, bird, snake" ,
              ),
              boxH15(),
              CustomButton(
                label: "Add Question",
                onPressed: _submitQuestion,
              ),
            ],
          ),
        ),
      ),
    );
  }



}

// class _AddQuestionsWidgetsState extends State<AddQuestionsWidgets> {
//   final TextEditingController questionController = TextEditingController();
//   final List<TextEditingController> optionControllers =
//   List.generate(4, (_) => TextEditingController());
//   TextEditingController correctAnswerController = TextEditingController();
//   TextEditingController pointsController = TextEditingController();
//
//   File? selectedImage;
//   List<TableRow> tableRows = [];
//
//   final List<String> tabs = [
//     "Conversational English",
//     "A1",
//     "Greetings",
//     "Story",
//     "Phrases",
//     "Quizzes",
//     "Conversation"
//   ];
//   int selectedIndex = 0;
//
//   String? selectedQuestionType;
//   List<String> questionTypes = [
//     "Multiple Choice Question",
//     "Complete the Word",
//     "True/False",
//     "Story",
//     "Phrases",
//     "Conversation"
//   ];
//   List<Widget> queTypeWidgets = [
//     _buildMultipleChoiceQueContent(constraints),
//     _buildStoryQueContent,
//     _buildPhrasesQueContent,
//     _buildTrueFalseQueContent,
//     _buildConversationContent
//   ];
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey.shade200,
//       body: LayoutBuilder(
//         builder: (context, constraints) {
//           bool isWideScreen = constraints.maxWidth > 800;
//
//           return Row(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               if (isWideScreen)
//                 Container(
//                   width: 250,
//                   color: Colors.orange.shade100,
//                   child: const MyDrawer(),
//                 ),
//               Expanded(
//                 child: Scaffold(
//                   backgroundColor: Colors.grey.shade100,
//                   appBar: isWideScreen
//                       ? null
//                       : AppBar(
//                     title: const Text('Dashboard'),
//                     backgroundColor: Colors.blue.shade100,
//                   ),
//                   drawer: isWideScreen ? null : Drawer(child: const MyDrawer()),
//                   body: Center(
//                     child: SingleChildScrollView(
//                       padding: const EdgeInsets.all(16.0),
//                       child: ConstrainedBox(
//                         constraints: BoxConstraints(
//                           maxWidth: MediaQuery.of(context).size.width * 0.9,
//                         ),
//                         child: Row(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Expanded(
//                               flex: 2,
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     'Conversational English',
//                                     style: TextStyle(
//                                       fontSize: 24,
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.orange.shade800,
//                                     ),
//                                   ),
//                                   SizedBox(height: 16),
//                                   _buildTabs(),
//                                   SizedBox(height: 20),
//                                   _buildQuestionsTable(),
//                                 ],
//                               ),
//                             ),
//                             const SizedBox(width: 20),
//                             Expanded(
//                               flex: 1,
//                               child: Column(
//                                 children: [
//                                   Row(
//                                     children: [
//                                       SizedBox(
//                                         width: MediaQuery.of(context).size.width * 0.18,
//                                         child: DropdownButtonFormField<String>(
//                                           value: selectedQuestionType,
//                                           decoration: InputDecoration(
//                                             labelText: "Select Question Type",
//                                             border: OutlineInputBorder(
//                                               borderRadius: BorderRadius.circular(10),
//                                             ),
//                                             filled: true,
//                                             fillColor: Colors.white,
//                                           ),
//                                           items: questionTypes
//                                               .map((type) => DropdownMenuItem(
//                                             value: type,
//                                             child: Text(type),
//                                           ))
//                                               .toList(),
//                                           onChanged: (value) {
//                                             setState(() {
//                                               selectedQuestionType = value;
//                                             });
//                                           },
//                                         ),
//                                       ),
//                                       const Spacer(),
//                                       SizedBox(
//                                         width: MediaQuery.of(context).size.width * 0.05,
//                                         child: CustomTextField(
//                                           controller: pointsController,
//                                           maxLines: 1,
//                                           labelText: "Points",
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   boxH10(),
//                                   here display the List one by one whenever he choose the quetion type then changes the below ui  here
//                                   _buildMultipleChoiceQueContent(constraints),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
//
//   Widget _buildTabs() {
//     return SizedBox(
//       width: double.infinity,
//       child: Card(
//         color: Colors.white,
//         elevation: 1.0,
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
//           child: Wrap(
//             spacing: 8.0,
//             runSpacing: 8.0,
//             children: List.generate(tabs.length, (index) {
//               final bool isActive = index == selectedIndex;
//               return Container(
//                 width: MediaQuery.of(context).size.width * 0.16,
//                 height: MediaQuery.of(context).size.width * 0.04,
//                 margin: const EdgeInsets.symmetric(vertical: 5),
//                 decoration: BoxDecoration(
//                   color: isActive ? Colors.orange.shade100 : Colors.white,
//                   borderRadius: BorderRadius.circular(8),
//                   border: Border.all(
//                     color: isActive ? Colors.orange : Colors.grey,
//                     width: 1,
//                   ),
//                   boxShadow: isActive
//                       ? [
//                     BoxShadow(
//                       color: Colors.orange.withOpacity(0.3),
//                       blurRadius: 5,
//                       offset: const Offset(0, 3),
//                     )
//                   ]
//                       : [],
//                 ),
//                 child: TextButton(
//                   onPressed: () {
//                     setState(() {
//                       selectedIndex = index;
//                     });
//                   },
//                   style: TextButton.styleFrom(
//                     padding: const EdgeInsets.symmetric(
//                       vertical: 12,
//                       horizontal: 20,
//                     ),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ),
//                   child: Text(
//                     tabs[index],
//                     style: TextStyle(
//                       color: isActive ? Colors.black : Colors.grey.shade700,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 16,
//                     ),
//                   ),
//                 ),
//               );
//             }),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildQuestionsTable() {
//     return Card(
//       elevation: 1.0,
//       color: Colors.white,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Container(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Question Data',
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 10),
//             Table(
//               border: TableBorder.all(
//                 color: Colors.grey.shade300,
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               columnWidths: const {
//                 0: FlexColumnWidth(1),
//                 1: FlexColumnWidth(2),
//                 2: FlexColumnWidth(1),
//                 3: FlexColumnWidth(1),
//                 4: FlexColumnWidth(1),
//                 5: FlexColumnWidth(1),
//                 6: FlexColumnWidth(1),
//               },
//               children: [
//                 TableRow(
//                   decoration: BoxDecoration(
//                     color: Colors.orange.shade100,
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   children: [
//                     _buildTableHeader("Type"),
//                     _buildTableHeader("Question"),
//                     _buildTableHeader("Option 1"),
//                     _buildTableHeader("Option 2"),
//                     _buildTableHeader("Option 3"),
//                     _buildTableHeader("Option 4"),
//                     _buildTableHeader("Answer"),
//                   ],
//                 ),
//                 ...tableRows,
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTableHeader(String title) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Text(
//         title,
//         style: const TextStyle(
//           fontWeight: FontWeight.bold,
//           fontSize: 16,
//         ),
//         textAlign: TextAlign.center,
//       ),
//     );
//   }
//
//   Widget _buildMultipleChoiceQueContent(BoxConstraints constraints) {
//     return DottedBorder(
//       color: Colors.orange,
//       strokeWidth: 1,
//       dashPattern: [4, 4],
//       child: Container(
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(10),
//           color: Colors.white,
//         ),
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             CustomTextField(
//               controller: questionController,
//               maxLines: 1,
//               labelText: "Enter your question",
//             ),
//             const SizedBox(height: 20),
//             DottedBorder(
//               color: Colors .grey,
//               strokeWidth: 1,
//               dashPattern: [4, 4],
//               child: Container(
//                 width: double.infinity,
//                 height: 50,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: const Center(
//                   child: Text(
//                     "Tap to upload image",
//                     style: TextStyle(color: Colors.grey),
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//             const Text(
//               'Options:',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 10),
//             ...List.generate(
//               optionControllers.length,
//                   (index) => Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 8.0),
//                 child: CustomTextField(
//                   controller: optionControllers[index],
//                   labelText: "Option ${index + 1}",
//                 ),
//               ),
//             ),
//             // GestureDetector(
//             //   onTap: () {
//             //     setState(() {
//             //       optionControllers.add(TextEditingController());
//             //     });
//             //   },
//             //   child: Container(
//             //     width: double.infinity,
//             //     padding: const EdgeInsets.all(12.0),
//             //     decoration: BoxDecoration(
//             //       color: Colors.orange.shade100,
//             //       borderRadius: BorderRadius.circular(8),
//             //       border: Border.all(color: Colors.orange),
//             //     ),
//             //     child: const Center(child: Text("Add More Option")),
//             //   ),
//             // ),
//             const SizedBox(height: 20),
//             CustomTextField(
//               controller: correctAnswerController,
//               labelText: "Enter correct answer",
//             ),
//             const SizedBox(height: 20),
//             CustomButton(
//               label: "Add Question",
//               onPressed: _submitQuestion,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   void _submitQuestion() {
//     if (questionController.text.isEmpty) {
//       _showError("Question cannot be empty");
//       return;
//     }
//
//     if (optionControllers.any((controller) => controller.text.isEmpty)) {
//       _showError("All options must be filled");
//       return;
//     }
//
//     if (correctAnswerController.text.isEmpty) {
//       _showError("Correct answer must be specified");
//       return;
//     }
//
//     if (!optionControllers
//         .any((controller) => controller.text == correctAnswerController.text)) {
//       _showError("Correct answer must be one of the options");
//       return;
//     }
//
//     tableRows.add(TableRow(
//       children: [
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Text(selectedQuestionType ?? "N/A"),
//         ),
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Text(questionController.text),
//         ),
//         ...optionControllers.map((controller) => Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Text(controller.text),
//         )),
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Text(correctAnswerController.text),
//         ),
//       ],
//     ));
//
//     setState(() {
//       questionController.clear();
//       optionControllers.forEach((controller) => controller.clear());
//       correctAnswerController.clear();
//     });
//   }
//
//   void _showError(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: Colors.red,
//       ),
//     );
//   }
// }

