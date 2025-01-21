import 'package:blissiqadmin/Global/constants/CustomTextField.dart';
import 'package:blissiqadmin/Home/Quetion%20type%20widgets/controller/GetAllQuestionsApiController.dart';
import 'package:blissiqadmin/Home/Quetion%20type%20widgets/model/get_mcqs.dart';
import 'package:blissiqadmin/Home/Quetion%20type%20widgets/model/get_trueOrfalse_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TrueFalseDataTable extends StatefulWidget {
  final String main_category_id;
  final String sub_category_id;
  final String topic_id;
  final String sub_topic_id;
  final List<TrueOrFalse> questionList;

  TrueFalseDataTable(
      {required this.main_category_id,
      required this.sub_category_id,
      required this.topic_id,
      required this.sub_topic_id,
      required this.questionList});

  @override
  _TrueFalseDataTableState createState() => _TrueFalseDataTableState();
}

class _TrueFalseDataTableState extends State<TrueFalseDataTable> {
  TextEditingController _searchController = TextEditingController();
  List<TrueOrFalse> _filteredQuestions = [];
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  final _verticalScrollController = ScrollController();
  final _horizontalScrollController = ScrollController();
  String _selectedQuestionIds = "";
  bool isSelectAll = false;
  List<String> selected_question_ids = [];
  late TrueFalseDataSource _dataSource;
  final GetAllQuestionsApiController _getdeleteApiController = Get.find();

  @override
  void initState() {
    super.initState();
    // Initialize with API data
    _dataSource = TrueFalseDataSource(
      widget.questionList,
      (selectedIds) {
        setState(() {
          _selectedQuestionIds = selectedIds;
        });
      },
      context,
    );
    //_questions = widget.questionList;
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
      // Update the data source with the filtered questions
      _dataSource = TrueFalseDataSource(
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
    if (mounted) {
      setState(() {
        // Remove matching items from the main list

        // Remove matching items from the filtered list
        _filteredQuestions
            .removeWhere((mcq) => selectedIdsSet.contains(mcq.id));

        // Clear selected IDs after deletion
        _selectedQuestionIds = '';

        // Update the data source with the updated filtered list
        _dataSource = TrueFalseDataSource(
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: CustomTextField(
                        controller: _searchController,
                        labelText: "Search by Question",
                        onChanged: _filterQuestions,
                      )),
                ),
                if (_selectedQuestionIds.isNotEmpty)
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade100,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
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
                      Future.delayed(const Duration(seconds: 1), () {
                        _removeSelectedQuestions();
                        _getdeleteApiController.getTrueORFalse(
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
                                  setState(() {});
                                },
                              ),
                              const Text("Select All"),
                            ],
                          ),
                        ),
                        const DataColumn(label: Text("Index")),
                        const DataColumn(label: Text("Question Type")),
                        const DataColumn(label: Text("Question")),
                        const DataColumn(label: Text("Answer")),
                        const DataColumn(label: Text("Points")),
                        const DataColumn(label: Text("Question Image")),
                        const DataColumn(label: Text("Edit")),
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

// DataTableSource for handling data in the DataTable
class TrueFalseDataSource extends DataTableSource {
  final List<TrueOrFalse> questions;
  final Function(String) onSelectionChanged; // Callback for selection
  final Set<String> selectedQuestionIds = {}; // Track selected question IDs
  bool isSelectAll = false; // Track "Select All" state
  BuildContext context;

  int? editingRowIndex; // Track which row is being edited
  List<TextEditingController> questionTypeControllers = [];
  List<TextEditingController> questionControllers = [];
  List<TextEditingController> answerControllers = [];
  List<TextEditingController> pointsControllers = [];
  List<TextEditingController> indexControllers = [];

  final GetAllQuestionsApiController updateQueApiController = Get.find();

  TrueFalseDataSource(this.questions, this.onSelectionChanged, this.context) {
    // Initialize controllers for each question
    for (var question in questions) {
      questionTypeControllers
          .add(TextEditingController(text: question.questionType));
      questionControllers.add(TextEditingController(text: question.question));
      answerControllers.add(TextEditingController(text: question.answer));
      pointsControllers
          .add(TextEditingController(text: question.points.toString()));
      indexControllers
          .add(TextEditingController(text: question.index.toString()));
    }
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
                  selectedQuestionIds.join('|')); // Pipe-separated IDs
              notifyListeners();
            },
          ),
        ),

        _editableDataCell(
          index: index,
          controller: indexControllers[index],
          initialValue: question.index.toString(),
          onSubmit: (value) {
            _updateQuestion(
              index,
              questionTypeControllers[index].text,
              questionControllers[index].text,
              answerControllers[index].text,
              pointsControllers[index].text,
              value,
            );
          },
        ),

