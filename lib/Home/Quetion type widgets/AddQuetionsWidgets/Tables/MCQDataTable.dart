import 'package:blissiqadmin/Global/constants/CustomTextField.dart';
import 'package:blissiqadmin/Home/Quetion%20type%20widgets/controller/GetAllQuestionsApiController.dart';
import 'package:blissiqadmin/Home/Quetion%20type%20widgets/model/get_mcqs.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class MCQ_QuestionTableScreen extends StatefulWidget {
  final String main_category_id;
  final String sub_category_id;
  final String topic_id;
  final String sub_topic_id;
  final List<Mcqs> questionList;

  MCQ_QuestionTableScreen(
      {required this.main_category_id,
      required this.sub_category_id,
      required this.topic_id,
      required this.sub_topic_id,
      required this.questionList});

  @override
  _QuestionTableScreenState createState() => _QuestionTableScreenState();
}

class _QuestionTableScreenState extends State<MCQ_QuestionTableScreen> {
  TextEditingController _searchController = TextEditingController();
  //List<Mcqs> _questions = []; // Original data
  List<Mcqs> _filteredQuestions = []; // Filtered data for the table
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
      },context,
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
      _dataSource = QuestionDataSource(
        _filteredQuestions,
            (selectedIds) {
          setState(() {
            _selectedQuestionIds = selectedIds;
          });
        }, context,
      );
    });
  }

  void _removeSelectedQuestions() {
    // Convert the selected IDs string to a Set for efficient lookup
    final selectedIdsSet = _selectedQuestionIds.split('|').toSet();
    if(mounted){
    setState(() {
      // Remove matching items from the main list

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
        },context,
      );
    });}
  }


  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.54,
        height: MediaQuery.of(context).size.width * 0.32,
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
                      Future.delayed(const Duration(seconds: 1), () {
                        _removeSelectedQuestions();
                        _getdeleteApiController.getAllMCQS(
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
                        const DataColumn(label: Text("Title")),
                        const DataColumn(label: Text("Question")),
                        const DataColumn(label: Text("Option 1")),
                        const DataColumn(label: Text("Option 2")),
                        const DataColumn(label: Text("Option 3")),
                        const DataColumn(label: Text("Option 4")),
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

class QuestionDataSource extends DataTableSource {
  final List<Mcqs> questions;
  final Function(String) onSelectionChanged; // Callback for selection
  final Set<String> selectedQuestionIds = {}; // Track selected question IDs
  bool isSelectAll = false; // Track "Select All" state
  BuildContext context;

  int? editingRowIndex; // Track which row is being edited
  List<TextEditingController> questionTypeControllers = [];
  List<TextEditingController> titleControllers = [];
  List<TextEditingController> questionControllers = [];
  List<TextEditingController> optionAControllers = [];
  List<TextEditingController> optionBControllers = [];
  List<TextEditingController> optionCControllers = [];
  List<TextEditingController> optionDControllers = [];
  List<TextEditingController> answerControllers = [];
  List<TextEditingController> pointsControllers = [];
  List<TextEditingController> indexControllers = [];

  final GetAllQuestionsApiController updateQueApiController = Get.find();


  QuestionDataSource(this.questions, this.onSelectionChanged, this.context) {
    // Initialize controllers for each question
    for (var question in questions) {
      questionTypeControllers.add(TextEditingController(text: question.questionType));
      titleControllers.add(TextEditingController(text: question.title));
      questionControllers.add(TextEditingController(text: question.question));
      optionAControllers.add(TextEditingController(text: question.optionA));
      optionBControllers.add(TextEditingController(text: question.optionB));
      optionCControllers.add(TextEditingController(text: question.optionC));
      optionDControllers.add(TextEditingController(text: question.optionD));
      answerControllers.add(TextEditingController(text: question.answer));
      pointsControllers.add(TextEditingController(text: question.points.toString()));
      indexControllers.add(TextEditingController(text: question.index.toString()));
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
              onSelectionChanged(selectedQuestionIds.join('|'));
              notifyListeners();
            },
          ),
        ),
        _editableDataCell(
          index: index,
          controller: indexControllers[index],
          initialValue: question.index.toString(),
          onSubmit: (value) {
            _updateQuestion(index, newIndex: value);
          },
        ),
        _editableDataCell(
          index: index,
          controller: questionTypeControllers[index],
          initialValue: question.questionType ?? "",
          onSubmit: (value) {
            _updateQuestion(index, questionType: value);
          },
        ),
        _editableDataCell(
          index: index,
          controller: titleControllers[index],
          initialValue: question.title ?? "",
          onSubmit: (value) {
            _updateQuestion(index, title: value);
          },
        ),
        _editableDataCell(
          index: index,
          controller: questionControllers[index],
          initialValue: question.question ?? "",
          onSubmit: (value) {
            _updateQuestion(index, question: value);
          },
        ),
        _editableDataCell(
          index: index,
          controller: optionAControllers[index],
          initialValue: question.optionA ?? "",
          onSubmit: (value) {
            _updateQuestion(index, optionA: value);
          },
        ),
        _editableDataCell(
          index: index,
          controller: optionBControllers[index],
          initialValue: question.optionB ?? "",
          onSubmit: (value) {
            _updateQuestion(index, optionB: value);
          },
        ),
        _editableDataCell(
          index: index,
          controller: optionCControllers[index],
          initialValue: question.optionC ?? "",
          onSubmit: (value) {
            _updateQuestion(index, optionC: value);
          },
        ),
        _editableDataCell(
          index: index,
          controller: optionDControllers[index],
          initialValue: question.optionD ?? "",
          onSubmit: (value) {
            _updateQuestion(index, optionD: value);
          },
        ),
        _editableDataCell(
          index: index,
          controller: answerControllers[index],
          initialValue: question.answer ?? "",
          onSubmit: (value) {
            _updateQuestion(index, answer: value);
          },
        ),
        _editableDataCell(
          index: index,
          controller: pointsControllers[index],
          initialValue: question.points.toString(),
          onSubmit: (value) {
            _updateQuestion(index, points: value);
          },
        ),
        DataCell(
          GestureDetector(
            onTap: () {

            },
            child: const Text(
              "View",
              style: TextStyle(
                color: Colors.blue,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ),
        DataCell(
          editingRowIndex == index
              ? ElevatedButton(
            onPressed: () {
              _updateQuestion(
                index,
                questionType: questionTypeControllers[index].text,
                title: titleControllers[index].text,
                question: questionControllers[index].text,
                optionA: optionAControllers[index].text,
                optionB: optionBControllers[index].text,
                optionC: optionCControllers[index].text,
                optionD: optionDControllers[index].text,
                answer: answerControllers[index].text,
                points: pointsControllers[index].text,
                newIndex: indexControllers[index].text,
              );
              editingRowIndex = null;
              notifyListeners();
            },
            child: const Text("Update"),
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
  Future<void> _updateQuestion(
      int index, {
        String? questionType,
        String? title,
        String? question,
        String? optionA,
        String? optionB,
        String? optionC,
        String? optionD,
        String? answer,
        String? points,
        String? newIndex,
      }) async {
    final updatedQuestion = Mcqs(
      id: questions[index].id,
      mainCategoryId: questions[index].mainCategoryId,
      subCategoryId: questions[index].subCategoryId,
      topicId: questions[index].topicId,
      subTopicId: questions[index].subTopicId,
      questionType: questionType ?? questions[index].questionType,
      title: title ?? questions[index].title,
      question: question ?? questions[index].question,
      optionA: optionA ?? questions[index].optionA,
      optionB: optionB ?? questions[index].optionB,
      optionC: optionC ?? questions[index].optionC,
      optionD: optionD ?? questions[index].optionD,
      answer: answer ?? questions[index].answer,
      points: int.tryParse(points ?? "") ?? questions[index].points,
      index: int.tryParse(newIndex ?? "") ?? questions[index].index,
    );

    questions[index] = updatedQuestion;
    await updateQueApiController.updateMcqQuestionAPI(updatedQuestion);
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
        await deleteApiController.delete_Mcq(
          question_ids: selectedQuestionIds.join('|'), // Pipe-separated IDs
        );

        // Optionally, refresh the list of questions after deletion
        await deleteApiController.getAllMCQS(
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


/// DataTableSource for handling data in the DataTable
// class QuestionDataSource extends DataTableSource {
//   final List<Mcqs> questions;
//   final Function(String) onSelectionChanged; // Callback for selection
//   final Set<String> selectedQuestionIds = {}; // Track selected question IDs
//   bool isSelectAll = false; // Track "Select All" state
//
//   QuestionDataSource(this.questions, this.onSelectionChanged);
//
//   @override
//   DataRow? getRow(int index) {
//     if (index >= questions.length) return null;
//     final question = questions[index];
//     final isSelected = selectedQuestionIds.contains(question.id);
//
//     return DataRow(
//       selected: isSelected,
//       cells: [
//         DataCell(
//           Checkbox(
//             value: isSelected,
//             onChanged: (bool? value) {
//               if (value == true) {
//                 selectedQuestionIds.add(question.id!);
//               } else {
//                 selectedQuestionIds.remove(question.id);
//               }
//               isSelectAll = selectedQuestionIds.length == questions.length;
//               onSelectionChanged(
//                 selectedQuestionIds.join('|'),
//               );
//               notifyListeners();
//             },
//           ),
//         ),
//
//         DataCell(Text(question.questionType ?? "")),
//         DataCell(Text(question.title ?? "")),
//         DataCell(Text(question.question ?? "")),
//         DataCell(Text(question.optionA ?? "")),
//         DataCell(Text(question.optionB ?? "")),
//         DataCell(Text(question.optionC ?? "")),
//         DataCell(Text(question.optionD ?? "")),
//         DataCell(Text(question.answer ?? "")),
//         DataCell(Text(question.points.toString())),
//
//         DataCell(
//           GestureDetector(
//             onTap: () {
//
//             },
//             child: const Text(
//               "View",
//               style: TextStyle(
//                 color: Colors.blue,
//                 decoration: TextDecoration.underline,
//               ),
//             ),
//           ),
//         ),
//         DataCell(
//           GestureDetector(
//             onTap: () {
//
//             },
//             child: const Text(
//               "Edit",
//               style: TextStyle(
//                 color: Colors.blue,
//                 decoration: TextDecoration.underline,
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   @override
//   bool get isRowCountApproximate => false;
//
//   @override
//   int get rowCount => questions.length;
//
//   @override
//   int get selectedRowCount => selectedQuestionIds.length;
//
//   void toggleSelectAll(bool value) {
//     isSelectAll = value;
//
//     if (isSelectAll) {
//       // Select all IDs
//       selectedQuestionIds.addAll(
//         questions.map((question) => question.id!).toList(),
//       );
//     } else {
//       // Clear all selections
//       selectedQuestionIds.clear();
//     }
//
//     onSelectionChanged(selectedQuestionIds.join('|'));
//     notifyListeners(); // Update UI
//   }
// }


