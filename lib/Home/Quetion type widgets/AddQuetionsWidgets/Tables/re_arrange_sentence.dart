import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../Global/constants/CustomTextField.dart';
import '../../controller/GetAllQuestionsApiController.dart';
import 'package:blissiqadmin/Home/Quetion%20type%20widgets/model/get_rearrange_model.dart';

class Re_Arrange_Sentence_QuestionTableScreen extends StatefulWidget {
  final String main_category_id;
  final String sub_category_id;
  final String topic_id;
  final String sub_topic_id;
  final List<ReArrange> questionList;

  Re_Arrange_Sentence_QuestionTableScreen({
    required this.main_category_id,
    required this.sub_category_id,
    required this.topic_id,
    required this.sub_topic_id,
    required this.questionList,
  });

  @override
  _QuestionTableScreenState createState() => _QuestionTableScreenState();
}

class _QuestionTableScreenState extends State<Re_Arrange_Sentence_QuestionTableScreen> {
  TextEditingController _searchController = TextEditingController();
  List<ReArrange> _filteredQuestions = [];
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  final _verticalScrollController = ScrollController();
  final _horizontalScrollController = ScrollController();
  String _selectedQuestionIds = "";
  bool isSelectAll = false;
  List<String> selected_question_ids = [];
  late QuestionDataSource _dataSource;
  final GetAllQuestionsApiController _getdeleteApiController = Get.find();

