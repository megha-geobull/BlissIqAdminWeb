import 'dart:convert';
import 'dart:developer';
import 'dart:html' as html;
import 'package:blissiqadmin/Global/Widgets/Button/CustomButton.dart';
import 'package:blissiqadmin/Global/constants/ApiString.dart';
import 'package:blissiqadmin/Global/constants/CommonSizedBox.dart';
import 'package:blissiqadmin/Global/constants/CustomTextField.dart';
import 'package:blissiqadmin/Home/Drawer/MyDrawer.dart';
import 'package:blissiqadmin/Home/Quetion%20type%20widgets/add_match_the_pairs.dart';
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
  TextEditingController titleController = TextEditingController();
  TextEditingController indexController = TextEditingController();
  TextEditingController storyContentController = TextEditingController();
  TextEditingController storyPhrasesController = TextEditingController();
  QuestionController addQuestionController = Get.find();
  CategoryController categoryController = Get.find();
  Uint8List? selectedImage;
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

  String mainCategoryId='';
  String subCategoryId='';
  String topicId='';
  String subtopicId='';

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

  List<PlatformFile>? _paths;
  var pathsFile;
  var pathsFileName;

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
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
    }else if (selectedQuestionType == "Alphabets Example") {
      headers = alphabet_example;
    }
    rows.add(headers);
    List<dynamic> sampleData = [];
    for (int i = 0; i < 1; i++) { // Assuming you want 5 rows of sample data
      List<dynamic> row = [
        '',
        mainCategoryId,
        subCategoryId,
        topicId,
        subtopicId,
      ];

      // Add dynamic placeholders for remaining headers
      // for (int j = 5; j < headers.length; j++) {
      //   row.add('');
      // }

      sampleData.add(row);
    }
    rows.add(sampleData);
    String csvData = const ListToCsvConverter().convert(rows);
    if(kIsWeb){
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

  void _importTableToCSV() async {
    List<List<dynamic>> rows = [];

    List<String> headers = [];
    if (selectedQuestionType == "Multiple Choice Question") {
      headers = mcq_headers;
      uploadCsvToApi(headers);
    } else if (selectedQuestionType == "Re-Arrange the Word") {
      headers = rearrange_headers;
    } else if (selectedQuestionType == "Complete the Word") {
      headers = rearrange_headers;
    } else if (selectedQuestionType == "True/False") {
      headers = true_false_headers;
    } else if (selectedQuestionType == "Story") {
      headers = story_headers;
      uploadCsvToApi(headers);
    } else if (selectedQuestionType == "Phrases") {
      headers = phrases_headers;
    } else if (selectedQuestionType == "Conversation") {
      headers = conversation_headers;
    } else if (selectedQuestionType == "Learning Slide") {
      headers = learning_slide;
    } else if (selectedQuestionType == "Card Flip") {
      headers = cardFlip_headers;
    }else if (selectedQuestionType == "Alphabets Example") {
      headers = alphabet_example;
      uploadCsvToApi(headers);
    }
    rows.add(headers);
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
        // Select sub Topic
        Row(
        children: [
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
                topicId = _controller.topics.firstWhere((t) => t['topic_name'] == value)['_id'];
                _controller.get_SubTopic(topicId: topicId!, categoryId: mainCategoryId.toString(), sub_categoryId: subCategoryId.toString()).then((_) {
                  setState(() {});
                });
              });
            },
          ),
        ),
        boxW10(),
      // Select Subtopic
      _controller.sub_topics.isNotEmpty?
        Expanded(
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
              contentPadding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            ),
            items: _controller.sub_topics.map<DropdownMenuItem<String>>((topic) {
              return DropdownMenuItem<String>(
                value: topic['sub_topic_name'],
                child: Text(topic['sub_topic_name']),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedSubtopic = value;
                // Fetch subtopics based on the selected subtopic
                subtopicId = _controller.sub_topics.firstWhere((t) => t['sub_topic_name'] == value)['_id'];
                setState(() {});
              });
            },
          ),
        ):Expanded(child:SizedBox()),
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
                                        icon: Image.asset('assets/excel.png', width: 24, height: 24),
                                        onPressed: (){
                                          // print("categoryId "+mainCategoryId!);
                                          // print("subcategoryId "+subCategoryId!);
                                          // print("topicId "+topicId!);
                                          // print("subtopicId "+subtopicId!);
                                          showImportExportDialog();
                                        },
                                        tooltip: 'Export to Excel',
                                      ),
                                    )
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  _buildTabs(),
                                  const SizedBox(height: 20),
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
                                        width: MediaQuery.of(context).size.width * 0.06,
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
                                      width: MediaQuery.of(context).size.width * 0.4,
                                      height: MediaQuery.of(context).size.width * 0.4,
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

  void showImportExportDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Import/Export CSV"),
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
                Text("1. Ensure the CSV file is formatted according to the required structure."),
                Text("2. The CSV file should contain data related to the selected category, subcategory, and topic."),
                Text("3. The category, subcategory, and topic IDs must match the existing records."),
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
                if (mainCategoryId!.isNotEmpty &&
                    subCategoryId!.isNotEmpty &&
                    topicId!.isNotEmpty) {
                  _exportTableToCSV();
                  Navigator.pop(context); // Close the dialog
                }
                else if (selectedQuestionType=="Alphabets Example" && mainCategoryId!.isNotEmpty &&
                    subCategoryId!.isNotEmpty) {
                  _exportTableToCSV();
                  Navigator.pop(context); // Close the dialog
                }else {
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
      if (!listEquals(csvHeaders, requiredHeaders)) {
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
        if (row['topic_name'] == null || row['topic_name'].isEmpty) {
          print('Error: topic_name is missing for row: $row');
          return;
        }
      }
      // Make API call
      String apiUrl = selectedQuestionType == "Alphabets Example" ? ApiString.add_topics:
      selectedQuestionType == "Multiple Choice Question"? ApiString.add_mcq:
      selectedQuestionType == "Re-Arrange the Word"? ApiString.add_rearrange:
      selectedQuestionType == "True/False"? ApiString.add_true_false:
      selectedQuestionType == "Story"? ApiString.add_story:ApiString.add_fill_blanks;


      for (var map in data) {
        String payload = jsonEncode(map);
        //String payload = jsonEncode({'data': [map]});
        print('Payload for this row: $payload');

        http.Response response = await http.post(
          Uri.parse(apiUrl),
          headers: {'Content-Type': 'application/json'},
          body: payload,
        );
        print('Status Code : '+response.statusCode.toString());
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

                CircleAvatar(
                  backgroundColor: Colors.orange.shade100,
                  child: IconButton(
                    icon: Image.asset('assets/excel.png', width: 24, height: 24),
                    onPressed: (){
                      // print("categoryId "+mainCategoryId!);
                      // print("subcategoryId "+subCategoryId!);
                      // print("topicId "+topicId!);
                      // print("subtopicId "+subtopicId!);
                      // if(mainCategoryId!.isNotEmpty && subCategoryId!.isNotEmpty && topicId!.isNotEmpty)
                      // _exportTableToCSV();
                      // else
                      //   showSnackbar(message: "Please select category,subcategory,topic,etc");
                      showImportExportDialog();
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
    if (selectedQuestionType == "Multiple Choice Question") {
      addQuestionController.addMCQ(
          main_category_id: mainCategoryId!,
          sub_category_id: subCategoryId!,
          sub_topic_id: subtopicId!,
          topic_id: topicId!,
          index: indexController.text,
          question: questionController.text,
          question_type: selectedQuestionType!,
          title:titleController.text,
          option_a: optionControllers[0].text,
          option_b: optionControllers[1].text,
          option_c: optionControllers[2].text,
          option_d: optionControllers[3].text,
          answer: correctAnswerController.text,
          points: pointsController.text,
          q_image: pathsFile,
          context: context);
    } else if (selectedQuestionType == "Re-Arrange the Word") {

    } else if (selectedQuestionType == "Complete the Word") {

    } else if (selectedQuestionType == "True/False") {

    } else if (selectedQuestionType == "Story") {

    } else if (selectedQuestionType == "Phrases") {

    } else if (selectedQuestionType == "Conversation") {

    } else if (selectedQuestionType == "Learning Slide") {

    } else if (selectedQuestionType == "Card Flip") {

    }

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

