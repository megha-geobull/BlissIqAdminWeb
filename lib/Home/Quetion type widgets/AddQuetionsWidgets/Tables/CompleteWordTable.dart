import 'package:blissiqadmin/Global/constants/CustomTextField.dart';
import 'package:blissiqadmin/Home/Quetion%20type%20widgets/controller/GetAllQuestionsApiController.dart';
import 'package:blissiqadmin/Home/Quetion%20type%20widgets/model/GetCompleteParagraphModel.dart';
import 'package:blissiqadmin/Home/Quetion%20type%20widgets/model/GetCompleteWordModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class CompleteWordTable extends StatefulWidget {
  final String main_category_id;
  final String sub_category_id;
  final String topic_id;
  final String sub_topic_id;
  final List<CompleteWordData> questionList;

  CompleteWordTable(
      {required this.main_category_id,
        required this.sub_category_id,
        required this.topic_id,
        required this.sub_topic_id,
        required this.questionList});

  @override
  _CompleteWordTableState createState() => _CompleteWordTableState();
}

class _CompleteWordTableState extends State<CompleteWordTable> {

  TextEditingController _searchController = TextEditingController();
  List<CompleteWordData> _filteredQuestions = [];
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
      }, context,
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
        },context,
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
                        _getdeleteApiController.getCompleteWordApi(
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
                        const DataColumn(label: Text("Question Type")),
                        const DataColumn(label: Text("Index")),
                        const DataColumn(label: Text("Title")),
                        const DataColumn(label: Text("Question")),

                        const DataColumn(label: Text("Option A")),
                        const DataColumn(label: Text("Option B")),
                        const DataColumn(label: Text("Option C")),
                        const DataColumn(label: Text("Option D")),

                        const DataColumn(label: Text("Answer")),
                        const DataColumn(label: Text("Points")),
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
  final List<CompleteWordData> questions;
  final Function(String) onSelectionChanged; // Callback for selection
  final Set<String> selectedQuestionIds = {}; // Track selected question IDs
  bool isSelectAll = false; // Track "Select All" state
  BuildContext context;

  int? editingRowIndex; // Track which row is being edited
  List<TextEditingController> indexControllers = [];
  List<TextEditingController> pointsControllers = [];
  List<TextEditingController> titleControllers = [];
  List<TextEditingController> questionControllers = [];
  List<TextEditingController> optionAControllers = [];
  List<TextEditingController> optionBControllers = [];
  List<TextEditingController> optionCControllers = [];
  List<TextEditingController> optionDControllers = [];
  List<TextEditingController> answerControllers = [];

  final GetAllQuestionsApiController updateQueApiController = Get.find();

  QuestionDataSource(this.questions, this.onSelectionChanged, this.context) {
    // Initialize controllers for each question
    for (var question in questions) {
      indexControllers.add(TextEditingController(text: question.index.toString()));
      pointsControllers.add(TextEditingController(text: question.points.toString()));
      titleControllers.add(TextEditingController(text: question.title));
      questionControllers.add(TextEditingController(text: question.question));
      optionAControllers.add(TextEditingController(text: question.optionA));
      optionBControllers.add(TextEditingController(text: question.optionB));
      optionCControllers.add(TextEditingController(text: question.optionC));
      optionDControllers.add(TextEditingController(text: question.optionD));
      answerControllers.add(TextEditingController(text: question.answer));
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
              notifyListeners(); // Update UI
            },
          ),
        ),

        DataCell(Text(question.questionType ?? "")),

        DataCell(
          editingRowIndex == index
              ? TextField(
            controller: indexControllers[index],
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
            onSubmitted: (value) {
              _updateQuestion(index, indexControllers[index].text, value, pointsControllers[index].text);
            },
          )
              : Text(question.index.toString()),
        ),

        DataCell(
          editingRowIndex == index
              ? TextField(
            controller: titleControllers[index],
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
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
          )
              : Text(question.question ?? ""),
        ),

        DataCell(
          editingRowIndex == index
              ? TextField(
            controller: optionAControllers[index],
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
          )
              : Text(question.optionA ?? ""),
        ),

        DataCell(
          editingRowIndex == index
              ? TextField(
            controller: optionBControllers[index],
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
          )
              : Text(question.optionB ?? ""),
        ),

        DataCell(
          editingRowIndex == index
              ? TextField(
            controller: optionCControllers[index],
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
          )
              : Text(question.optionC ?? ""),
        ),

        DataCell(
          editingRowIndex == index
              ? TextField(
            controller: optionDControllers[index],
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
          )
              : Text(question.optionD ?? ""),
        ),

        DataCell(
          editingRowIndex == index
              ? TextField(
            controller: answerControllers[index],
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
          )
              : Text(question.answer ?? ""),
        ),

        DataCell(
          editingRowIndex == index
              ? TextField(
            controller: pointsControllers[index],
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
            onSubmitted: (value) {
              _updateQuestion(index, indexControllers[index].text, indexControllers[index].text, value);
            },
          )
              : Text(question.points.toString()),
        ),

        DataCell(
          editingRowIndex == index
              ? ElevatedButton(
            onPressed: () {
              _updateQuestion(index, indexControllers[index].text, indexControllers[index].text, pointsControllers[index].text);
              editingRowIndex = null; // Exit edit mode
              notifyListeners();
            },
            child: const Text("Update"),
          )
              : GestureDetector(
            onTap: () {
              if (editingRowIndex == null) {
                editingRowIndex = index; // Start editing
                notifyListeners(); // Update UI
              }
            },
            child: const Text(
              "Edit",
              style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
            ),
          ),
        ),
      ],
    );
  }


  /// Update question API call
  _updateQuestion(int index, String phraseName, String indexValue, String pointsValue) async {
    final updatedQuestion = CompleteWordData(
      id: questions[index].id,
      mainCategoryId: questions[index].mainCategoryId,
      subCategoryId: questions[index].subCategoryId,
      topicId: questions[index].topicId,
      subTopicId: questions[index].subTopicId,
      questionType: phraseName,
      question: questionControllers[index].text,
      title: titleControllers[index].text,
      optionA: optionAControllers[index].text,
      optionB: optionBControllers[index].text,
      optionC: optionCControllers[index].text,
      optionD: optionDControllers[index].text,
      answer: answerControllers[index].text,
      index: int.tryParse(indexValue) ?? questions[index].index,
      points: int.tryParse(pointsValue) ?? questions[index].points,
    );

    questions[index] = updatedQuestion;
    await updateQueApiController.updateCompleteWordTableQuestionApi(updatedQuestion);
    notifyListeners();
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
      selectedQuestionIds.addAll(questions.map((question) => question.id!).toList());
    } else {
      selectedQuestionIds.clear();
    }
    onSelectionChanged(selectedQuestionIds.join('|'));
    notifyListeners();
  }
}