        _editableDataCell(
          index: index,
          controller: questionTypeControllers[index],
          initialValue: question.questionType.toString(),
          onSubmit: (value) {
            _updateQuestion(
              index,
              value,
              questionControllers[index].text,
              answerControllers[index].text,
              pointsControllers[index].text,
              indexControllers[index].text,
            );
          },
        ),

        _editableDataCell(
          index: index,
          controller: questionControllers[index],
          initialValue: question.question.toString(),
          onSubmit: (value) {
            _updateQuestion(
              index,
              questionTypeControllers[index].text,
              value,
              answerControllers[index].text,
              pointsControllers[index].text,
              indexControllers[index].text,
            );
          },
        ),

        _editableDataCell(
          index: index,
          controller: answerControllers[index],
          initialValue: question.answer.toString(),
          onSubmit: (value) {
            _updateQuestion(
              index,
              questionTypeControllers[index].text,
              questionControllers[index].text,
              value,
              pointsControllers[index].text,
              indexControllers[index].text,
            );
          },
        ),

        _editableDataCell(
          index: index,
          controller: pointsControllers[index],
          initialValue: question.points.toString(),
          onSubmit: (value) {
            _updateQuestion(
              index,
              questionTypeControllers[index].text,
              questionControllers[index].text,
              answerControllers[index].text,
              value,
              indexControllers[index].text,
            );
          },
        ),

        DataCell(TextButton(onPressed: () {}, child: Text('View'))),

        DataCell(
          editingRowIndex == index
              ? ElevatedButton(
                  onPressed: () {
                    _updateQuestion(
                      index,
                      questionTypeControllers[index].text,
                      questionControllers[index].text,
                      answerControllers[index].text,
                      pointsControllers[index].text,
                      indexControllers[index].text,
                    );
                    editingRowIndex = null; // Exit edit mode
                    notifyListeners();
                  },
                  child: Text("Update"),
                )
              : GestureDetector(
                  onTap: () {
                    if (editingRowIndex == null) {
                      editingRowIndex = index; // Start editing
                      notifyListeners();
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

  /// Helper for creating editable data cells
  DataCell _editableDataCell({
    required int index,
    required TextEditingController controller,
    required String initialValue,
    required Function(String) onSubmit,
  }) {
    return DataCell(
      editingRowIndex == index
          ? TextField(
              controller: controller,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              onSubmitted: onSubmit,
            )
          : Text(initialValue),
    );
  }

  /// Update the question's data
  _updateQuestion(int index, String questionType, String question, String answer, String points, String indexValue) async {
    final updatedQuestion = TrueOrFalse(
      id: questions[index].id, // Keep the same ID
      mainCategoryId: questions[index].mainCategoryId,
      subCategoryId: questions[index].subCategoryId,
      topicId: questions[index].topicId,
      subTopicId: questions[index].subTopicId,
      questionType: questionType,
      question: question,
      answer: answer,
      points: int.tryParse(points) ?? questions[index].points,
      index: int.tryParse(indexValue) ?? questions[index].index,
    );

    questions[index] = updatedQuestion;
    await updateQueApiController
        .updateTrueFalseQuestionAPI(updatedQuestion); // API call to update
    notifyListeners();
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
      if (confirmed) {
        _deleteSelectedQuestions();
      }
      selectedQuestionIds.clear();
    }

    onSelectionChanged(selectedQuestionIds.join('|'));
    notifyListeners(); // Update UI
  }

  _deleteSelectedQuestions() async {
    final deleteApiController = Get.find<GetAllQuestionsApiController>();

    if (selectedQuestionIds.isNotEmpty) {
      try {
        await deleteApiController.deleteTrueFalseAPI(
          main_category_id: questions[0].mainCategoryId.toString(),
          sub_category_id: questions[0].subCategoryId.toString(),
          topic_id: questions[0].topicId.toString(),
          sub_topic_id: questions[0].subTopicId.toString(),
          truefalse_ids: selectedQuestionIds.join('|'), // Pipe-separated IDs
        );

        // Optionally, refresh the list of questions after deletion
        await deleteApiController.getTrueORFalse(
          main_category_id: questions[0].mainCategoryId.toString(),
          sub_category_id: questions[0].subCategoryId.toString(),
          topic_id: questions[0].topicId.toString(),
          sub_topic_id: questions[0].subTopicId.toString(),
        );

        // Remove the deleted questions from the local list
        questions.removeWhere(
            (question) => selectedQuestionIds.contains(question.id));
        selectedQuestionIds.clear(); // Clear the selected IDs after deletion
        notifyListeners(); // Update UI
      } catch (e) {
        print('Error deleting questions: $e');
      }
    }
  }

  _showConfirmationDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Confirm Deletion'),
              content: const Text(
                  'Do you really want to delete the selected true false question ?'),
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
        ) ??
        false;
  }

}
