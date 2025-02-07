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

  MCQ_QuestionTableScreen({
    required this.main_category_id,
    required this.sub_category_id,
    required this.topic_id,
    required this.sub_topic_id,
    required this.questionList,
  });

  @override
  _MCQ_QuestionTableScreenState createState() => _MCQ_QuestionTableScreenState();
}

class _MCQ_QuestionTableScreenState extends State<MCQ_QuestionTableScreen> {
  TextEditingController _searchController = TextEditingController();
  List<Mcqs> _filteredQuestions = [];
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  final _verticalScrollController = ScrollController();
  final _horizontalScrollController = ScrollController();
  String _selectedQuestionIds = "";
  bool isSelectAll = false;
  List<String> selected_question_ids = [];
  late MCQDataSource _dataSource;
  final GetAllQuestionsApiController _getdeleteApiController = Get.find();

  @override
  void initState() {
    super.initState();
    _dataSource = MCQDataSource(
      widget.questionList,
          (selectedIds) {
        setState(() {
          _selectedQuestionIds = selectedIds;
        });
      },
      context,
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
      _dataSource = MCQDataSource(
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
    final selectedIdsSet = _selectedQuestionIds.split('|').toSet();
    if (mounted) {
      setState(() {
        _filteredQuestions.removeWhere((mcq) => selectedIdsSet.contains(mcq.id));
        _selectedQuestionIds = '';
        _dataSource = MCQDataSource(
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
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        labelText: "Search by Question",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.search),
                      ),
                      onChanged: _filterQuestions,
                    ),
                  ),
                ),
                if (_selectedQuestionIds.isNotEmpty)
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade100,
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    icon: Icon(Icons.delete, color: Colors.red),
                    label: Text(
                      "Delete",
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () async {
                      print("Selected Ids - $_selectedQuestionIds");
                      _getdeleteApiController.delete_Mcq(question_ids: _selectedQuestionIds);
                      Future.delayed(Duration(seconds: 1), () {
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
            SizedBox(height: 20),
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
                        "MCQ Questions Table",
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
                              Text("Select All"),
                            ],
                          ),
                        ),
                        DataColumn(label: Text("Question Type")),
                        DataColumn(label: Text("Title")),
                        DataColumn(label: Text("Question")),
                        DataColumn(label: Text("Option 1")),
                        DataColumn(label: Text("Option 2")),
                        DataColumn(label: Text("Option 3")),
                        DataColumn(label: Text("Option 4")),
                        DataColumn(label: Text("Answer")),
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

class MCQDataSource extends DataTableSource {
  final List<Mcqs> questions;
  final Function(String) onSelectionChanged;
  final Set<String> selectedQuestionIds = {};
  bool isSelectAll = false;
  BuildContext context;

  int? editingRowIndex;
  List<TextEditingController> questionTypeControllers = [];
  List<TextEditingController> titleControllers = [];
  List<TextEditingController> questionControllers = [];
  List<TextEditingController> optionAControllers = [];
  List<TextEditingController> optionBControllers = [];
  List<TextEditingController> optionCControllers = [];
  List<TextEditingController> optionDControllers = [];
  List<TextEditingController> answerControllers = [];
  List<TextEditingController> pointsControllers = [];

  final GetAllQuestionsApiController updateQueApiController = Get.find();

  MCQDataSource(this.questions, this.onSelectionChanged, this.context) {
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
          controller: questionTypeControllers[index],
          initialValue: question.questionType ?? "",
          onSubmit: (value) {
            _updateQuestion(
              index,
              value,
              titleControllers[index].text,
              questionControllers[index].text,
              optionAControllers[index].text,
              optionBControllers[index].text,
              optionCControllers[index].text,
              optionDControllers[index].text,
              answerControllers[index].text,
              pointsControllers[index].text,
            );
          },
        ),
        _editableDataCell(
          index: index,
          controller: titleControllers[index],
          initialValue: question.title ?? "",
          onSubmit: (value) {
            _updateQuestion(
              index,
              questionTypeControllers[index].text,
              value,
              questionControllers[index].text,
              optionAControllers[index].text,
              optionBControllers[index].text,
              optionCControllers[index].text,
              optionDControllers[index].text,
              answerControllers[index].text,
              pointsControllers[index].text,
            );
          },
        ),
        _editableDataCell(
          index: index,
          controller: questionControllers[index],
          initialValue: question.question ?? "",
          onSubmit: (value) {
            _updateQuestion(
              index,
              questionTypeControllers[index].text,
              titleControllers[index].text,
              value,
              optionAControllers[index].text,
              optionBControllers[index].text,
              optionCControllers[index].text,
              optionDControllers[index].text,
              answerControllers[index].text,
              pointsControllers[index].text,
            );
          },
        ),
        _editableDataCell(
          index: index,
          controller: optionAControllers[index],
          initialValue: question.optionA ?? "",
          onSubmit: (value) {
            _updateQuestion(
              index,
              questionTypeControllers[index].text,
              titleControllers[index].text,
              questionControllers[index].text,
              value,
              optionBControllers[index].text,
              optionCControllers[index].text,
              optionDControllers[index].text,
              answerControllers[index].text,
              pointsControllers[index].text,
            );
          },
        ),
        _editableDataCell(
          index: index,
          controller: optionBControllers[index],
          initialValue: question.optionB ?? "",
          onSubmit: (value) {
            _updateQuestion(
              index,
              questionTypeControllers[index].text,
              titleControllers[index].text,
              questionControllers[index].text,
              optionAControllers[index].text,
              value,
              optionCControllers[index].text,
              optionDControllers[index].text,
              answerControllers[index].text,
              pointsControllers[index].text,
            );
          },
        ),
        _editableDataCell(
          index: index,
          controller: optionCControllers[index],
          initialValue: question.optionC ?? "",
          onSubmit: (value) {
            _updateQuestion(
              index,
              questionTypeControllers[index].text,
              titleControllers[index].text,
              questionControllers[index].text,
              optionAControllers[index].text,
              optionBControllers[index].text,
              value,
              optionDControllers[index].text,
              answerControllers[index].text,
              pointsControllers[index].text,
            );
          },
        ),
        _editableDataCell(
          index: index,
          controller: optionDControllers[index],
          initialValue: question.optionD ?? "",
          onSubmit: (value) {
            _updateQuestion(
              index,
              questionTypeControllers[index].text,
              titleControllers[index].text,
              questionControllers[index].text,
              optionAControllers[index].text,
              optionBControllers[index].text,
              optionCControllers[index].text,
              value,
              answerControllers[index].text,
              pointsControllers[index].text,
            );
          },
        ),
        _editableDataCell(
          index: index,
          controller: answerControllers[index],
          initialValue: question.answer ?? "",
          onSubmit: (value) {
            _updateQuestion(
              index,
              questionTypeControllers[index].text,
              titleControllers[index].text,
              questionControllers[index].text,
              optionAControllers[index].text,
              optionBControllers[index].text,
              optionCControllers[index].text,
              optionDControllers[index].text,
              value,
              pointsControllers[index].text,
            );
          },
        ),

        _editableDataCell(
          index: index,
          controller: pointsControllers[index],
          initialValue: question.points?.toString() ?? "",
          onSubmit: (value) {
            _updateQuestion(
              index,
              questionTypeControllers[index].text,
              titleControllers[index].text,
              questionControllers[index].text,
              optionAControllers[index].text,
              optionBControllers[index].text,
              optionCControllers[index].text,
              optionDControllers[index].text,
              answerControllers[index].text,
              value,
            );
          },
        ),
        DataCell(
            ElevatedButton(
              onPressed: () {},
              child: Text("View"),
            )
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
                optionAControllers[index].text,
                optionBControllers[index].text,
                optionCControllers[index].text,
                optionDControllers[index].text,
                answerControllers[index].text,
                pointsControllers[index].text,
              );
              editingRowIndex = null;
              notifyListeners();
            },
            child: Text("Update"),
          )
              : GestureDetector(
            onTap: () {
              if (editingRowIndex == null) {
                editingRowIndex = index;
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
        decoration: InputDecoration(
          border: OutlineInputBorder(),
        ),
        onSubmitted: onSubmit,
      )
          : Text(initialValue),
    );
  }

  _updateQuestion(
      int index,
      String questionType,
      String title,
      String question,
      String optionA,
      String optionB,
      String optionC,
      String optionD,
      String answer,
      String points,
      ) async {
    final updatedQuestion = Mcqs(
      id: questions[index].id,
      mainCategoryId: questions[index].mainCategoryId,
      subCategoryId: questions[index].subCategoryId,
      topicId: questions[index].topicId,
      subTopicId: questions[index].subTopicId,
      questionType: questionType,
      title: title,
      question: question,
      optionA: optionA,
      optionB: optionB,
      optionC: optionC,
      optionD: optionD,
      answer: answer,
      points: int.tryParse(points) ?? questions[index].points ?? 0,
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