  @override
  void initState() {
    super.initState();
    _dataSource = QuestionDataSource(
      widget.questionList,
          (selectedIds) {
        setState(() {
          _selectedQuestionIds = selectedIds;
        });
      },
      context, // Pass context to the data source
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
        question.question != null &&
            question.question!.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }

      _dataSource = QuestionDataSource(
        _filteredQuestions,
            (selectedIds) {
          setState(() {
            _selectedQuestionIds = selectedIds;
          });
        },
        context, // Pass context to the data source
      );
    });
  }

  void _removeSelectedQuestions() {
    final selectedIdsSet = _selectedQuestionIds.split('|').toSet();
    if (mounted) {
      setState(() {
        _filteredQuestions.removeWhere(
                (question) => selectedIdsSet.contains(question.id));
        _selectedQuestionIds = '';
        _dataSource = QuestionDataSource(
          _filteredQuestions,
              (selectedIds) {
            setState(() {
              _selectedQuestionIds = selectedIds;
            });
          },
          context, // Pass context to the data source
        );
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.54,
        height: MediaQuery.of(context).size.width * 0.42,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              spreadRadius: 2,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child:
                      CustomTextField(
                        controller: _searchController,
                        labelText: "Search by Question",
                        onChanged: _filterQuestions,
                      )
                  ),
                ),
                if (_selectedQuestionIds.isNotEmpty)
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade100,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    icon: const Icon(Icons.delete, color: Colors.red),
                    label: const Text(
                      "Delete",
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () async {
                      print("Selected Ids - $_selectedQuestionIds");
                      Future.delayed(const Duration(seconds: 1), () async {
                        //_removeSelectedQuestions();
                        bool confirmed = await _dataSource._showConfirmationDialog(context);
                        if(confirmed){
                          _dataSource._deleteSelectedQuestions();
                        }
                        _getdeleteApiController.getAllRe_Arrange(
                          main_category_id: widget.main_category_id,
                          sub_category_id: widget.sub_category_id,
                          topic_id: widget.topic_id,
                          sub_topic_id: widget.sub_topic_id,
                        );
                      });
                    },
                  ),
              ],
            ),
            const SizedBox(height: 20),
            // Paginated DataTable
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Scrollbar(
                  thumbVisibility: true,
                  controller: _verticalScrollController,
                  child: SingleChildScrollView(
                    controller: _verticalScrollController,
                    child: PaginatedDataTable(
                      headingRowHeight: 48,
                      columnSpacing: 20,
                      horizontalMargin: 16,
                      rowsPerPage: _rowsPerPage,
                      onRowsPerPageChanged: (value) {
                        setState(() {
                          _rowsPerPage = value!;
                        });
                      },
                      dataRowHeight: 56,
                      header: Text(
                        "Questions Table",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.blue.shade700,
                        ),
                      ),
                      columns: [
                        DataColumn(
                          label: Row(
                            children: [
                              Checkbox(
                                value: _dataSource.isSelectAll,
                                onChanged: (bool? value) {
                                  _dataSource.toggleSelectAll(value!);
                                  setState(() async {});
                                },
                              ),
                              const Text("Select All"),
                            ],
                          ),
                        ),
                        DataColumn(label: Text("Question Type")),
                        DataColumn(label: Text("Title")),
                        DataColumn(label: Text("Re_Arrange Word")),
                        DataColumn(label: Text("Points")),
                        DataColumn(label: Text("Question Image")),
                        DataColumn(label: Text("Edit")),
                      ],
                      source: _dataSource,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}

class QuestionDataSource extends DataTableSource {
  final List<ReArrange> questions;
  final Function(String) onSelectionChanged;
  //final BuildContext context;
  final Set<String> selectedQuestionIds = {};
  bool isSelectAll = false;
  BuildContext context;

  int? editingRowIndex; // Track which row is being edited
  List<TextEditingController> questionTypeControllers = [];
  List<TextEditingController> titleControllers = [];
  List<TextEditingController> questionControllers = [];
  List<TextEditingController> questionImageControllers = [];
  //List<TextEditingController> answerControllers = [];
  //List<TextEditingController> indexControllers = [];
  List<TextEditingController> pointsControllers = [];

  final GetAllQuestionsApiController updateQueApiController = Get.find();

  QuestionDataSource(this.questions, this.onSelectionChanged, this.context) {

    // Initialize controllers for each question
    for (var question in questions) {

      questionTypeControllers.add(TextEditingController(text: question.questionType));

      titleControllers.add(TextEditingController(text: question.title));

      questionControllers.add(TextEditingController(text: question.question));

      questionImageControllers.add(TextEditingController(text: question.qImage));

      //answerControllers.add(TextEditingController(text: question.answer));

      //indexControllers.add(TextEditingController(text: question.index.toString()));

      pointsControllers.add(TextEditingController(text: question.points.toString()));
    }
    // Initialize controllers for each question
  }

  @override
  DataRow? getRow(int index) {
    if (index >= questions.length) return null;
    final question = questions[index];
    final isSelected = selectedQuestionIds.contains(question.id);

    return DataRow(
      selected: isSelected,
      cells: [
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
              onSelectionChanged(
                selectedQuestionIds.join('|'),
              );
              notifyListeners();
            },
          ),
        ),

        DataCell(
          editingRowIndex == index
              ? TextField(
            controller: questionTypeControllers[index],
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
            onSubmitted: (value) {
              _updateQuestion(
                index,
                value,
                titleControllers[index].text,
                questionControllers[index].text,
                pointsControllers[index].text,
                questionImageControllers[index].text,
              );
            },
          )
              : Text(question.questionType ?? ""),
        ),
        DataCell(
          editingRowIndex == index
              ? TextField(
            controller: titleControllers[index],
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
            onSubmitted: (value) {
              _updateQuestion(
                index,
                questionTypeControllers[index].text,
                value,
                questionControllers[index].text,
                pointsControllers[index].text,
                questionImageControllers[index].text,
              );
            },
          )
              : Text(question.title ?? ""),
        ),
        DataCell(
          editingRowIndex == index
              ? TextField(
            controller: questionControllers[index],
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
            onSubmitted: (value) {
              _updateQuestion(
                index,
                questionTypeControllers[index].text,
                titleControllers[index].text,
                value,
                pointsControllers[index].text,
                questionImageControllers[index].text,
              );
            },
          )
              : Text(question.question ?? ""),
        ),
        DataCell(
          editingRowIndex == index
              ? TextField(
            controller: pointsControllers[index],
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
            onSubmitted: (value) {
              _updateQuestion(
                index,
                questionTypeControllers[index].text,
                titleControllers[index].text,
                questionControllers[index].text,
                value,
                questionImageControllers[index].text,
              );
            },
          )
              : Text(question.points?.toString() ?? ""),
        ),

        DataCell(
          editingRowIndex == index
              ? TextField(
            controller: questionImageControllers[index],
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
            onSubmitted: (value) {
              _updateQuestion(
                index,
                questionTypeControllers[index].text,
                titleControllers[index].text,
                questionControllers[index].text,
                pointsControllers[index].text,
                value,
              );
            },
          )
              : Text(question.qImage ?? ""),
        ),

        DataCell(
          editingRowIndex == index
              ? ElevatedButton(
            onPressed: () {
              _updateQuestion(
                index,
                questionTypeControllers[index].text,
                titleControllers[index].text,
                questionControllers[index].text,
                pointsControllers[index].text,
                questionImageControllers[index].text,
              );
              editingRowIndex = null; // Exit edit mode
              notifyListeners(); // Update UI
            },
            child: const Text("Update"),
          )
              : GestureDetector(
            onTap: () {
              if (editingRowIndex == null) {
                // Start editing
                editingRowIndex = index;
                notifyListeners(); // Update UI
              }
            },
            child: const Text(
              "Edit",
              style: TextStyle(
                color: Colors.blue,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// call the update the story phrases api here
  /// Update the story phrases API here
  _updateQuestion(
      int index,
      String questionType,
      String title,
      String question,
      String pointsValue,
      String questionImage,
      ) async {
    final updatedQuestion = ReArrange(
      id: questions[index].id, // Keep the same ID
      questionType: questionType,
      // index: int.tryParse(title) ?? questions[index].index, // Update index
      title: title,
      question:question,
      qImage:questionImage,
      points: int.tryParse(pointsValue) ?? questions[index].points, // Update points
      mainCategoryId: questions[index].mainCategoryId,
      subCategoryId: questions[index].subCategoryId,
      topicId: questions[index].topicId,
      subTopicId: questions[index].subTopicId,
    );

    questions[index] = updatedQuestion;

    try {
      await updateQueApiController.updateRearrangeTheWordTableQuestionApi(updatedQuestion);
      notifyListeners();
    } catch (e) {
      print('Error updating question: $e');
    }
  }

  /// Delete the story phrases API here
  _deleteSelectedQuestions() async {
    final deleteApiController = Get.find<GetAllQuestionsApiController>();

    if (selectedQuestionIds.isNotEmpty) {
      try {
        await deleteApiController.deleteReArrangeAPI(

          question_id: questions[0].mainCategoryId.toString(),
          // sub_category_id: questions[0].subCategoryId.toString(),
          // topic_id: questions[0].topicId.toString(),
          // sub_topic_id: questions[0].subTopicId.toString(),
          //
          //phrase_id: questions[0].phrase_ids.toString(),

        );

        // Refresh the list of questions
        await deleteApiController.getAllRe_Arrange(
          main_category_id: questions[0].mainCategoryId.toString(),
          sub_category_id: questions[0].subCategoryId.toString(),
          topic_id: questions[0].topicId.toString(),
          sub_topic_id: questions[0].subTopicId.toString(),
        );

        questions.removeWhere((question) => selectedQuestionIds.contains(question.id));
        selectedQuestionIds.clear(); // Clear selected IDs
        notifyListeners(); // Update UI
      } catch (e) {
        print('Error deleting questions: $e');
      }
    }
  }


  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => questions.length;

  @override
  int get selectedRowCount => selectedQuestionIds.length;

  toggleSelectAll(bool value) async {
    isSelectAll = value;

    if (isSelectAll) {
      // Select all IDs
      selectedQuestionIds.addAll(
        questions.map((question) => question.id!).toList(),
      );
    } else {
      bool confirmed = await _showConfirmationDialog(context);
      if(confirmed){
        _deleteSelectedQuestions();
      }
      selectedQuestionIds.clear();
    }

    onSelectionChanged(selectedQuestionIds.join('|'));
    notifyListeners(); // Update UI
  }

  _showConfirmationDialog(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Do you really want to delete the selected phrases?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // User pressed "No"
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // User pressed "Yes"
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    ) ?? false; // Default to false if dialog is dismissed
  }
}
