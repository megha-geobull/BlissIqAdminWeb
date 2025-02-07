import 'package:blissiqadmin/Global/constants/CustomTextField.dart';
import 'package:blissiqadmin/Home/Quetion%20type%20widgets/controller/GetAllQuestionsApiController.dart';
import 'package:blissiqadmin/Home/Quetion%20type%20widgets/model/get_fill_in_the_blanks.dart';
import 'package:blissiqadmin/Home/Quetion%20type%20widgets/model/get_story_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class CompleteStoryTable extends StatefulWidget {
  final String main_category_id;
  final String sub_category_id;
  final String topic_id;
  final String sub_topic_id;
  final List<StoryData> questionList;

  CompleteStoryTable(
      {required this.main_category_id,
        required this.sub_category_id,
        required this.topic_id,
        required this.sub_topic_id,
        required this.questionList});

  @override
  _CompleteStoryTableState createState() => _CompleteStoryTableState();
}

class _CompleteStoryTableState extends State<CompleteStoryTable> {

  TextEditingController _searchController = TextEditingController();
  List<StoryData> _filteredQuestions = [];
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
        question.storyTitle != null &&
            question.storyTitle!.toLowerCase().contains(query.toLowerCase()))
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

        _filteredQuestions.removeWhere((mcq) => selectedIdsSet.contains(mcq.id));

        // Clear selected IDs after deletion
        _selectedQuestionIds = '';
        _dataSource = QuestionDataSource(
          _filteredQuestions,
              (selectedIds) {
            setState(() {
              _selectedQuestionIds = selectedIds;
            });
          },
          context,
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
                      Future.delayed(const Duration(seconds: 1), () async{

                        bool confirmed = await _dataSource._showConfirmationDialog(context);
                        if(confirmed){
                          _dataSource._deleteSelectedQuestions();
                        }

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

                        DataColumn(label: Text("Question Type")),
                        DataColumn(label: Text("Index")),
                        DataColumn(label: Text("Story Title")),
                        DataColumn(label: Text("Content")),
                        DataColumn(label: Text("Highlight Word")),
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
  final List<StoryData> questions;
  final Function(String) onSelectionChanged; // Callback for selection
  final Set<String> selectedQuestionIds = {}; // Track selected question IDs
  bool isSelectAll = false;
  BuildContext context;

  int? editingRowIndex; // Track which row is being edited
  List<TextEditingController> questionTypeControllers = [];
  List<TextEditingController> titleControllers = [];
  List<TextEditingController> contentControllers = [];
  List<TextEditingController> highlightWordControllers = [];
  List<TextEditingController> questionImageControllers = [];
  List<TextEditingController> indexControllers = [];
  List<TextEditingController> pointsControllers = [];

  final GetAllQuestionsApiController updateQueApiController = Get.find();

  QuestionDataSource(this.questions, this.onSelectionChanged, this.context) {
    for (var question in questions) {
      // questionTypeControllers.add(TextEditingController(text: question.questionType));
      titleControllers.add(TextEditingController(text: question.storyTitle));
      contentControllers.add(TextEditingController(text: question.content));
      highlightWordControllers.add(TextEditingController(text: question.highlightWord));
      questionImageControllers.add(TextEditingController(text: question.storyImg));
      indexControllers.add(TextEditingController(text: question.index.toString()));
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
              onSelectionChanged(selectedQuestionIds.join('|')); // Pipe-separated IDs
              notifyListeners(); // Update UI
            },
          ),
        ),
        // DataCell(_buildEditableCell(index, questionTypeControllers, question.questionType)),
        DataCell(_buildEditableCell(index, indexControllers, question.index.toString())),
        DataCell(_buildEditableCell(index, titleControllers, question.storyTitle)),
        DataCell(_buildEditableCell(index, contentControllers, question.content)),
        DataCell(_buildEditableCell(index, highlightWordControllers, question.highlightWord)),
        DataCell(_buildEditableCell(index, pointsControllers, question.points.toString())),
        DataCell(
          ElevatedButton(
            onPressed: () {
              _viewQuestionImage(question.storyImg); // Call function to handle image view
            },
            child: const Text("View"),
          ),
        ),
        DataCell(
          editingRowIndex == index
              ? ElevatedButton(
            onPressed: () {
              _updateQuestion(
                index,
                questionTypeControllers[index].text,
                indexControllers[index].text,
                titleControllers[index].text,
                contentControllers[index].text,
                highlightWordControllers[index].text,
                pointsControllers[index].text,
                questionImageControllers[index].text,
              );
              editingRowIndex = null; // Exit edit mode
              notifyListeners(); // Update UI
            },
            child:  Text("Update"),
          )
              : GestureDetector(
            onTap: () {
              if (editingRowIndex == null) {
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

  Widget _buildEditableCell(int index, List<TextEditingController> controllers, String? value) {
    return editingRowIndex == index
        ? TextField(
      controller: controllers[index],
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
      ),
      onSubmitted: (newValue) {
        _updateQuestion(
          index,
          questionTypeControllers[index].text,
          indexControllers[index].text,
          titleControllers[index].text,
          contentControllers[index].text,
          highlightWordControllers[index].text,
          pointsControllers[index].text,
          questionImageControllers[index].text,
        );
      },
    )
        : Text(value ?? "");
  }

  void _viewQuestionImage(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No image available")),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Question Image"),
          content: Image.network(imageUrl, fit: BoxFit.cover),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }

  void _updateQuestion(
      int index,
      String questionType,
      String indexValue,
      String storyTitle,
      String content,
      String highlightWord,
      String pointsValue,
      String questionImage,
      ) async {
    final updatedQuestion = StoryData(
      id: questions[index].id,
      // questionType: questionType,
      index: int.tryParse(indexValue) ?? questions[index].index,
      storyTitle: storyTitle,
      content: content,
      highlightWord: highlightWord,
      points: int.tryParse(pointsValue) ?? questions[index].points,
      storyImg: questionImage,
      mainCategoryId: questions[index].mainCategoryId,
      subCategoryId: questions[index].subCategoryId,
      topicId: questions[index].topicId,
      subTopicId: questions[index].subTopicId,
    );

    questions[index] = updatedQuestion;

    try {
      await updateQueApiController.updateStoryTableQuestionApi(updatedQuestion);
      notifyListeners();
    } catch (e) {
      print('Error updating question: $e');
    }
  }

  void _deleteSelectedQuestions() async {
    final deleteApiController = Get.find<GetAllQuestionsApiController>();

    if (selectedQuestionIds.isNotEmpty) {
      try {
        await deleteApiController.deleteStoryAPI(
          main_category_id: questions[0].mainCategoryId.toString(),
          sub_category_id: questions[0].subCategoryId.toString(),
          topic_id: questions[0].topicId.toString(),
          sub_topic_id: questions[0].subTopicId.toString(),
          question_id: selectedQuestionIds.join('|'),
        );

        final refreshedQuestions = await deleteApiController.getStoryPhrases(
          main_category_id: questions[0].mainCategoryId.toString(),
          sub_category_id: questions[0].subCategoryId.toString(),
          topic_id: questions[0].topicId.toString(),
          sub_topic_id: questions[0].subTopicId.toString(),
        );

        questions
          ..clear()
          ..addAll(refreshedQuestions);
        selectedQuestionIds.clear();
        notifyListeners();
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

  void toggleSelectAll(bool value) async {
    isSelectAll = value;

    if (isSelectAll) {
      selectedQuestionIds.addAll(questions.map((question) => question.id!).toList());
    } else {
      bool confirmed = await _showConfirmationDialog(context);
      if (confirmed) {
        _deleteSelectedQuestions();
      }
      selectedQuestionIds.clear();
    }

    onSelectionChanged(selectedQuestionIds.join('|'));
    notifyListeners();
  }

  Future<bool> _showConfirmationDialog(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Do you really want to delete the selected phrases?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Yes'),
            ),
          ],
        );
      },
    ) ??
        false;
  }
}


