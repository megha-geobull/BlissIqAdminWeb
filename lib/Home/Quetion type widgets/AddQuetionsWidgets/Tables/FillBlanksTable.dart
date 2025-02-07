import 'package:blissiqadmin/Global/constants/CustomTextField.dart';
import 'package:blissiqadmin/Home/Quetion%20type%20widgets/controller/GetAllQuestionsApiController.dart';
import 'package:blissiqadmin/Home/Quetion%20type%20widgets/model/get_fill_in_the_blanks.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:googleapis/shared.dart';

class FillBlanksTable extends StatefulWidget {
  final String main_category_id;
  final String sub_category_id;
  final String topic_id;
  final String sub_topic_id;
  final List<FillInTheBlanks> questionList;

  FillBlanksTable(
      {required this.main_category_id,
        required this.sub_category_id,
        required this.topic_id,
        required this.sub_topic_id,
        required this.questionList});

  @override
  _FillBlanksTableState createState() => _FillBlanksTableState();
}

class _FillBlanksTableState extends State<FillBlanksTable> {
  TextEditingController _searchController = TextEditingController();
  List<FillInTheBlanks> _filteredQuestions = []; // Filtered data for the table
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
    // Initialize with API data
    _dataSource = QuestionDataSource(
      widget.questionList,
          (selectedIds) {
        setState(() {
          _selectedQuestionIds = selectedIds;
        });
      },  context,
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
    if (mounted) {
      setState(() {
        _filteredQuestions
            .removeWhere((question) => selectedIdsSet.contains(question.id));
        _selectedQuestionIds = '';
        _dataSource = QuestionDataSource(
          _filteredQuestions,
              (selectedIds) {
            setState(() {
              _selectedQuestionIds = selectedIds;
            });
          }, context,
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
                      Future.delayed(const Duration(seconds: 1), () async {
                        bool confirmed = await _dataSource._showConfirmationDialog(context);
                        if(confirmed){
                          _dataSource._deleteSelectedQuestions();
                        }
                        _getdeleteApiController.getFillInTheBlanks(
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
                        DataColumn(label: Text("Question Language")),
                        DataColumn(label: Text("Question")),
                        DataColumn(label: Text("Option 1")),
                        DataColumn(label: Text("Option 2")),
                        DataColumn(label: Text("Option 3")),
                        DataColumn(label: Text("Option 4")),
                        DataColumn(label: Text("Answer")),
                        DataColumn(label: Text("Option Language")),
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
  final List<FillInTheBlanks> questions;
  final Function(String) onSelectionChanged;
  final Set<String> selectedQuestionIds = {};
  bool isSelectAll = false;
  BuildContext context;

  int? editingRowIndex;
  List<TextEditingController> questionTypeControllers = [];
  List<TextEditingController> titleControllers = [];
  List<TextEditingController> questionLanguageController = [];
  List<TextEditingController> questionControllers = [];
  List<TextEditingController> option1Controllers = [];
  List<TextEditingController> option2Controllers = [];
  List<TextEditingController> option3Controllers = [];
  List<TextEditingController> option4Controllers = [];
  List<TextEditingController> answerControllers = [];
  List<TextEditingController> optionLanguageControllers = [];
  List<TextEditingController> pointsControllers = [];
  List<TextEditingController> imageControllers = [];

  final GetAllQuestionsApiController updateQueApiController = Get.find();

  QuestionDataSource(this.questions, this.onSelectionChanged, this.context) {
    for (var question in questions) {
      questionTypeControllers.add(TextEditingController(text: question.questionType));
      titleControllers.add(TextEditingController(text: question.title));
      questionLanguageController.add(TextEditingController(text: questions.questionLanguage));
      questionControllers.add(TextEditingController(text: question.question));
      option1Controllers.add(TextEditingController(text: question.optionA));
      option2Controllers.add(TextEditingController(text: question.optionB));
      option3Controllers.add(TextEditingController(text: question.optionC));
      option4Controllers.add(TextEditingController(text: question.optionD));
      answerControllers.add(TextEditingController(text: question.answer));
      optionLanguageControllers.add(TextEditingController(text: questions.optionLanguage));
      pointsControllers.add(TextEditingController(text: question.points.toString()));
      imageControllers.add(TextEditingController(text: question.qImage));
    }
  }

  //get questionLanguage => null;

  //get titleText => null;

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
                // questionTypeControllers[index].text,
                questionLanguageController[index].text,
                titleControllers[index].text,
                questionControllers[index].text,
                option1Controllers[index].text,
                option2Controllers[index].text,
                option3Controllers[index].text,
                option4Controllers[index].text,
                optionLanguageControllers[index].text,
                answerControllers[index].text,
                pointsControllers[index].text,
                imageControllers[index].text,


              );
            },
          )
              : Text(question.questionType ?? ""),
        ),


        DataCell(
          editingRowIndex == index
              ? TextField(
            controller: questionLanguageController[index],
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
            onSubmitted: (value) {
              _updateQuestion(
                index,
                //questionTypeControllers[index].text,
                questionLanguageController[index].text,
                titleControllers[index].text,
                questionControllers[index].text,
                option1Controllers[index].text,
                option2Controllers[index].text,
                option3Controllers[index].text,
                option4Controllers[index].text,
                optionLanguageControllers[index].text,
                answerControllers[index].text,
                pointsControllers[index].text,
                imageControllers[index].text,
                imageControllers[index].text,

                //value
              );
            },
          )
              : Text(question.question ?? ""),
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
                questionLanguageController[index].text,
                titleControllers[index].text,
                questionControllers[index].text,
                option1Controllers[index].text,
                option2Controllers[index].text,
                option3Controllers[index].text,
                option4Controllers[index].text,
                optionLanguageControllers[index].text,
                answerControllers[index].text,
                pointsControllers[index].text,
                imageControllers[index].text,


              );
            },
          )
              : Text(question.question ?? ""),
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
                questionLanguageController[index].text,
                titleControllers[index].text,
                questionControllers[index].text,
                option1Controllers[index].text,
                option2Controllers[index].text,
                option3Controllers[index].text,
                option4Controllers[index].text,
                optionLanguageControllers[index].text,
                answerControllers[index].text,
                pointsControllers[index].text,
                imageControllers[index].text,

              );
            },
          )
              : Text(question.question ?? ""),
        ),

        DataCell(
          editingRowIndex == index
              ? TextField(
            controller: option1Controllers[index],
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
            onSubmitted: (value) {
              _updateQuestion(
                index,
                questionTypeControllers[index].text,
                questionLanguageController[index].text,
                titleControllers[index].text,
                questionControllers[index].text,
                option1Controllers[index].text,
                option2Controllers[index].text,
                option3Controllers[index].text,
                option4Controllers[index].text,
                optionLanguageControllers[index].text,
                answerControllers[index].text,
                pointsControllers[index].text,
                imageControllers[index].text,
              );
            },
          )
              : Text(question.question ?? ""),
        ),

        DataCell(
          editingRowIndex == index
              ? TextField(
            controller: option2Controllers[index],
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
            onSubmitted: (value) {
              _updateQuestion(
                index,
                questionTypeControllers[index].text,
                questionLanguageController[index].text,
                titleControllers[index].text,
                questionControllers[index].text,
                option1Controllers[index].text,
                option2Controllers[index].text,
                option3Controllers[index].text,
                option4Controllers[index].text,
                optionLanguageControllers[index].text,
                answerControllers[index].text,
                pointsControllers[index].text,
                imageControllers[index].text,

                //value
              );
            },
          )
              : Text(question.question ?? ""),
        ),

        DataCell(
          editingRowIndex == index
              ? TextField(
            controller: option3Controllers[index],
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
            onSubmitted: (value) {
              _updateQuestion(
                index,
                questionTypeControllers[index].text,
                questionLanguageController[index].text,
                titleControllers[index].text,
                questionControllers[index].text,
                option1Controllers[index].text,
                option2Controllers[index].text,
                option3Controllers[index].text,
                option4Controllers[index].text,
                optionLanguageControllers[index].text,
                answerControllers[index].text,
                pointsControllers[index].text,
                imageControllers[index].text,

              );
            },
          )
              : Text(question.question ?? ""),
        ),

        DataCell(
          editingRowIndex == index
              ? TextField(
            controller: option4Controllers[index],
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
            onSubmitted: (value) {
              _updateQuestion(
                index,
                questionTypeControllers[index].text,
                questionLanguageController[index].text,
                titleControllers[index].text,
                questionControllers[index].text,
                option1Controllers[index].text,
                option2Controllers[index].text,
                option3Controllers[index].text,
                option4Controllers[index].text,
                optionLanguageControllers[index].text,
                answerControllers[index].text,
                pointsControllers[index].text,
                imageControllers[index].text,

              );
            },
          )
              : Text(question.question ?? ""),
        ),

        DataCell(
          editingRowIndex == index
              ? TextField(
            controller: optionLanguageControllers[index],
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
            onSubmitted: (value) {
              _updateQuestion(
                index,
                questionTypeControllers[index].text,
                questionLanguageController[index].text,
                titleControllers[index].text,
                questionControllers[index].text,
                option1Controllers[index].text,
                option2Controllers[index].text,
                option3Controllers[index].text,
                option4Controllers[index].text,
                optionLanguageControllers[index].text,
                answerControllers[index].text,
                pointsControllers[index].text,
                imageControllers[index].text,

              );
            },
          )
              : Text(question.question ?? ""),
        ),

        DataCell(
          editingRowIndex == index
              ? TextField(
            controller: answerControllers[index],
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
            onSubmitted: (value) {
              _updateQuestion(
                index,
                questionTypeControllers[index].text,
                questionLanguageController[index].text,
                titleControllers[index].text,
                questionControllers[index].text,
                option1Controllers[index].text,
                option2Controllers[index].text,
                option3Controllers[index].text,
                option4Controllers[index].text,
                optionLanguageControllers[index].text,
                answerControllers[index].text,
                pointsControllers[index].text,
                imageControllers[index].text,

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
                questionLanguageController[index].text,
                titleControllers[index].text,
                questionControllers[index].text,
                option1Controllers[index].text,
                option2Controllers[index].text,
                option3Controllers[index].text,
                option4Controllers[index].text,
                optionLanguageControllers[index].text,
                answerControllers[index].text,
                pointsControllers[index].text,
                imageControllers[index].text,


              );
            },
          )
              : Text(question.question ?? ""),
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
                questionLanguageController[index].text,
                titleControllers[index].text,
                questionControllers[index].text,
                option1Controllers[index].text,
                option2Controllers[index].text,
                option3Controllers[index].text,
                option4Controllers[index].text,
                optionLanguageControllers[index].text,
                answerControllers[index].text,
                pointsControllers[index].text,
                imageControllers[index].text,

              );
            },
          )
              : Text(question.qImage ?? ""),
        ),

        // Question Image

        DataCell(
          editingRowIndex == index
              ? ElevatedButton(
            onPressed: () {
              _updateQuestion(
                index,
                questionLanguageController[index].text,
                questionTypeControllers[index].text,
                titleControllers[index].text,
                questionControllers[index].text,
                option1Controllers[index].text,
                option2Controllers[index].text,
                option3Controllers[index].text,
                option4Controllers[index].text,
                answerControllers[index].text,
                pointsControllers[index].text,
                imageControllers[index].text,
                optionLanguageControllers[index].text,

              );

              editingRowIndex = null; // Exit edit mode
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

  /// Call the update story phrases API here
  _updateQuestion(
      int index,
      String questionType,
      String title,
      String questionLanguage,
      String optionLanguage,
      String question,
      String optionA,
      String optionB,
      String optionC,
      String optionD,
      String answer,
      String pointsValue,
      String questionImage,
      //String text,


      )
  async {
    final updatedQuestion = FillInTheBlanks(
      id: questions[index].id,
      questionType: questionType,
      title: title,
      question: question,
      questionLanguage: questionLanguage,
      optionA: optionA,
      optionB: optionB,
      optionC: optionC,
      optionD: optionD,
      answer: answer,
      optionLanguage: optionLanguage,
      qImage: questionImage,

      points: int.tryParse(pointsValue) ?? questions[index].points,
      mainCategoryId: questions[index].mainCategoryId,
      subCategoryId: questions[index].subCategoryId,
      topicId: questions[index].topicId,
      subTopicId: questions[index].subTopicId,
    );

    // Update the question locally
    questions[index] = updatedQuestion;

    try {
      await updateQueApiController.updateFillInTheBlanksTableQuestionApi(
          updatedQuestion);
      notifyListeners();
    } catch (e) {
      print('Error updating question: $e');
    }
  }

  /// Handle multiple deletions
  _deleteSelectedQuestions() async {
    final deleteApiController = Get.find<GetAllQuestionsApiController>();

    if (selectedQuestionIds.isNotEmpty) {
      try {
        // Call the API to delete selected questions
        await deleteApiController.deleteFillInTheBlanksAPI(
          main_category_id: questions[0].mainCategoryId.toString(),
          sub_category_id: questions[0].subCategoryId.toString(),
          topic_id: questions[0].topicId.toString(),
          sub_topic_id: questions[0].subTopicId.toString(),
          question_id: selectedQuestionIds.join('|'), // Pipe-separated IDs
        );

        // Refresh the questions list
        await deleteApiController.getStoryPhrases(
          main_category_id: questions[0].mainCategoryId.toString(),
          sub_category_id: questions[0].subCategoryId.toString(),
          topic_id: questions[0].topicId.toString(),
          sub_topic_id: questions[0].subTopicId.toString(),
        );

        // Remove deleted questions locally
        questions.removeWhere((question) => selectedQuestionIds.contains(question.id));
        selectedQuestionIds.clear(); // Clear selected IDs
        notifyListeners(); // Update the UI
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

  get questionImageControllers => null;

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

extension on List<FillInTheBlanks> {
  get optionLanguage => null;

  get questionLanguage => null;
}





















