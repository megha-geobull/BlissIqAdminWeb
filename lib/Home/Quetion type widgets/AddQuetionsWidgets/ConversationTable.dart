import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Global/constants/CustomAlertDialogue.dart';
import '../controller/GetAllQuestionsApiController.dart';
import '../model/get_conversation.dart';
import '../question_controller.dart';

class ConversationTableScreen extends StatefulWidget {
  final String main_category_id;
  final String sub_category_id;
  final String topic_id;
  final String sub_topic_id;
  final List<Data> questionList;

  ConversationTableScreen(
      {required this.main_category_id,
        required this.sub_category_id,
        required this.topic_id,
        required this.sub_topic_id,
        required this.questionList,});

  @override
  _QuestionTableScreenState createState() => _QuestionTableScreenState();
}

class _QuestionTableScreenState extends State<ConversationTableScreen> {
  TextEditingController _searchController = TextEditingController();
  List<Data> _filteredQuestions = []; // Filtered data for the table
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  final _verticalScrollController = ScrollController();
  final _horizontalScrollController = ScrollController();
  String _selectedQuestionIds = "";
  bool isSelectAll=false;
  List<String> selected_question_ids=[];
  late QuestionDataSource _dataSource;
  final GetAllQuestionsApiController _getdeleteApiController = Get.find();

  @override
  void initState() {
    super.initState();
    // Initialize with API data
    _dataSource = QuestionDataSource(
      widget.questionList,
          (selectedIds) {
        setState(() {
          _selectedQuestionIds = selectedIds;
        });
      },context
    );
    _filteredQuestions = widget.questionList;
  }

  void _filterQuestions(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredQuestions = widget.questionList;
      } else {
        _filteredQuestions = widget.questionList
            .where((question) =>
        question.title != null &&
            question.title!.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
      // Update the data source with the filtered questions
      _dataSource = QuestionDataSource(
        _filteredQuestions,
            (selectedIds) {
          setState(() {
            _selectedQuestionIds = selectedIds;
          });
        },
        context,
      );
    });
  }

  void _removeSelectedQuestions() {
    // Convert the selected IDs string to a Set for efficient lookup
    final selectedIdsSet = _selectedQuestionIds.split('|').toSet();
    if(mounted){
      setState(() {

        // Remove matching items from the filtered list
        _filteredQuestions.removeWhere((mcq) => selectedIdsSet.contains(mcq.id));

        // Clear selected IDs after deletion
        _selectedQuestionIds = '';

        // Update the data source with the updated filtered list
        _dataSource = QuestionDataSource(
          _filteredQuestions,
              (selectedIds) {
            setState(() {
              _selectedQuestionIds = selectedIds;
            });
          },
         context,
        );
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.9,
        child: Column(children: [
          Row(children: [
            SizedBox(
              width: 300,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _searchController,
                  onChanged: _filterQuestions,
                  decoration: const InputDecoration(
                    labelText: "Search by Question",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
              ),
            ),
            _selectedQuestionIds.isNotEmpty?
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade100, // Button color
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12), // Padding
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8), // Rounded corners
                ),
              ),
              icon: const Icon(Icons.delete, size: 20, color: Colors.black), // Icon
              label: const Text(
                "Delete",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: Colors.black),
              ),
              onPressed: () async {
                print("selected Ids - "+_selectedQuestionIds);
                onDelete("you want to delete this conversation?");
              },
            ):SizedBox(),
          ],),
          Scrollbar(
              thumbVisibility: true,
              controller: _verticalScrollController,
              child: SingleChildScrollView(
                  controller: _verticalScrollController,
                  scrollDirection: Axis.vertical,
                  child: Scrollbar(
                      thumbVisibility: true,
                      scrollbarOrientation: ScrollbarOrientation.bottom,
                      controller: _horizontalScrollController,
                      child: PaginatedDataTable(
                        columns: [
                          DataColumn(
                            label: Row(
                              children: [
                                Checkbox(
                                  value: _dataSource.isSelectAll, // Use the data source's select-all state
                                  onChanged: (bool? value) {
                                    _dataSource.toggleSelectAll(value!);
                                    setState(() {}); // Update UI
                                  },
                                ),
                                Text("Select All"),
                              ],
                            ),
                          ),
                          DataColumn(label: Text("Question Type")),
                          DataColumn(label: Text("Title")),
                          DataColumn(label: Text("Bot Conversation")),
                          DataColumn(label: Text("User Conversation")),
                          DataColumn(label: Text("User Conversation Type")),
                          DataColumn(label: Text("Options")),
                          DataColumn(label: Text("Answer")),
                          DataColumn(label: Text("Points")),
                          DataColumn(label: Text("Index")),
                          DataColumn(label: Text("Edit")),
                        ],
                        source: _dataSource,
                        rowsPerPage: _rowsPerPage,
                        onRowsPerPageChanged: (value) {
                          setState(() {
                            _rowsPerPage = value!;
                          });
                        },
                      )
                  )))
        ]));
  }

  void onDelete(String title) {
    showDialog(
      context: context,
      builder: (context) => CustomAlertDialog(
        title: 'Are you sure',
        content: title,
        yesText: 'Yes',
        noText: 'No', onYesPressed: () {
        Navigator.pop(context);
        // _getdeleteApiController.delete_conversation(conversation_id: _selectedQuestionIds);
        Future.delayed(const Duration(seconds: 2), () {
          _removeSelectedQuestions();
          _getdeleteApiController.getConversation(
              main_category_id:widget.main_category_id,
              sub_category_id: widget.sub_category_id,
              topic_id: widget.topic_id,sub_topic_id: widget.sub_topic_id);
        });
      },
      ),
    );
  }
}

