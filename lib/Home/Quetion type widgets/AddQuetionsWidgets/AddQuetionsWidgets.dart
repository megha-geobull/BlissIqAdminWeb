import 'dart:convert';
import 'dart:developer';
import 'dart:html' as html;
import 'package:blissiqadmin/Global/Widgets/Button/CustomButton.dart';
import 'package:blissiqadmin/Global/constants/CommonSizedBox.dart';
import 'package:blissiqadmin/Global/constants/CustomTextField.dart';
import 'package:blissiqadmin/Home/Drawer/MyDrawer.dart';
import 'package:blissiqadmin/Home/Quetion%20type%20widgets/QuestionController/QuestionApiController.dart';
import 'package:blissiqadmin/Home/Quetion%20type%20widgets/add_match_the_pairs.dart';
import 'package:blissiqadmin/controller/CategoryController.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:csv/csv.dart';
import 'package:share_extend/share_extend.dart';

import '../../../Global/constants/common_snackbar.dart';
import 'Header_Columns.dart';

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
  TextEditingController storyTitleController = TextEditingController();
  TextEditingController highlightWordController = TextEditingController();
  TextEditingController indexController = TextEditingController();
  TextEditingController optLangController = TextEditingController();

  List<TableRow> tableRows = [];

  final List<String> mainCategories = [];
  final List<String> subCategories = [];
  final List<String> topics = [];
  final List<String> subTopics = [];

  int selectedIndex = 0;
  String? selectedMainCategory;
  String? selectedSubCategory;
  String? selectedTopic;
  String? selectedSubtopic;

  String? mainCategoryId;
  String? subCategoryId;
  String? topicId;
  String? subtopicId;

  List<PlatformFile>? _paths;
  var pathsFile;
  var pathsFileName;

  pickImage() async {
    // Using FilePicker to allow the user to select an image
    _paths = (await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: false,
      onFileLoading: (FilePickerStatus status) => print("status .... $status"),
      allowedExtensions: ['png', 'jpg', 'jpeg', 'heic'],
    ))
        ?.files;

    if (_paths != null && _paths!.isNotEmpty) {
      setState(() {
        pathsFile = _paths!.first.bytes!;
        pathsFileName = _paths!.first.name;
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
    "Learning Slide",
    "Card Flip",
  ];
  final CategoryController _controller = Get.put(CategoryController());
  final QuestionApiController questionApiController =
      Get.put(QuestionApiController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  void _exportTableToCSV() async {
    List<List<dynamic>> rows = [];

    List<String> headers = [];
    if (selectedQuestionType == "Multiple Choice Question") {
      headers = mcq_headers;
    } else if (selectedQuestionType == "Re-Arrange the Word") {
      headers = rearrange_headers;
    } else if (selectedQuestionType == "Complete the Word") {
      headers = rearrange_headers;
    } else if (selectedQuestionType == "True/False") {
      headers = true_false_headers;
    } else if (selectedQuestionType == "Story") {
      headers = story_headers;
    } else if (selectedQuestionType == "Phrases") {
      headers = phrases_headers;
    } else if (selectedQuestionType == "Conversation") {
      headers = conversation_headers;
    } else if (selectedQuestionType == "Learning Slide") {
      headers = learning_slide;
    } else if (selectedQuestionType == "Card Flip") {
      headers = cardFlip_headers;
    }
    rows.add(headers);
    List<dynamic> sampleData = [];
    for (int i = 0; i < 6; i++) {
      // Assuming you want 5 rows of sample data
      List<dynamic> row = [
        '',
        mainCategoryId,
        subCategoryId,
        topicId,
        subtopicId,
      ];

      // Add dynamic placeholders for remaining headers
      for (int j = 6; j < headers.length; j++) {
        row.add('');
      }

      sampleData.add(row);
    }
    rows.add(sampleData);
    String csvData = const ListToCsvConverter().convert(rows);
    if (kIsWeb) {
      log("website file save");
      final bytes = utf8.encode(csvData);
      final blob = html.Blob([bytes]);
      final url = html.Url.createObjectUrlFromBlob(blob);

      final anchor = html.AnchorElement()
        ..href = url
        ..style.display = 'none'
        ..download = '${selectedTopic}-${selectedQuestionType}.csv';

      html.document.body!.children.add(anchor);
      anchor.click();
      html.document.body!.children.remove(anchor);

      html.Url.revokeObjectUrl(url);
    }
  }

  getData() async {
    await _controller.getCategory();
    setState(() {});
  }

  Widget _buildTabs() {
    return Column(
      children: [
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
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                ),
                items: _controller.categories
                    .map<DropdownMenuItem<String>>((category) {
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
                    mainCategoryId = _controller.categories.firstWhere(
                        (cat) => cat['category_name'] == value)['_id'];
                    _controller
                        .getSubCategory(categoryId: mainCategoryId.toString())
                        .then((_) {
                      setState(
                          () {}); // Update the state after fetching subcategories
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
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                ),
                items: _controller.sub_categories
                    .map<DropdownMenuItem<String>>((subCategory) {
                  String subCategoryName =
                      subCategory['sub_category'].toString();
                  return DropdownMenuItem<String>(
                    value: subCategoryName,
                    child: Text(subCategoryName),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedSubCategory = value;
                    selectedTopic =
                        null; // Reset topic when subcategory changes
                    selectedSubtopic = null; // Reset subtopic as well
                    subCategoryId = _controller.sub_categories.firstWhere(
                        (subcategory) =>
                            subcategory['sub_category'] == value)['_id'];
                    print(mainCategoryId.toString());
                    print(subCategoryId.toString());
                    _controller
                        .get_topic(
                            categoryId: mainCategoryId.toString(),
                            sub_categoryId: subCategoryId.toString())
                        .then((_) {
                      setState(() {}); // Update the state after fetching topics
                    });
                  });
                },
              ),
            ),
          ],
        ),

        boxH20(),
        // Select sub Topic
        Row(children: [
          Expanded(
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
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
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
                  topicId = _controller.topics
                      .firstWhere((t) => t['topic_name'] == value)['_id'];
                  _controller
                      .get_SubTopic(
                          topicId: topicId!,
                          categoryId: mainCategoryId.toString(),
                          sub_categoryId: subCategoryId.toString())
                      .then((_) {
                    setState(() {});
                  });
                });
              },
            ),
          ),
          boxW10(),
          // Select Subtopic
          _controller.sub_topics.isNotEmpty
              ? Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedSubtopic,
                    hint: Text("Select SubTopic"),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(color: Colors.grey.shade400),
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                    ),
                    items: _controller.sub_topics
                        .map<DropdownMenuItem<String>>((topic) {
                      return DropdownMenuItem<String>(
                        value: topic['sub_topic_name'],
                        child: Text(topic['sub_topic_name']),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedSubtopic = value;
                        // Fetch subtopics based on the selected subtopic
                        subtopicId = _controller.sub_topics.firstWhere(
                            (t) => t['sub_topic_name'] == value)['_id'];
                        setState(() {});
                      });
                    },
                  ),
                )
              : Expanded(child: SizedBox()),
        ]),
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
                                  Row(
                                    children: [
                                      Text(
                                        'Add questions and other data',
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.orange.shade800,
                                        ),
                                      ),
                                      CircleAvatar(
                                        backgroundColor: Colors.orange.shade100,
                                        child: IconButton(
                                          icon: Image.asset('assets/excel.png',
                                              width: 24, height: 24),
                                          onPressed: () {
                                            print(
                                                "categoryId ${mainCategoryId!}");
                                            print(
                                                "subcategoryId ${subCategoryId!}");
                                            print("topicId ${topicId!}");
                                            print("subtopicId ${subtopicId!}");
                                            if (mainCategoryId!.isNotEmpty &&
                                                subCategoryId!.isNotEmpty &&
                                                topicId!.isNotEmpty) {
                                              _exportTableToCSV();
                                            } else {
                                              showSnackbar(
                                                  message:
                                                      "Please select category,subcategory,topic,etc");
                                            }
                                          },
                                          tooltip: 'Export to Excel',
                                        ),
                                      )
                                    ],
                                  ),
                                  boxH15(),
                                  _buildTabs(),
                                  boxH20(),
                                  _buildQuestionsTable(),
                                ],
                              ),
                            ),
                            boxH20(),
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
                                                0.06,
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
                    icon:
                        Image.asset('assets/excel.png', width: 24, height: 24),
                    onPressed: () {
                      print("categoryId " + mainCategoryId!);
                      print("subcategoryId " + subCategoryId!);
                      print("topicId " + topicId!);
                      print("subtopicId " + subtopicId!);
                      if (mainCategoryId!.isNotEmpty &&
                          subCategoryId!.isNotEmpty &&
                          topicId!.isNotEmpty)
                        _exportTableToCSV();
                      else
                        showSnackbar(
                            message:
                                "Please select category,subcategory,topic,etc");
                    },
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
                0: FlexColumnWidth(1), // Type
                1: FlexColumnWidth(2), // Question
                2: FlexColumnWidth(1), // Option 1
                3: FlexColumnWidth(1), // Option 2
                4: FlexColumnWidth(1), // Option 3
                5: FlexColumnWidth(1), // Option 4
                6: FlexColumnWidth(1), // Answer
                7: FlexColumnWidth(1), // Points
                8: FlexColumnWidth(1), // Main Category ID
                9: FlexColumnWidth(1), // Sub Category ID
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
        return AddMatchPairs(
            pointsController: pointsController,
            sub_topic_id: subtopicId,
            topic_id: topicId,
            sub_category_id: subCategoryId,
            main_category_id: mainCategoryId);
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

    /// Add a new table row with data or default values ("-")
    // tableRows.add(TableRow(
    //   children: [
    //     Padding(
    //       padding: const EdgeInsets.all(8.0),
    //       child: Text(selectedQuestionType ?? "-"),
    //     ),
    //     Padding(
    //       padding: const EdgeInsets.all(8.0),
    //       child: Text(questionController.text.isNotEmpty
    //           ? questionController.text
    //           : "-"),
    //     ),
    //     ...options.map((option) => Padding(
    //           padding: const EdgeInsets.all(8.0),
    //           child: Text(option),
    //         )),
    //     Padding(
    //       padding: const EdgeInsets.all(8.0),
    //       child: Text(correctAnswerController.text.isNotEmpty
    //           ? correctAnswerController.text
    //           : "-"),
    //     ),
    //   ],
    // ));

    // Clear the input fields after submission

    // _handleApiCall();
    setState(() {
      questionController.clear();
      optionControllers.forEach((controller) => controller.clear());
      correctAnswerController.clear();
      pointsController.clear();
      titleController.clear();
      storyContentController.clear();
      storyPhrasesController.clear();
      indexController.clear();
    });
  }

  void _handleApiCall() {
    switch (selectedQuestionType) {
      case "Re-Arrange the Word":
        int pointsValue = int.tryParse(pointsController.text) ?? 0;
        questionApiController.addRearrangeApi(
            mainCategoryId: mainCategoryId.toString(),
            subCategoryId: subCategoryId.toString(),
            topicId: topicId.toString(),
            subTopicId: subtopicId.toString(),
            questionType: selectedQuestionType.toString(),
            title: titleController.text,
            question: questionController.text,
            answer: correctAnswerController.text,
            points: pointsValue.toString(),
            qImage: pathsFile,
            index: indexController.text);
        break;
      case "True/False":
        int pointsValue = int.tryParse(pointsController.text) ?? 0;
        questionApiController.addTrueFalseApi(
            mainCategoryId: mainCategoryId.toString(),
            subCategoryId: subCategoryId.toString(),
            topicId: topicId.toString(),
            subTopicId: subtopicId.toString(),
            questionType: selectedQuestionType.toString(),
            question: questionController.text,
            answer: correctAnswerController.text,
            points: pointsValue.toString(),
            qImage: pathsFile,
            index: indexController.text);
        break;
      case "Fill in the blanks":
        int pointsValue = int.tryParse(pointsController.text) ?? 0;
        questionApiController.addFillBlanks(
            mainCategoryId: mainCategoryId.toString(),
            subCategoryId: subCategoryId.toString(),
            topicId: topicId.toString(),
            subTopicId: subtopicId.toString(),
            questionType: selectedQuestionType.toString(),
            title: titleController.text,
            question: questionController.text,
            qImage: pathsFile,
            optionA: optionControllers[0].text,
            optionB: optionControllers[1].text,
            optionC: optionControllers[2].text,
            optionD: optionControllers[3].text,
            answer: correctAnswerController.text,
            points: pointsValue.toString(),
            index: indexController.text,
            optionLanguage: '',
            questionLanguage: '');
        break;
      default:
        Container();
    }
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
        padding: const EdgeInsets.symmetric(vertical: 7.0, horizontal: 8.0),
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
              onTap: pickImage,
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
                  child: pathsFile != null
                      ? Image.memory(
                          pathsFile,
                          height: 100,
                          width: 100,
                          fit: BoxFit.fitHeight,
                        )
                      : Container(),
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

  /// Re-arrange the word
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
              'Enter index',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            boxH08(),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.08,
              child: CustomTextField(
                controller: indexController,
                maxLines: 1,
                labelText: "Enter index",
              ),
            ),
            boxH10(),
            const Text(
              'Enter title',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            boxH08(),
            CustomTextField(
              controller: titleController,
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
              'Upload Question Image',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            boxH08(),
            GestureDetector(
              onTap: pickImage,
              child: DottedBorder(
                color: Colors.grey,
                strokeWidth: 1,
                dashPattern: [4, 4],
                child: Container(
                  width: double.infinity,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: pathsFile != null
                      ? Image.memory(
                          pathsFile,
                          height: 100,
                          width: 100,
                          fit: BoxFit.fitHeight,
                        )
                      : Container(),
                ),
              ),
            ),
            boxH10(),
            const Text(
              'Enter the correct answer',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            boxH08(),
            CustomTextField(
              controller: correctAnswerController,
              maxLines: 1,
              labelText: "Correct answer",
            ),
            boxH50(),
            CustomButton(
              label: "Add Question",
              onPressed: () {
                int pointsValue = int.tryParse(pointsController.text) ?? 0;
                questionApiController.addRearrangeApi(
                    mainCategoryId: mainCategoryId.toString(),
                    subCategoryId: subCategoryId.toString(),
                    topicId: topicId.toString(),
                    subTopicId: subtopicId.toString(),
                    questionType: selectedQuestionType.toString(),
                    title: titleController.text,
                    question: questionController.text,
                    answer: correctAnswerController.text,
                    points: pointsValue.toString(),
                    qImage: pathsFile,
                    index: indexController.text);
              },
            ),
          ],
        ),
      ),
    ); // Placeholder for the actual implementation
  }

  /// true false content
  Widget _buildTrueFalseContent() {
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
              'Enter index',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            boxH08(),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.08,
              child: CustomTextField(
                controller: indexController,
                maxLines: 1,
                labelText: "Enter index",
              ),
            ),
            boxH20(),
            const Text(
              'Enter your question',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            boxH08(),
            CustomTextField(
              controller: questionController,
              maxLines: 1,
              labelText: "Enter your question",
            ),
            boxH20(),
            const Text(
              'Upload Image',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: pickImage,
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
                  child: pathsFile != null
                      ? Image.memory(
                          pathsFile!,
                          height: 100,
                          width: 100,
                          fit: BoxFit.fitHeight,
                        )
                      : Container(),
                ),
              ),
            ),
            boxH20(),
            const Text(
              'Enter correct answer',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            boxH08(),
            CustomTextField(
              controller: correctAnswerController,
              labelText: "Enter correct answer (True/False)",
            ),
            const SizedBox(height: 20),
            CustomButton(
              label: "Add Question",
              onPressed: () {
                int pointsValue = int.tryParse(pointsController.text) ?? 0;
                questionApiController.addTrueFalseApi(
                  mainCategoryId: mainCategoryId.toString(),
                  subCategoryId: subCategoryId.toString(),
                  topicId: topicId.toString(),
                  subTopicId: subtopicId.toString(),
                  questionType: selectedQuestionType.toString(),
                  question: questionController.text,
                  answer: correctAnswerController.text,
                  points: pointsValue.toString(),
                  qImage: pathsFile,
                  index: indexController.text,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Story content
  Widget _buildStoryContent() {
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
              'Enter index',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            boxH08(),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.08,
              child: CustomTextField(
                controller: indexController,
                maxLines: 1,
                labelText: "Enter index",
              ),
            ),
            boxH15(),
            const Text(
              'Enter Story Title',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            boxH08(),
            CustomTextField(
              controller: storyTitleController,
              maxLines: 1,
              labelText: "Enter Story Title",
            ),
            boxH20(),
            const Text(
              'Upload Story Image',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: pickImage,
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
                  child: pathsFile != null
                      ? Image.memory(
                          pathsFile!,
                          height: 80,
                          width: 100,
                          fit: BoxFit.fitHeight,
                        )
                      : Container(),
                ),
              ),
            ),
            boxH15(),
            const Text(
              'Enter Story Content',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            boxH08(),
            CustomTextField(
              controller: storyContentController,
              labelText: "Enter Story Content",
              maxLines: 4,
            ),
            boxH15(),
            const Text(
              'Highlight Word',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            boxH08(),
            CustomTextField(
              controller: highlightWordController,
              labelText: "Enter Highlight Word",
              maxLines: 1,
            ),
            boxH15(),
            CustomButton(
              label: "Add Story",
              onPressed: () {
                int pointsValue = int.tryParse(pointsController.text) ?? 0;
                questionApiController.addStoryApi(
                  mainCategoryId: mainCategoryId.toString(),
                  subCategoryId: subCategoryId.toString(),
                  topicId: topicId.toString(),
                  subTopicId: subtopicId.toString(),
                  storyTitle: storyTitleController.text,
                  content: storyContentController.text,
                  highlightWord: highlightWordController.text,
                  story_img: pathsFile,
                  points: pointsValue.toString(),
                  index: indexController.text,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Fill in the blanks
  Widget _buildFillInTheBlanksContent() {
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
              const Text(
                'Enter index',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              boxH08(),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.08,
                child: CustomTextField(
                  controller: indexController,
                  maxLines: 1,
                  labelText: "Enter index",
                ),
              ),
              boxH10(),
              const Text(
                'Enter title',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              boxH08(),
              CustomTextField(
                controller: titleController,
                maxLines: 1,
                labelText: "Enter title",
              ),
              boxH10(),
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
                child: DottedBorder(
                  color: Colors.grey,
                  strokeWidth: 1,
                  dashPattern: [4, 4],
                  child: Container(
                    width: double.infinity,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: pathsFile != null
                        ? Image.memory(
                            pathsFile!,
                            height: 100,
                            width: 100,
                            fit: BoxFit.fitHeight,
                          )
                        : Container(),
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
                  crossAxisCount: 2,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 5.0,
                  childAspectRatio: 2.8,
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
              boxH08(),
              const Text(
                'Option language',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              boxH08(),
              CustomTextField(
                controller: optLangController,
                labelText: "Enter option language",
              ),
              boxH15(),
              CustomButton(
                label: "Add Question",
                onPressed: () {
                  int pointsValue = int.tryParse(pointsController.text) ?? 0;
                  questionApiController.addFillBlanks(
                      mainCategoryId: mainCategoryId.toString(),
                      subCategoryId: subCategoryId.toString(),
                      topicId: topicId.toString(),
                      subTopicId: subtopicId.toString(),
                      questionType: selectedQuestionType.toString(),
                      title: titleController.text,
                      question: questionController.text,
                      qImage: pathsFile,
                      answer: correctAnswerController.text,
                      points: pointsValue.toString(),
                      index: indexController.text,
                      optionA: optionControllers[0].text,
                      optionB: optionControllers[1].text,
                      optionC: optionControllers[2].text,
                      optionD: optionControllers[3].text,
                      optionLanguage: optLangController.text,
                      questionLanguage: '');
                },
              ),
            ],
          ),
        ),
      ),
    );
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
              'Enter index',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            boxH08(),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.08,
              child: CustomTextField(
                controller: indexController,
                maxLines: 1,
                labelText: "Enter index",
              ),
            ),
            boxH10(),
            const Text(
              'Enter title',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            boxH08(),
            CustomTextField(
              controller: titleController,
              maxLines: 1,
              labelText: "Enter title",
            ),
            boxH10(),
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
              'Enter index',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            boxH08(),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.08,
              child: CustomTextField(
                controller: indexController,
                maxLines: 1,
                labelText: "Enter index",
              ),
            ),
            boxH10(),
            const Text(
              'Enter title',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            boxH08(),
            CustomTextField(
              controller: titleController,
              maxLines: 1,
              labelText: "Enter title",
            ),
            boxH10(),
            const Text(
              'Enter Phrase Name',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            boxH08(),
            CustomTextField(
              controller: storyPhrasesController,
              labelText: "Enter Phrase Name",
              maxLines: 1,
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

  Widget _buildCompleteWordContent() {
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
                'Enter index',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              boxH08(),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.08,
                child: CustomTextField(
                  controller: indexController,
                  maxLines: 1,
                  labelText: "Enter index",
                ),
              ),
              boxH10(),
              const Text(
                'Enter title',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              boxH08(),
              CustomTextField(
                controller: titleController,
                maxLines: 1,
                labelText: "Enter title",
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
                  childAspectRatio:
                      2.8, // Adjust height and width of grid items
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
                hintText: "mouse, bird, snake",
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
