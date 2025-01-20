import 'dart:convert';
import 'dart:developer';
import 'dart:html' as html;
import 'package:blissiqadmin/Global/Widgets/Button/CustomButton.dart';
import 'package:blissiqadmin/Global/constants/ApiString.dart';
import 'package:blissiqadmin/Global/constants/CommonSizedBox.dart';
import 'package:blissiqadmin/Global/constants/CustomTextField.dart';
import 'package:blissiqadmin/Home/Drawer/MyDrawer.dart';
import 'package:blissiqadmin/Home/Quetion%20type%20widgets/BuildAlphabetExContent.dart';
import 'package:blissiqadmin/Home/Quetion%20type%20widgets/BuildCardFlipContent.dart';
import 'package:blissiqadmin/Home/Quetion%20type%20widgets/BuildLearningSlideContent.dart';
import 'package:blissiqadmin/Home/Quetion%20type%20widgets/QuestionController/QuestionApiController.dart';
import 'package:blissiqadmin/Home/Quetion%20type%20widgets/add_match_the_pairs.dart';
import 'package:blissiqadmin/Home/Quetion%20type%20widgets/controller/GetAllQuestionsApiController.dart';
import 'package:blissiqadmin/Home/Quetion%20type%20widgets/question_controller.dart';
import 'package:blissiqadmin/controller/CategoryController.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:csv/csv.dart';
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
  TextEditingController storyContentController = TextEditingController();
  TextEditingController storyTitleController = TextEditingController();
  TextEditingController highlightWordController = TextEditingController();
  TextEditingController indexController = TextEditingController();
  TextEditingController optLangController = TextEditingController();
  TextEditingController queLangController = TextEditingController();

  TextEditingController phraseNameController = TextEditingController();

  TextEditingController titleController = TextEditingController();

  TextEditingController botConversationController = TextEditingController();
  TextEditingController userConversationController = TextEditingController();

  List<String> userConversationTypes = ['Text', 'Question'];
  String? selectedUserConversationType;

  TextEditingController storyPhrasesController = TextEditingController();
  QuestionController addQuestionController = Get.find();

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
    "Quiz's",
    "Conversation"
  ];

  int selectedIndex = 0;
  String? selectedMainCategory;
  String? selectedSubCategory;
  String? selectedTopic;
  String? selectedSubtopic;

  String mainCategoryId = '';
  String subCategoryId = '';
  String topicId = '';
  String subtopicId = '';


  // late List<Map<String, dynamic>> entries;

  String? imagePath;
  final ImagePicker _picker = ImagePicker();
  // Function to pick an image from the gallery
  Future<void> pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        imagePath = pickedFile.path;
      });
    }
  }


  List<PlatformFile>? _paths;
  var pathsFile;
  var pathsFileName;

  // List<PlatformFile>? _paths;
  // var pathsFile;
  // var pathsFileName;

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
    "Alphabets Example",
  ];

  final CategoryController _controller = Get.put(CategoryController());

  final QuestionApiController questionApiController =
      Get.put(QuestionApiController());

  final GetAllQuestionsApiController _getAllQuestionsApiController = Get.find();
  late ScrollController _scrollController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
    _scrollController = ScrollController();
  }

  pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: false,
      onFileLoading: (FilePickerStatus status) => print("status .... $status"),
      allowedExtensions: ['png', 'jpg', 'jpeg', 'heic'],
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _paths = result.files;
        pathsFile = _paths!.first.bytes;
        pathsFileName = _paths!.first.name;
      });
    } else {
      print('No file selected');
    }
  }

  // pickImage() async {
  //   // Using FilePicker to allow the user to select an image
  //   _paths = (await FilePicker.platform.pickFiles(
  //     type: FileType.custom,
  //     allowMultiple: false,
  //     onFileLoading: (FilePickerStatus status) => print("status .... $status"),
  //     allowedExtensions: ['png', 'jpg', 'jpeg', 'heic'],
  //   ))
  //       ?.files;
  //
  //   if (_paths != null && _paths!.isNotEmpty) {
  //     setState(() {
  //       pathsFile = _paths!.first.bytes!;
  //       pathsFileName = _paths!.first.name;
  //     });
  //   }
  // }

  void _exportTableToCSV() async {
    List<List<dynamic>> rows = [];

    // Set the headers based on the selected question type
    List<String> headers = [];
    if (selectedQuestionType == "Multiple Choice Question") {
      headers = mcq_headers;
    } else if (selectedQuestionType == "Fill in the blanks") {
      headers = fill_in_the_blanks_headers;
    }else if (selectedQuestionType == "Re-Arrange the Word") {
      headers = rearrange_headers;
    } else if (selectedQuestionType == "Complete the Word") {
      headers = complete_the_word_headers;
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
    } else if (selectedQuestionType == "Complete the paragraph") {
      headers = complete_paragraph;
    }else if (selectedQuestionType == "Match the pairs") {
      headers = match_the_pairs_example;
    }else if (selectedQuestionType == "Alphabets Example") {
      headers = alphabet_example;
    }

    // Add headers as the first row
    rows.add(headers);

    // Add sample data (ensure each row is added individually)
    for (int i = 0; i < 1; i++) {
      // Example: Add 1 row of sample data
      List<dynamic> row = [
        mainCategoryId,
        subCategoryId,
        topicId,
        subtopicId,
        selectedQuestionType
      ];
      rows.add(row); // Add each row separately
    }

    // Convert rows to CSV
    String csvData = const ListToCsvConverter().convert(rows);

    if (kIsWeb) {
      log("Website file save");
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

  void _importTableToCSV() async {
    print("inside import csv");
    List<List<dynamic>> rows = [];

    List<String> headers = [];
    if (selectedQuestionType == "Multiple Choice Question") {
      headers = mcq_headers;
    } else if (selectedQuestionType == "Fill in the blanks") {
      headers = fill_in_the_blanks_headers;
    }else if (selectedQuestionType == "Re-Arrange the Word") {
      headers = rearrange_headers;
      uploadCsvToApi(headers).whenComplete(() => _getAllQuestionsApiController);
    } else if (selectedQuestionType == "Complete the Word") {
      headers = complete_the_word_headers;
      uploadCsvToApi(headers);
    } else if (selectedQuestionType == "True/False") {
      headers = true_false_headers;
    } else if (selectedQuestionType == "Story") {
      headers = story_headers;
    } else if (selectedQuestionType == "Phrases") {
      headers = phrases_headers;
    } else if (selectedQuestionType == "Conversation") {
      headers = conversation_headers;
    }else if (selectedQuestionType == "Fill in the blanks") {
      headers = fill_in_the_blanks_headers;
      uploadCsvToApi(headers);
    } else if (selectedQuestionType == "Learning Slide") {
      headers = learning_slide;
    } else if (selectedQuestionType == "Card Flip") {
      headers = cardFlip_headers;
    } else if (selectedQuestionType == "Complete the paragraph") {
      headers = complete_paragraph;
    }else if (selectedQuestionType == "Match the pairs") {
      headers = match_the_pairs_example;
    }else if (selectedQuestionType == "Alphabets Example") {
      headers = alphabet_example;
    }
    rows.add(headers);
    uploadCsvToApi(headers);
    print(headers);
  }

  getData() async {
    await _controller.getCategory();
    setState(() {});
  }

  void _getAddedQuestion() {
    _getAllQuestionsApiController.clearData();
    if (selectedQuestionType == "Multiple Choice Question") {
      _getAllQuestionsApiController.getAllMCQS(
          main_category_id: mainCategoryId,
          sub_category_id: subCategoryId,
          topic_id: topicId,sub_topic_id: subtopicId);
    } else if (selectedQuestionType == "Re-Arrange the Word") {
      _getAllQuestionsApiController.getAllRe_Arrange(
          main_category_id: mainCategoryId,
          sub_category_id: subCategoryId,
          topic_id: topicId,sub_topic_id: subtopicId);
    } else if (selectedQuestionType == "Complete the Word") {
      ///
    } else if (selectedQuestionType == "True/False") {
      _getAllQuestionsApiController.getTrueORFalse(
          main_category_id: mainCategoryId,
          sub_category_id: subCategoryId,
          topic_id: topicId,sub_topic_id: subtopicId);
    }else if (selectedQuestionType == "Story") {
      _getAllQuestionsApiController.getStoryData(
          main_category_id: mainCategoryId,
          sub_category_id: subCategoryId,
          topic_id: topicId,sub_topic_id: subtopicId);
    } else if (selectedQuestionType == "Fill in the blanks") {
      _getAllQuestionsApiController.getFillInTheBlanks(
          main_category_id: mainCategoryId,
          sub_category_id: subCategoryId,
          topic_id: topicId,sub_topic_id: subtopicId);
    } else if (selectedQuestionType == "Phrases") {
      _getAllQuestionsApiController.getStoryPhrases(
          main_category_id: mainCategoryId,
          sub_category_id: subCategoryId,
          topic_id: topicId,sub_topic_id: subtopicId);
    } else if (selectedQuestionType == "Conversation") {
      _getAllQuestionsApiController.getConversation(
          main_category_id: mainCategoryId,
          sub_category_id: subCategoryId,
          topic_id: topicId,sub_topic_id: subtopicId);
    } else if (selectedQuestionType == "Match the pairs") {
      _getAllQuestionsApiController.getMatchPairs(
          main_category_id: mainCategoryId,
          sub_category_id: subCategoryId,
          topic_id: topicId,sub_topic_id: subtopicId);
    } else if (selectedQuestionType == "Card Flip") {

    }

    setState(() {
      questionController.clear();
      optionControllers.forEach((controller) => controller.clear());
      correctAnswerController.clear();
    });
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
                    _controller.get_topic(
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
                  selectedSubtopic = null;
                  // Reset subtopic when topic changes
                  // Fetch subtopics based on the selected topic
                  topicId = _controller.topics
                      .firstWhere((t) => t['topic_name'] == value)['_id'];
                  _getAddedQuestion();
                  // final List<Map<String, dynamic>> entries = (_controller.topics.value as List)
                  //     .firstWhere((topic) => topic['topic_name'] == selectedTopic)['entries'];
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
                        _getAddedQuestion();
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
                                  Row(children: [
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
                                          // print("categoryId "+mainCategoryId!);
                                          // print("subcategoryId "+subCategoryId!);
                                          // print("topicId "+topicId!);
                                          // print("subtopicId "+subtopicId!);
                                          showImportExportDialog();
                                        },
                                        tooltip: 'Export to Excel',
                                      ),
                                    ),
                                  ]),

                                  SizedBox(height: 16),
                                  _buildTabs(),
                                  boxH20(),
                                  // Only show _buildQuestionsTable if selectedQuestionType is "Multiple Choice Question"
                                  if (selectedQuestionType ==
                                      "Multiple Choice Question")
                                    _buildQuestionsTable(),

                                  if (selectedQuestionType ==
                                      "Re-Arrange the Word")
                                    _buildRearrangeTheWordQuestionsTable(),

                                  if (selectedQuestionType ==
                                      "Complete the Word")
                                    _buildQuestionsCompleteTheWordTable(),

                                  if (selectedQuestionType == "True/False")
                                    _buildQuestionsTrueFalseTable(),

                                  if (selectedQuestionType == "Story")
                                    _buildQuestionsStoryTable(),

                                  if (selectedQuestionType == "Phrases")
                                    _buildQuestionsPhrasesTable(),

                                  if (selectedQuestionType == "Conversation")
                                    _buildQuestionsConversationTable(),

                                  if (selectedQuestionType ==
                                      "Fill in the blanks")
                                    _buildQuestionsFillInTheBlanksTable(),

                                  if (selectedQuestionType == "Match the pairs")
                                    _buildQuestionsMatchthepairsTable(),

                              if (selectedQuestionType == "Card Flip")
                                _buildQuestionsFlipTheCardTable(),

                                  if (selectedQuestionType ==
                                      "Complete the paragraph")
                                    _buildQuestionsCompleteTheParagraphTable(),

                                  if (selectedQuestionType == "Alphabets Example" && selectedTopic!="")
                                    _buildExampleTable(),
                                  // Show this widget for "Re-Arrange the Word"
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
                                        width: MediaQuery.of(context).size.width * 0.19,
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
                                    width:
                                        MediaQuery.of(context).size.width * 0.4,
                                    height:
                                        MediaQuery.of(context).size.width * 0.4,
                                    child: _buildQuestionTypeContent(),
                                  ),
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

  void showImportExportDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Import/Export CSV"),
          content: const SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Instructions for CSV Import/Export:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                    "1. Ensure the CSV file is formatted according to the required structure."),
                Text(
                    "2. The CSV file should contain data related to the selected category, subcategory, and topic."),
                Text(
                    "3. The category, subcategory, and topic IDs must match the existing records."),
                SizedBox(height: 16),
                Text("Tap on the respective button to import or export data."),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (selectedQuestionType != "") {
                  _importTableToCSV();
                }
              },
              child: const Text("Import"),
            ),
            TextButton(
              onPressed: () {
                if (selectedQuestionType != "Alphabets Example" &&
                    mainCategoryId!.isNotEmpty && subCategoryId!.isNotEmpty && topicId!.isNotEmpty) {
                  _exportTableToCSV();
                  Navigator.pop(context); // Close the dialog
                } else if (selectedQuestionType == "Alphabets Example" &&
                    mainCategoryId!.isNotEmpty && subCategoryId!.isNotEmpty) {
                  _exportTableToCSV();
                  Navigator.pop(context); // Close the dialog
                } else {
                  showSnackbar(message: "Please select category, subcategory, and topic.");
                }
              },
              child: const Text("Export"),
            ),
          ],
        );
      },
    );
  }

  Future<void> uploadCsvToApi(List<String> requiredHeaders) async {
    try {
      // Pick the .csv file
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
      );

      if (result == null) {
        print('No file selected');
        return;
      }

      String content;

      if (result.files.single.bytes != null) {
        // Read file content directly from bytes
        content = String.fromCharCodes(result.files.single.bytes!);
      } else if (result.files.single.path != null) {
        // Read file content from path
        File file = File(result.files.single.path!);
        content = await file.readAsString();
      } else {
        print('Failed to read file content.');
        return;
      }

      // Parse the CSV content
      List<List<dynamic>> rows = const CsvToListConverter().convert(content);

      if (rows.isEmpty) {
        print('The CSV file is empty.');
        return;
      }

      // Validate headers
      List<String> csvHeaders = rows.first.cast<String>();

      if (csvHeaders.isNotEmpty && csvHeaders.first.startsWith('ï»¿')) {
        csvHeaders[0] = csvHeaders.first.substring(3);
        // Update the first header without BOM
      }

      if (!listEquals(csvHeaders, requiredHeaders)) {
        showSnackbar(message: "CSV headers do not match the required columns.");
        print('CSV headers do not match the required columns.');
        print('Expected: $requiredHeaders');
        print('Found: $csvHeaders');
        return;
      }

      // Parse data rows
      List<Map<String, dynamic>> data = rows.skip(1).map((row) {
        Map<String, dynamic> map = {};
        for (int i = 0; i < csvHeaders.length; i++) {
          map[csvHeaders[i]] = row[i];
        }
        return map;
      }).toList();

      // Validate and clean data
      for (var row in data) {
        if (row['main_category_id'] == null || row['main_category_id'].isEmpty) {
          print('Error: main_category_id is missing for row: $row');
          return;
        }
        if (row['sub_category_id'] == null || row['sub_category_id'].isEmpty) {
          print('Error: sub_category_id is missing for row: $row');
          return;
        }
        if (selectedQuestionType!="Alphabets Example" && (row['topic_id'] == null || row['topic_id'].isEmpty)) {
          print('Error: topic_id is missing for row: $row');
          return;
        }
        if (selectedQuestionType=="Alphabets Example" && (row['topic_name'] == null)) {
          print('Error: topic_name is missing for row: $row');
          return;
        }
      }
      // Make API call
      String apiUrl =
      selectedQuestionType == "Multiple Choice Question"
          ? ApiString.add_mcq:

          selectedQuestionType == "Alphabets Example"
          ? ApiString.add_topics
              : selectedQuestionType == "Re-Arrange the Word"
                  ? ApiString.add_rearrange
                  : selectedQuestionType == "True/False"
                      ? ApiString.add_true_false
                      : selectedQuestionType == "Story"
                          ? ApiString.add_story
                          : selectedQuestionType == "Fill in the blanks"
                            ? ApiString.add_fill_blanks
                            : selectedQuestionType == "Phrases"
                              ? ApiString.add_story_phrases
                              : selectedQuestionType == "Conversation"
                                ? ApiString.add_conversation
                                : selectedQuestionType == "Card Flip"
                                  ? ApiString.add_card_flipping
                                    : selectedQuestionType == "Learning Slide"
                                      ? ApiString.add_learning_slide
                                        : selectedQuestionType == "Complete the Word"
                                            ? ApiString.add_complete_the_word
                                              : selectedQuestionType == "Complete the paragraph"
                                                ? ApiString.add_complete_the_paragraph:
                              selectedQuestionType == "Match the pairs"?
                              ApiString.add_match_pair_question:
                                  ApiString.add_fill_blanks;

      print(apiUrl);
      for (var map in data) {
        // String payload = jsonEncode(map);
        String payload = jsonEncode({
          'data': [map]
        });
        print('Payload for this row: $payload');

        http.Response response = await http.post(
          Uri.parse(apiUrl),
          headers: {'Content-Type': 'application/json'},
          body: payload,
        );
        print('Status Code : ' + response.statusCode.toString());
        if (response.statusCode == 201) {
          print('Row uploaded successfully: $map');
        } else {
          print('Failed to upload row: ${response.body}');
        }
      }
      showSnackbar(message: "$selectedQuestionType added successfully");
      Navigator.pop(context);
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  /// Helper function to compare two lists
  bool listEquals(List<String> list1, List<String> list2) {
    if (list1.length != list2.length) return false;
    for (int i = 0; i < list1.length; i++) {
      if (list1[i] != list2[i]) return false;
    }
    return true;
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
                Tooltip(
                  message: 'Export to Excel',
                  child: CircleAvatar(
                    backgroundColor: Colors.orange.shade100,
                    child: IconButton(
                      icon: Image.asset('assets/excel.png',
                          width: 24, height: 24),
                      onPressed: () {
                        showImportExportDialog();
                      },
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Obx(() {
              return Center(
                child: _getAllQuestionsApiController.isLoading.value
                    ? CircularProgressIndicator()
                    : (_getAllQuestionsApiController.getMcqslits.isEmpty
                        ? const Center(
                            child: Text(
                              'No data available',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey),
                            ),
                          )
                        : SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            controller: _scrollController,
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                  minWidth: 1200, minHeight: 400),
                              child: SizedBox(
                                height: 400,
                                width: 600,
                                child: Column(
                                  children: [
                                    // Table Header
                                    Container(
                                      color: Colors.orange.shade100,
                                      child: Row(
                                        children: [
                                          _buildTableHeader("Question Type"),
                                          _buildTableHeader("Title"),
                                          _buildTableHeader("Question"),
                                          _buildTableHeader("Option 1"),
                                          _buildTableHeader("Option 2"),
                                          _buildTableHeader("Option 3"),
                                          _buildTableHeader("Option 4"),
                                          _buildTableHeader("Answer"),
                                          _buildTableHeader("Points"),
                                          _buildTableHeader("Question Image"),
                                        ],
                                      ),
                                    ),
                                    // Table Rows
                                    Expanded(
                                      child: ListView.builder(
                                        scrollDirection: Axis.vertical,
                                        itemCount: _getAllQuestionsApiController
                                            .getMcqslits.length,
                                        itemBuilder: (context, index) {
                                          var row =
                                              _getAllQuestionsApiController
                                                  .getMcqslits[index];
                                          return Row(
                                            children: [
                                              _buildTableCell(
                                                  row.questionType ?? ""),
                                              _buildTableCell(row.title ?? ""),
                                              _buildTableCell(
                                                  row.question ?? ""),
                                              _buildTableCell(
                                                  row.optionA ?? ""),
                                              _buildTableCell(
                                                  row.optionB ?? ""),
                                              _buildTableCell(
                                                  row.optionC ?? ""),
                                              _buildTableCell(
                                                  row.optionD ?? ""),
                                              _buildTableCell(row.answer ?? ""),
                                              _buildTableCell(
                                                  row.points.toString() ?? ""),
                                              GestureDetector(
                                                onTap: () => _showImagePopup(),
                                                child: const Text(
                                                  "View",
                                                  style: TextStyle(
                                                    color: Colors.blue,
                                                    decoration: TextDecoration
                                                        .underline,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )),
              );
            })
          ],
        ),
      ),
    );
  }

  Widget _buildTableHeader(String text) {
    return Expanded(
      //flex: flex,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildTableCell(String text) {
    return Expanded(
      //flex: flex,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        alignment: Alignment.center,
        child: Text(text),
      ),
    );
  }

  Widget _buildRearrangeTheWordQuestionsTable() {
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
                Tooltip(
                  message: 'Export to Excel',
                  child: CircleAvatar(
                    backgroundColor: Colors.orange.shade100,
                    child: IconButton(
                      icon: Image.asset('assets/excel.png',
                          width: 24, height: 24),
                      onPressed: () {
                        print("categoryId " + mainCategoryId!);
                        print("subcategoryId " + subCategoryId!);
                        print("topicId " + topicId!);
                        print("subtopicId " + subtopicId!);
                        showImportExportDialog();
                      },
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Obx(() {
              return Center(
                child: _getAllQuestionsApiController.isLoading.value
                    ? CircularProgressIndicator()
                    : (_getAllQuestionsApiController.getReArrangeList.isEmpty
                        ? Center(
                            child: Text(
                              'No data available',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey),
                            ),
                          )
                        : SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            controller: _scrollController,
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                  minWidth: 1200, minHeight: 400),
                              child: SizedBox(
                                height: 400,
                                width: 600,
                                child: Column(
                                  children: [
                                    // Table Header
                                    Container(
                                      color: Colors.orange.shade100,
                                      child: Row(
                                        children: [
                                          _buildTableHeader("Question Type"),
                                          _buildTableHeader("Title"),
                                          _buildTableHeader("Re-Arrange Word"),
                                          _buildTableHeader("Points"),
                                          _buildTableHeader("Question Image"),
                                        ],
                                      ),
                                    ),
                                    // Table Rows
                                    Expanded(
                                      child: ListView.builder(
                                        scrollDirection: Axis.vertical,
                                        itemCount: _getAllQuestionsApiController
                                            .getReArrangeList.length,
                                        itemBuilder: (context, index) {
                                          var row =
                                              _getAllQuestionsApiController
                                                  .getReArrangeList[index];
                                          return Row(
                                            children: [
                                              _buildTableCell(
                                                  row.questionType ?? ""),
                                              _buildTableCell(row.title ?? ""),
                                              _buildTableCell(
                                                  row.question ?? ""),
                                              _buildTableCell(row.answer ?? ""),
                                              _buildTableCell(
                                                  row.points.toString() ?? ""),
                                              GestureDetector(
                                                onTap: () => _showImagePopup(),
                                                child: Text(
                                                  "View",
                                                  style: TextStyle(
                                                    color: Colors.blue,
                                                    decoration: TextDecoration
                                                        .underline,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )),
              );
            })
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionsCompleteTheWordTable() {
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
                Tooltip(
                  message: 'Export to Excel',
                  child: CircleAvatar(
                    backgroundColor: Colors.orange.shade100,
                    child: IconButton(
                      icon: Image.asset('assets/excel.png',
                          width: 24, height: 24),
                      onPressed: () {
                        print("categoryId " + mainCategoryId!);
                        print("subcategoryId " + subCategoryId!);
                        print("topicId " + topicId!);
                        print("subtopicId " + subtopicId!);
                        showImportExportDialog();
                        // if (mainCategoryId!.isNotEmpty &&
                        //     subCategoryId!.isNotEmpty &&
                        //     topicId!.isNotEmpty)
                        //   _exportTableToCSV();
                        // else
                        //   showSnackbar(
                        //       message:
                        //           "Please select category,subcategory,topic,etc");
                      },
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            // Wrap the entire table in a SingleChildScrollView for both vertical and horizontal scrolling
            SingleChildScrollView(
              scrollDirection: Axis.horizontal, // Horizontal scroll
              child: Container(
                constraints:
                    BoxConstraints(maxWidth: 1200), // Max width constraint
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical, // Vertical scroll
                  child: Table(
                    border: TableBorder.all(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    columnWidths: const {
                      0: FlexColumnWidth(1),
                      1: FlexColumnWidth(2),
                      2: FlexColumnWidth(1),
                      3: FlexColumnWidth(1),
                      4: FlexColumnWidth(1),
                      5: FlexColumnWidth(1),
                      6: FlexColumnWidth(1),
                      7: FlexColumnWidth(1),
                    },
                    children: [
                      TableRow(
                        decoration: BoxDecoration(
                          color: Colors.orange.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        children: [
                          _buildTableHeader("Question Type"),
                          _buildTableHeader("Question"),
                          _buildTableHeader("Option 1"),
                          _buildTableHeader("Option 2"),
                          _buildTableHeader("Option 3"),
                          _buildTableHeader("Option 4"),
                          _buildTableHeader("Answer"),
                          _buildTableHeader("Points"),
                        ],
                      ),
                      // Dummy rows
                      for (int i = 0; i < 5; i++)
                        TableRow(
                          children: [
                            _buildTableCell("Complete The Word"),
                            _buildTableCell("Fill in the blank: W_rld"),
                            _buildTableCell("World"),
                            _buildTableCell("Word"),
                            _buildTableCell("Ward"),
                            _buildTableCell("Wild"),
                            _buildTableCell("World"),
                            _buildTableCell((5 + i * 5).toString()),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionsTrueFalseTable() {
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
                Tooltip(
                  message: 'Export to Excel',
                  child: CircleAvatar(
                    backgroundColor: Colors.orange.shade100,
                    child: IconButton(
                      icon: Image.asset('assets/excel.png',
                          width: 24, height: 24),
                      onPressed: () {
                        print("categoryId " + mainCategoryId!);
                        print("subcategoryId " + subCategoryId!);
                        print("topicId " + topicId!);
                        print("subtopicId " + subtopicId!);
                        showImportExportDialog();
                      },
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),

            Obx(() {
              return Center(
                child: _getAllQuestionsApiController.isLoading.value
                    ? CircularProgressIndicator()
                    : (_getAllQuestionsApiController.getTrueOrFalseList.isEmpty
                    ? Center(
                  child: Text(
                    'No data available',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey),
                  ),
                )
                    : SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  controller: _scrollController,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                        minWidth: 1200, minHeight: 400),
                    child: SizedBox(
                      height: 400,
                      width: 600,
                      child: Column(
                        children: [
                          // Table Header
                          Container(
                            color: Colors.orange.shade100,
                            child: Row(
                              children: [
                                _buildTableHeader("Question Type"),
                                _buildTableHeader("Question"),
                                _buildTableHeader("Answer"),
                                _buildTableHeader("Points"),
                                _buildTableHeader("Question Image"),
                              ],
                            ),
                          ),
                          // Table Rows
                          Expanded(
                            child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount: _getAllQuestionsApiController
                                  .getTrueOrFalseList.length,
                              itemBuilder: (context, index) {
                                var row =
                                _getAllQuestionsApiController
                                    .getTrueOrFalseList[index];
                                return Row(
                                  children: [
                                    _buildTableCell(
                                        row.questionType ?? ""),
                                    _buildTableCell(row.question ?? ""),
                                    _buildTableCell(
                                        row.question ?? ""),
                                    _buildTableCell(row.answer ?? ""),
                                    _buildTableCell(
                                        row.points.toString() ?? ""),
                                    GestureDetector(
                                      onTap: () => _showImagePopup(),
                                      child: const Text(
                                        "View",
                                        style: TextStyle(
                                          color: Colors.blue,
                                          decoration: TextDecoration
                                              .underline,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )),
              );
            })
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionsStoryTable() {
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
                Tooltip(
                  message: 'Export to Excel',
                  child: CircleAvatar(
                    backgroundColor: Colors.orange.shade100,
                    child: IconButton(
                      icon: Image.asset('assets/excel.png',
                          width: 24, height: 24),
                      onPressed: () {
                        print("categoryId " + mainCategoryId!);
                        print("subcategoryId " + subCategoryId!);
                        print("topicId " + topicId!);
                        print("subtopicId " + subtopicId!);
                        if (mainCategoryId!.isNotEmpty &&
                            subCategoryId!.isNotEmpty &&
                            topicId!.isNotEmpty)
                          showImportExportDialog();
                        else
                          showSnackbar(
                              message:
                                  "Please select category,subcategory,topic,etc");
                      },
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Obx(() {
              return Center(
                child: _getAllQuestionsApiController.isLoading.value
                    ? CircularProgressIndicator()
                    : (_getAllQuestionsApiController.getStoryDataList.isEmpty
                    ? Center(
                  child: Text(
                    'No data available',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey),
                  ),
                )
                    : SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  controller: _scrollController,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                        minWidth: 1200, minHeight: 400),
                    child: SizedBox(
                      height: 400,
                      width: 600,
                      child: Column(
                        children: [
                          // Table Header
                          Container(
                            color: Colors.orange.shade100,
                            child: Row(
                              children: [
                                _buildTableHeader("Story Title"),
                                _buildTableHeader("Story Content"),
                                _buildTableHeader("Points"),
                                _buildTableHeader("Story Image"),
                              ],
                            ),
                          ),
                          // Table Rows
                          Expanded(
                            child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount: _getAllQuestionsApiController
                                  .getStoryDataList.length,
                              itemBuilder: (context, index) {
                                var row =
                                _getAllQuestionsApiController
                                    .getStoryDataList[index];
                                return Row(
                                  children: [
                                    _buildTableCell(
                                        row.storyTitle ?? ""),
                                    _buildTableCell(row.content ?? ""),
                                    _buildTableCell(
                                        row.highlightWord ?? ""),
                                    _buildTableCell(
                                        row.points.toString() ?? ""),
                                    GestureDetector(
                                      onTap: () => _showImagePopup(),
                                      child: const Text(
                                        "View",
                                        style: TextStyle(
                                          color: Colors.blue,
                                          decoration: TextDecoration
                                              .underline,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )),
              );
            })

          ],
        ),
      ),
    );
  }

  Widget _buildQuestionsPhrasesTable() {
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
                Tooltip(
                  message: 'Export to Excel',
                  child: CircleAvatar(
                    backgroundColor: Colors.orange.shade100,
                    child: IconButton(
                      icon: Image.asset('assets/excel.png',
                          width: 24, height: 24),
                      onPressed: () {
                        print("categoryId " + mainCategoryId!);
                        print("subcategoryId " + subCategoryId!);
                        print("topicId " + topicId!);
                        print("subtopicId " + subtopicId!);
                        if (mainCategoryId!.isNotEmpty &&
                            subCategoryId!.isNotEmpty &&
                            topicId!.isNotEmpty)
                          showImportExportDialog();
                        else
                          showSnackbar(
                              message:
                                  "Please select category,subcategory,topic,etc");
                      },
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Obx(() {
              return Center(
                child: _getAllQuestionsApiController.isLoading.value
                    ? CircularProgressIndicator()
                    : (_getAllQuestionsApiController.getStoryPhrasesList.isEmpty
                    ? Center(
                  child: Text(
                    'No data available',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey),
                  ),
                )
                    : SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  controller: _scrollController,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                        minWidth: 1200, minHeight: 400),
                    child: SizedBox(
                      height: 400,
                      width: 600,
                      child: Column(
                        children: [
                          // Table Header
                          Container(
                            color: Colors.orange.shade100,
                            child: Row(
                              children: [
                                _buildTableHeader("Index"),
                                _buildTableHeader("Phrase"),
                                _buildTableHeader("Points"),
                              ],
                            ),
                          ),
                          // Table Rows
                          Expanded(
                            child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount: _getAllQuestionsApiController
                                  .getStoryPhrasesList.length,
                              itemBuilder: (context, index) {
                                var row =
                                _getAllQuestionsApiController
                                    .getStoryPhrasesList[index];
                                return Row(
                                  children: [
                                    _buildTableCell(
                                        row.index.toString() ?? ""),
                                    // _buildTableCell(
                                    //     row.phraseName ?? ""),
                                    _buildTableCell(
                                        row.points.toString() ?? ""),
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )),
              );
            })
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionsConversationTable() {
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
                Tooltip(
                  message: 'Export to Excel',
                  child: CircleAvatar(
                    backgroundColor: Colors.orange.shade100,
                    child: IconButton(
                      icon: Image.asset('assets/excel.png',
                          width: 24, height: 24),
                      onPressed: () {
                        print("categoryId " + mainCategoryId!);
                        print("subcategoryId " + subCategoryId!);
                        print("topicId " + topicId!);
                        print("subtopicId " + subtopicId!);
                        if (mainCategoryId!.isNotEmpty &&
                            subCategoryId!.isNotEmpty &&
                            topicId!.isNotEmpty)
                          showImportExportDialog();
                        else
                          showSnackbar(
                              message:
                                  "Please select category,subcategory,topic,etc");
                      },
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            // Wrap the entire table in a SingleChildScrollView for both vertical and horizontal scrolling
            SingleChildScrollView(
              scrollDirection: Axis.horizontal, // Horizontal scroll
              child: Container(
                constraints:
                    BoxConstraints(maxWidth: 1200), // Max width constraint
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical, // Vertical scroll
                  child: Table(
                    border: TableBorder.all(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    columnWidths: const {
                      0: FlexColumnWidth(1),
                      1: FlexColumnWidth(2),
                      2: FlexColumnWidth(1),
                      3: FlexColumnWidth(1),
                    },
                    children: [
                      TableRow(
                        decoration: BoxDecoration(
                          color: Colors.orange.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        children: [
                          _buildTableHeader("Question Type"),
                          _buildTableHeader("Question"),
                          _buildTableHeader("Answer"),
                          _buildTableHeader("Points"),
                        ],
                      ),
                      // Dummy rows
                      for (int i = 0; i < 5; i++)
                        TableRow(
                          children: [
                            _buildTableCell("Conversation"),
                            _buildTableCell("What is the response for '$i'?"),
                            _buildTableCell("Answer $i"),
                            _buildTableCell((10 + i * 5).toString()),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionsFillInTheBlanksTable() {
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
                Tooltip(
                  message: 'Export to Excel',
                  child: CircleAvatar(
                    backgroundColor: Colors.orange.shade100,
                    child: IconButton(
                      icon: Image.asset('assets/excel.png',
                          width: 24, height: 24),
                      onPressed: () {
                        print("categoryId " + mainCategoryId!);
                        print("subcategoryId " + subCategoryId!);
                        print("topicId " + topicId!);
                        print("subtopicId " + subtopicId!);
                        if (mainCategoryId!.isNotEmpty &&
                            subCategoryId!.isNotEmpty &&
                            topicId!.isNotEmpty)
                          showImportExportDialog();
                        else
                          showSnackbar(
                              message:
                                  "Please select category,subcategory,topic,etc");
                      },
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Obx(() {
              return Center(
                child: _getAllQuestionsApiController.isLoading.value
                    ? CircularProgressIndicator()
                    : (_getAllQuestionsApiController.getFillInTheBlanksList.isEmpty
                    ? Center(
                  child: Text(
                    'No data available',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey),
                  ),
                )
                    :
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  controller: _scrollController,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                        minWidth: 1200, minHeight: 400),
                    child: SizedBox(
                      height: 400,
                      width: 600,
                      child: Column(
                        children: [
                          // Table Header
                          Container(
                            color: Colors.orange.shade100,
                            child: Row(
                              children: [
                                _buildTableHeader("Question Type"),
                                _buildTableHeader("Title"),
                                _buildTableHeader("Question Language"),
                                _buildTableHeader("Question"),
                                _buildTableHeader("Option Language"),
                                _buildTableHeader("Option 1"),
                                _buildTableHeader("Option 2"),
                                _buildTableHeader("Option 3"),
                                _buildTableHeader("Option 4"),
                                _buildTableHeader("Answer"),
                                _buildTableHeader("Points"),
                                _buildTableHeader("Question Image"),
                              ],
                            ),
                          ),
                          // Table Rows
                          Expanded(
                            child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount: _getAllQuestionsApiController
                                  .getFillInTheBlanksList.length,
                              itemBuilder: (context, index) {
                                var row =
                                _getAllQuestionsApiController
                                    .getFillInTheBlanksList[index];
                                return Row(
                                  children: [
                                    _buildTableCell(row.questionType ?? ""),
                                    _buildTableCell(row.title ?? ""),
                                    _buildTableCell(row.questionLanguage ?? ""),
                                    _buildTableCell(row.question ?? ""),
                                    _buildTableCell(row.optionLanguage ?? ""),
                                    _buildTableCell(row.optionA ?? ""),
                                    _buildTableCell(row.optionB ?? ""),
                                    _buildTableCell(row.optionC ?? ""),
                                    _buildTableCell(row.optionD ?? ""),
                                    _buildTableCell(row.answer ?? ""),
                                    _buildTableCell(row.points.toString() ?? ""),
                                    GestureDetector(
                                      onTap: () => _showImagePopup(),
                                      child: const Text(
                                        "View",
                                        style: TextStyle(
                                          color: Colors.blue,
                                          decoration: TextDecoration
                                              .underline,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )),
              );
            })
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionsMatchthepairsTable() {
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
                Tooltip(
                  message: 'Export to Excel',
                  child: CircleAvatar(
                    backgroundColor: Colors.orange.shade100,
                    child: IconButton(
                      icon: Image.asset('assets/excel.png',
                          width: 24, height: 24),
                      onPressed: () {
                        print("categoryId " + mainCategoryId!);
                        print("subcategoryId " + subCategoryId!);
                        print("topicId " + topicId!);
                        print("subtopicId " + subtopicId!);
                        if (mainCategoryId!.isNotEmpty &&
                            subCategoryId!.isNotEmpty &&
                            topicId!.isNotEmpty)
                          showImportExportDialog();
                        else
                          showSnackbar(
                              message:
                                  "Please select category,subcategory,topic,etc");
                      },
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            // Wrap the entire table in a SingleChildScrollView for both vertical and horizontal scrolling
            Obx(() {
              return Center(
                child: _getAllQuestionsApiController.isLoading.value
                    ? CircularProgressIndicator()
                    : (_getAllQuestionsApiController.getMatchPairsList.isEmpty
                    ? Center(
                  child: Text(
                    'No data available',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey),
                  ),
                )
                    :
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  controller: _scrollController,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                        minWidth: 1200, minHeight: 400),
                    child: SizedBox(
                      height: 400,
                      width: 600,
                      child: Column(
                        children: [
                          // Table Header
                          Container(
                            color: Colors.orange.shade100,
                            child: Row(
                              children: [
                                _buildTableHeader("Question Type"),
                                // _buildTableHeader("Question Title"),
                                _buildTableHeader("Left Column"),
                                _buildTableHeader("Right Column"),
                                _buildTableHeader("Points"),
                              ],
                            ),
                          ),
                          // Table Rows
                          Expanded(
                            child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount: _getAllQuestionsApiController
                                  .getMatchPairsList.length,
                              itemBuilder: (context, index) {
                                var row =
                                _getAllQuestionsApiController
                                    .getMatchPairsList[index];
                                return Row(
                                  children: [
                                    _buildTableCell(row.questionType ?? ""),
                                    // _buildTableCell(row.title ?? ""),
                                    // _buildTableCell(row.questionType ?? ""),
                                    GestureDetector(
                                      onTap: () => _showImagePopup(),
                                      child: const Text(
                                        "View",
                                        style: TextStyle(
                                          color: Colors.blue,
                                          decoration: TextDecoration
                                              .underline,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () => _showImagePopup(),
                                      child: const Text(
                                        "View",
                                        style: TextStyle(
                                          color: Colors.blue,
                                          decoration: TextDecoration
                                              .underline,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    _buildTableCell(row.points.toString() ?? ""),
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )),
              );
            })
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionsFlipTheCardTable() {
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
                Tooltip(
                  message: 'Export to Excel',
                  child: CircleAvatar(
                    backgroundColor: Colors.orange.shade100,
                    child: IconButton(
                      icon: Image.asset('assets/excel.png',
                          width: 24, height: 24),
                      onPressed: () {
                        print("categoryId " + mainCategoryId!);
                        print("subcategoryId " + subCategoryId!);
                        print("topicId " + topicId!);
                        print("subtopicId " + subtopicId!);
                        if (mainCategoryId!.isNotEmpty &&
                            subCategoryId!.isNotEmpty &&
                            topicId!.isNotEmpty)
                          showImportExportDialog();
                        else
                          showSnackbar(
                              message:
                              "Please select category,subcategory,topic,etc");
                      },
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            // Wrap the entire table in a SingleChildScrollView for both vertical and horizontal scrolling
            Obx(() {
              return Center(
                child: _getAllQuestionsApiController.isLoading.value
                    ? CircularProgressIndicator()
                    : (_getAllQuestionsApiController.getMatchPairsList.isEmpty
                    ? Center(
                  child: Text(
                    'No data available',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey),
                  ),
                )
                    :
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  controller: _scrollController,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                        minWidth: 1200, minHeight: 400),
                    child: SizedBox(
                      height: 400,
                      width: 600,
                      child: Column(
                        children: [
                          // Table Header
                          Container(
                            color: Colors.orange.shade100,
                            child: Row(
                              children: [
                                _buildTableHeader("Question Type"),
                                // _buildTableHeader("Question Title"),
                                _buildTableHeader("Left Column"),
                                _buildTableHeader("Right Column"),
                                _buildTableHeader("Points"),
                              ],
                            ),
                          ),
                          // Table Rows
                          Expanded(
                            child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount: _getAllQuestionsApiController
                                  .getMatchPairsList.length,
                              itemBuilder: (context, index) {
                                var row =
                                _getAllQuestionsApiController
                                    .getMatchPairsList[index];
                                return Row(
                                  children: [
                                    _buildTableCell(row.questionType ?? ""),
                                    // _buildTableCell(row.title ?? ""),
                                    // _buildTableCell(row.questionType ?? ""),
                                    GestureDetector(
                                      onTap: () => _showImagePopup(),
                                      child: const Text(
                                        "View",
                                        style: TextStyle(
                                          color: Colors.blue,
                                          decoration: TextDecoration
                                              .underline,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () => _showImagePopup(),
                                      child: const Text(
                                        "View",
                                        style: TextStyle(
                                          color: Colors.blue,
                                          decoration: TextDecoration
                                              .underline,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    _buildTableCell(row.points.toString() ?? ""),
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )),
              );
            })
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionsCompleteTheParagraphTable() {
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
                Tooltip(
                  message: 'Export to Excel',
                  child: CircleAvatar(
                    backgroundColor: Colors.orange.shade100,
                    child: IconButton(
                      icon: Image.asset('assets/excel.png',
                          width: 24, height: 24),
                      onPressed: () {
                        print("categoryId " + mainCategoryId!);
                        print("subcategoryId " + subCategoryId!);
                        print("topicId " + topicId!);
                        print("subtopicId " + subtopicId!);
                        if (mainCategoryId!.isNotEmpty &&
                            subCategoryId!.isNotEmpty &&
                            topicId!.isNotEmpty)
                          showImportExportDialog();
                        else
                          showSnackbar(
                              message:
                                  "Please select category,subcategory,topic,etc");
                      },
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            // Wrap the entire table in a SingleChildScrollView for both vertical and horizontal scrolling
            SingleChildScrollView(
              scrollDirection: Axis.horizontal, // Horizontal scroll
              child: Container(
                constraints:
                    BoxConstraints(maxWidth: 1200), // Max width constraint
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical, // Vertical scroll
                  child: Table(
                    border: TableBorder.all(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    columnWidths: const {
                      0: FlexColumnWidth(1),
                      1: FlexColumnWidth(2),
                      2: FlexColumnWidth(3),
                      3: FlexColumnWidth(1),
                      4: FlexColumnWidth(1),
                      5: FlexColumnWidth(1),
                      6: FlexColumnWidth(1),
                      7: FlexColumnWidth(1),
                      8: FlexColumnWidth(1),
                      9: FlexColumnWidth(1),
                      10: FlexColumnWidth(1),
                    },
                    children: [
                      TableRow(
                        decoration: BoxDecoration(
                          color: Colors.orange.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        children: [
                          _buildTableHeader("Question Type"),
                          _buildTableHeader("Title"),
                          _buildTableHeader("Paragraph"),
                          _buildTableHeader("Option 1"),
                          _buildTableHeader("Option 2"),
                          _buildTableHeader("Option 3"),
                          _buildTableHeader("Option 4"),
                          _buildTableHeader("Option 5"),
                          _buildTableHeader("Option 6"),
                          _buildTableHeader("Answer"),
                          _buildTableHeader("Points"),
                        ],
                      ),
                      // Dummy rows
                      for (int i = 0; i < 5; i++)
                        TableRow(
                          children: [
                            _buildTableCell("Complete Paragraph"),
                            _buildTableCell("Title $i"),
                            _buildTableCell(
                                "This is a sample paragraph content $i for testing purposes."),
                            _buildTableCell("Option A$i"),
                            _buildTableCell("Option B$i"),
                            _buildTableCell("Option C$i"),
                            _buildTableCell("Option D$i"),
                            _buildTableCell("Option E$i"),
                            _buildTableCell("Option F$i"),
                            _buildTableCell("Option A$i"),
                            _buildTableCell((5 + i).toString()),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExampleTable() {
    final List<dynamic> entries = (_controller.topics.value as List)
        .firstWhere((topic) => topic['topic_name'] == selectedTopic,
        orElse: () => {'entries': []}, )['entries'];
    if (entries.isEmpty) {
      return Center(
        child: Text(selectedTopic == null
            ? "No topic selected"
            : "No entries found for Topic $selectedTopic"),
      );
    }
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
                Tooltip(
                  message: 'Export to Excel',
                  child: CircleAvatar(
                    backgroundColor: Colors.orange.shade100,
                    child: IconButton(
                      icon: Image.asset('assets/excel.png',
                          width: 24, height: 24),
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
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            // Wrap the entire table in a SingleChildScrollView for both vertical and horizontal scrolling
            selectedTopic!.isNotEmpty?
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('Example')),
                    DataColumn(label: Text('Image Name')),
                    DataColumn(label: Text('Image')),
                    DataColumn(label: Text('Remove')),
                  ],
                  rows: entries.map((entry) {
                    return DataRow(
                      cells: [
                        //DataCell(Text(entry['_id'] ?? '')),
                        DataCell(Text(entry['exg_name'] ?? '')),
                        DataCell(InkWell(child:Text(entry['image_name'] ?? ''),onTap: (){})),
                        DataCell(InkWell(child:Text(entry['image'] ?? ''),onTap: (){},)),
                        DataCell(InkWell(child:Text("Delete",style: TextStyle(color: Colors.red),),onTap: (){},)),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ):SizedBox(),
          ],
        ),
      ),
    );
  }

  void _showImagePopup() {
    showDialog(
      context: context, // Ensure you pass a valid BuildContext
      builder: (context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Question Image',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 10),
              Image.asset(
                'assets/sample_image.png', // Replace with your image path
                width: 200,
                height: 200,
                fit: BoxFit.cover,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the popup
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

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
          main_category_id: mainCategoryId,
          sub_category_id: subCategoryId,
          topic_id: topicId,
          sub_topic_id: subtopicId,
          pointsController: pointsController,
        );
      case "Complete the paragraph":
        return _buildCompleteTheParagraphContent();
      case "Learning Slide":
        return BuildLearningSlideContent(
          pointsController: pointsController,
          sub_topic_id: subtopicId,
          topic_id: topicId,
          sub_category_id: subCategoryId,
          main_category_id: mainCategoryId,
        );
      case "Card Flip":
        return BuildCardFlipContent(
          pointsController: pointsController,
          sub_topic_id: subtopicId,
          topic_id: topicId,
          sub_category_id: subCategoryId,
          main_category_id: mainCategoryId,
        );
      case "Alphabets Example":
        return BuildAlphabetExContent(
          pointsController: pointsController,
          sub_topic_id: subtopicId,
          topic_id: topicId,
          sub_category_id: subCategoryId,
          main_category_id: mainCategoryId,
        );
      default:
        return Container();
    }
  }

  void _submitQuestion() {
    if (selectedQuestionType == "Multiple Choice Question") {
      addQuestionController.addMCQ(
          main_category_id: mainCategoryId!,
          sub_category_id: subCategoryId!,
          sub_topic_id: subtopicId!,
          topic_id: topicId!,
          index: indexController.text,
          question: questionController.text,
          question_type: selectedQuestionType!,
          title: titleController.text,
          option_a: optionControllers[0].text,
          option_b: optionControllers[1].text,
          option_c: optionControllers[2].text,
          option_d: optionControllers[3].text,
          answer: correctAnswerController.text,
          points: pointsController.text,
          q_image: pathsFile,
          context: context);
    }
    else if (selectedQuestionType == "Re-Arrange the Word") {
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
    }
    else if (selectedQuestionType == "Complete the Word") {
      int pointsValue = int.tryParse(pointsController.text) ?? 0;
      questionApiController.addCompleteWordApi(
          mainCategoryId: mainCategoryId.toString(),
          subCategoryId: subCategoryId.toString(),
          topicId: topicId.toString(),
          subTopicId: subtopicId.toString(),
          questionType: selectedQuestionType.toString(),
          title: titleController.text,
          question: questionController.text,
          answer: correctAnswerController.text,
          optionA: optionControllers[0].text,
          optionB: optionControllers[1].text,
          optionC: optionControllers[2].text,
          optionD: optionControllers[3].text,
          points: pointsValue.toString(),
          index: indexController.text, context: context);
    }
    else if (selectedQuestionType == "True/False") {
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
    }
    else if (selectedQuestionType == "Story") {
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
    }
    else if (selectedQuestionType == "Phrases") {
      int pointsValue = int.tryParse(pointsController.text) ?? 0;
      questionApiController.addStoryPhraseApi(
        mainCategoryId: mainCategoryId.toString(),
        subCategoryId: subCategoryId.toString(),
        topicId: topicId.toString(),
        subTopicId: subtopicId.toString(),
        phraseName: phraseNameController.text,
        points: pointsValue.toString(),
        index: indexController.text,
      );

    }
    else if (selectedQuestionType == "Conversation") {
    } else if (selectedQuestionType == "Learning Slide") {
    }
    else if (selectedQuestionType == "Fill in the blanks") {
      int pointsValue = int.tryParse(pointsController.text) ?? 0;
      questionApiController.addFillBlanksApi(
        mainCategoryId: mainCategoryId.toString(),
        subCategoryId: subCategoryId.toString(),
        topicId: topicId.toString(),
        subTopicId: subtopicId.toString(),
        questionType: selectedQuestionType.toString(),
        title: titleController.text,
        question: questionController.text,
        answer: correctAnswerController.text,
        points: pointsValue.toString(),
        index: indexController.text,
        optionLanguage: optLangController.text,
        questionLanguage: queLangController.text,
        optionA: optionControllers[0].text,
        optionB: optionControllers[1].text,
        optionC: optionControllers[2].text,
        optionD: optionControllers[3].text,
      );
    }

    setState(() {
      questionController.clear();
      optionControllers.forEach((controller) => controller.clear());
      correctAnswerController.clear();
      pointsController.clear();
      titleController.clear();
      storyContentController.clear();
      phraseNameController.clear();
      indexController.clear();

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
        padding: const EdgeInsets.symmetric(vertical: 7.0, horizontal: 8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Question Index:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              CustomTextField(
                controller: indexController,
                labelText: '',
                hintText: "0",
              ),
              boxH15(),
              const Text(
                'Question title:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              CustomTextField(
                controller: titleController,
                labelText: 'Enter question title here...',
              ),
              boxH15(),
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
                'Upload Image',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: pickFile,
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
                      child: pathsFile == null
                          ? const Text(
                        "Tap to upload image",
                        style: TextStyle(color: Colors.grey),
                      )
                          : Image.memory(
                        pathsFile!,
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
                  childAspectRatio:
                  2.8, // Adjust height and width of grid items
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
                onPressed: () {
                  print(mainCategoryId ?? 'null');
                  print(subCategoryId ?? 'null');
                  print(topicId ?? 'null');
                  print(subtopicId ?? 'null');
                  _submitQuestion();
                },
              ),
            ],
          ),
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
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
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
                onPressed: _submitQuestion,
              ),
            ],
          ),
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
                'Question Language:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              CustomTextField(
                controller: queLangController,
                labelText: 'Enter question language here...',
                maxLines: 1,
              ),
              boxH15(),
              const Text(
                'Question:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              boxH08(),
              CustomTextField(
                controller: questionController,
                labelText: 'Enter your question here...',
                maxLines: 3,
              ),
              boxH15(),
              const Text(
                'Question Image (Optional):',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                onPressed: _submitQuestion,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// add phrases
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
              controller: phraseNameController,
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

  Widget _reArrangeWord() {
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
              controller: phraseNameController,
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

  /// add Conversation
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
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
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
                'Enter bot conversation',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              boxH08(),
              CustomTextField(
                controller: botConversationController,
                maxLines: 3,
                labelText: "Enter bot conversation",
              ),
              boxH10(),
              const Text(
                'Enter user conversation',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              boxH08(),
              CustomTextField(
                controller: userConversationController,
                maxLines: 3,
                labelText: "Enter user conversation",
              ),
              boxH10(),
              const Text(
                'Select user conversation type',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              boxH08(),
              DropdownButtonFormField<String>(
                value: selectedUserConversationType,
                items: userConversationTypes
                    .map((type) => DropdownMenuItem(
                  value: type,
                  child: Text(type),
                ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedUserConversationType = value;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Select type',
                  border: OutlineInputBorder(),
                ),
              ),
              boxH10(),
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
      ),
    );
  }

  /// add complete the word

  /// add complete the word
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

  /// add complete the paragraph
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