// DataTableSource for handling data in the DataTable
class QuestionDataSource extends DataTableSource {
  final List<Data> questions;
  final Function(String) onSelectionChanged; // Callback for selection
  final Set<String> selectedQuestionIds = {}; // Track selected question IDs
  bool isSelectAll = false;
  BuildContext context;

  QuestionDataSource(this.questions, this.onSelectionChanged, this.context);
  TextEditingController? titleController;
  TextEditingController? botConversationController;
  TextEditingController? userConversationController;
  TextEditingController? userConversationTypeController;
  TextEditingController? optionsController;
  TextEditingController? answerController;
  QuestionController addQuestionController = Get.find();

  @override
  DataRow? getRow(int index) {
    if (index >= questions.length) return null;
    final question = questions[index];
    final isSelected = selectedQuestionIds.contains(question.id);

    return DataRow(
      selected: isSelected,
      cells: [
        // Checkbox Cell
        DataCell(
          Checkbox(
            value: isSelected,
            onChanged: (bool? value) {
              if (value == true) {
                selectedQuestionIds.add(question.id!);
              } else {
                selectedQuestionIds.remove(question.id);
              }
              isSelectAll = selectedQuestionIds.length == questions.length;
              onSelectionChanged(selectedQuestionIds.join('|'));
              notifyListeners(); // Update UI
            },
          ),
        ),
        // Editable Question Type Cell
        DataCell(
           Text(question.questionType ?? ""),
        ),
        // Editable Title Cell
        DataCell(
          question.isEditing
              ? TextField(
            controller: titleController??=TextEditingController(text: question.title),
            onSubmitted: (value) {
              question.title = value;
              question.isEditing = false;
              notifyListeners(); // Update UI
            },
          )
              : GestureDetector(
            onTap: () {
              question.isEditing = true;
              notifyListeners();
            },
            child: Text(question.title ?? ""),
          ),
        ),
        // Editable Bot Conversation Cell
        DataCell(
          question.isEditing
              ? TextField(
            controller:botConversationController??=
            TextEditingController(text: question.botConversation),
            onSubmitted: (value) {
              question.botConversation = value;
              question.isEditing = false;
              //notifyListeners();
            },
          )
              : GestureDetector(
            onTap: () {
              question.isEditing = true;
              //notifyListeners();
            },
            child: Text(question.botConversation ?? ""),
          ),
        ),
        // Editable User Conversation Cell
        DataCell(
          question.isEditing
              ? TextField(
            controller:userConversationController??=
            TextEditingController(text: question.userConversation),
            onSubmitted: (value) {
              question.userConversation = value;
              question.isEditing = false;
              //notifyListeners();
            },
          )
              : GestureDetector(
            onTap: () {
              question.isEditing = true;
              //notifyListeners();
            },
            child: Text(question.userConversation ?? ""),
          ),
        ),
        // Editable User Conversation Type Cell
        DataCell(
          question.isEditing
              ? TextField(
            controller:userConversationTypeController??=
            TextEditingController(text: question.userConversationType),
            onSubmitted: (value) {
              question.userConversationType = value;
              question.isEditing = false;
              //notifyListeners();
            },
          )
              : GestureDetector(
            onTap: () {
              question.isEditing = true;
              //notifyListeners();
            },
            child: Text(question.userConversationType ?? ""),
          ),
        ),
        // Editable Options Cell
        DataCell(
          question.isEditing
              ? TextField(
            controller: optionsController??=TextEditingController(text: question.options),
            onSubmitted: (value) {
              question.options = value;
              question.isEditing = false;
              //notifyListeners();
            },
          )
              : GestureDetector(
            onTap: () {
              question.isEditing = true;
              //notifyListeners();
            },
            child: Text(question.options ?? ""),
          ),
        ),
        // Editable Answer Cell
        DataCell(
          question.isEditing
              ? TextField(
            controller: answerController??=TextEditingController(text: question.answer),
            onSubmitted: (value) {
              question.answer = value;
              question.isEditing = false;
              //notifyListeners();
            },
          )
              : GestureDetector(
            onTap: () {
              question.isEditing = true;
              //notifyListeners();
            },
            child: Text(question.answer ?? ""),
          ),
        ),
        // Static Points Cell
        DataCell(Text(question.points.toString() ?? "")),
        // Static Index Cell
        DataCell(Text(question.index.toString())),
        // Edit Button Cell
        DataCell(
          InkWell(
            onTap: () {
              if(question.isEditing == true) {
                question.isEditing=false;
                notifyListeners();
                addQuestionController.editConversation(
                    conversation_id:question.id,
                    main_category_id: question.mainCategoryId!,
                    sub_category_id: question.subCategoryId!,
                    sub_topic_id: question.subTopicId!,
                    topic_id: question.topicId!,
                    question_type: question.questionType!,
                    title: titleController!.text,
                    bot_conversation: botConversationController!.text,
                    user_conversation: userConversationController!.text,
                    user_conversation_type: userConversationTypeController!.text,
                    option: optionsController!.text,
                    answer: answerController!.text,
                    index: question.index.toString(),
                    points: question.points.toString());
              }else{
                question.isEditing=true;
                notifyListeners();
              }
            },
            child:question.isEditing
                ?const Text(
              'Save',
              style: TextStyle(color: Colors.blue),
            ): const Text(
              'Click Here to edit',
              style: TextStyle(color: Colors.blue),
            ),
          ),
        ),
      ],
    );
  }


  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => questions.length;

  @override
  int get selectedRowCount => selectedQuestionIds.length;

  void toggleSelectAll(bool value) {
    isSelectAll = value;

    if (isSelectAll) {
      // Select all IDs
      selectedQuestionIds.addAll(
        questions.map((question) => question.id!).toList(),
      );
    } else {
      // Clear all selections
      selectedQuestionIds.clear();
    }

    onSelectionChanged(selectedQuestionIds.join('|'));
    notifyListeners(); // Update UI
  }
}


