
import 'package:blissiqadmin/Global/constants/CustomTextField.dart';
import 'package:blissiqadmin/Home/Quetion%20type%20widgets/controller/GetAllQuestionsApiController.dart';
import 'package:blissiqadmin/Home/Quetion%20type%20widgets/model/get_story_phrases_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class StoryPhrasesTable extends StatefulWidget {
  final String main_category_id;
  final String sub_category_id;
  final String topic_id;
  final String sub_topic_id;
  final List<StoryPhrases> questionList;

  StoryPhrasesTable(
      {required this.main_category_id,
        required this.sub_category_id,
        required this.topic_id,
        required this.sub_topic_id,
        required this.questionList});

  @override
  _StoryPhrasesTableState createState() => _StoryPhrasesTableState();
}

class _StoryPhrasesTableState extends State<StoryPhrasesTable> {
  TextEditingController _searchController = TextEditingController();
  List<StoryPhrases> _filteredQuestions = []; // Filtered data for the table
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
        question.passage != null &&
            question.passage!.toLowerCase().contains(query.toLowerCase()))
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
                        _getdeleteApiController.getStoryPhrases(
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
                        DataColumn(label: Text("Index")),
                        DataColumn(label: Text("Phrase name")),
                        DataColumn(label: Text("Points")),
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
  final List<StoryPhrases> questions;
  final Function(String) onSelectionChanged; // Callback for selection
  final Set<String> selectedQuestionIds = {}; // Track selected question IDs
  bool isSelectAll = false; // Track "Select All" state
  BuildContext context;

  int? editingRowIndex; // Track which row is being edited
  List<TextEditingController> phraseNameControllers = [];
  List<TextEditingController> indexControllers = [];
  List<TextEditingController> pointsControllers = [];

  final GetAllQuestionsApiController updateQueApiController = Get.find();

  QuestionDataSource(this.questions, this.onSelectionChanged, this.context) {
    // Initialize controllers for each question
    for (var question in questions) {
      phraseNameControllers.add(TextEditingController(text: question.passage));
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
            onChanged: (bool? value) async{
              if (value == true) {
                selectedQuestionIds.add(question.id!);
              } else {
                selectedQuestionIds.remove(question.id);
              }
              isSelectAll = selectedQuestionIds.length == questions.length;
              onSelectionChanged(
                selectedQuestionIds.join('|'), // Pipe-separated IDs
              );

              notifyListeners();
            },
          ),
        ),
        DataCell(
          editingRowIndex == index
              ? TextField(
            controller: indexControllers[index],
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
            onSubmitted: (value) {
              _updateQuestion(index, phraseNameControllers[index].text, value, pointsControllers[index].text);
            },
          )
              : Text(question.index.toString() ?? ""),
        ),
        DataCell(
          editingRowIndex == index
              ? TextField(
            controller: phraseNameControllers[index],
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
            onSubmitted: (value) {
              _updateQuestion(index, value, indexControllers[index].text, pointsControllers[index].text);
            },
          )
              : Text(question.passage ?? ""),
        ),
        DataCell(
          editingRowIndex == index
              ? TextField(
            controller: pointsControllers[index],
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
            onSubmitted: (value) {
              _updateQuestion(index, phraseNameControllers[index].text, indexControllers[index].text, value);
            },
          )
              : Text(question.points.toString() ?? ""),
        ),
        DataCell(
          editingRowIndex == index
              ? ElevatedButton(
            onPressed: () {
              _updateQuestion(index, phraseNameControllers[index].text, indexControllers[index].text, pointsControllers[index].text);
              editingRowIndex = null; // Exit edit mode
              notifyListeners(); // Update UI
            },
            child: Text("Update"),
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
  _updateQuestion(int index, String phraseName, String indexValue, String pointsValue) async {
    final updatedQuestion = StoryPhrases(
      id: questions[index].id, // Keep the same ID
      passage: phraseName,
      index: int.tryParse(indexValue) ?? questions[index].index, // Update index
      points: int.tryParse(pointsValue) ?? questions[index].points, // Update points
      mainCategoryId: questions[index].mainCategoryId,
      subCategoryId: questions[index].subCategoryId,
      topicId: questions[index].topicId,
      subTopicId: questions[index].subTopicId,
      title: '',
      questionType: '',
      imageName: '',
      questionFormat: '',
    );

    questions[index] = updatedQuestion;
    await updateQueApiController.updateStoryPhrasesTableQuestionApi(updatedQuestion);
    notifyListeners();
  }

  /// call delete the story phrases api here
  /// multiple deletions
  _deleteSelectedQuestions() async {
    final deleteApiController = Get.find<GetAllQuestionsApiController>();

    if (selectedQuestionIds.isNotEmpty) {
      try {
        await deleteApiController.deleteStoryPhraseAPI(
          main_category_id: questions[0].mainCategoryId.toString(),
          sub_category_id: questions[0].subCategoryId.toString(),
          topic_id: questions[0].topicId.toString(),
          sub_topic_id: questions[0].subTopicId.toString(),
          phrase_ids: selectedQuestionIds.join('|'), // Pipe-separated IDs
        );

        // Optionally, refresh the list of questions after deletion
        await deleteApiController.getStoryPhrases(
          main_category_id: questions[0].mainCategoryId.toString(),
          sub_category_id: questions[0].subCategoryId.toString(),
          topic_id: questions[0].topicId.toString(),
          sub_topic_id: questions[0].subTopicId.toString(),
        );

        // Remove the deleted questions from the local list
        questions.removeWhere((question) => selectedQuestionIds.contains(question.id));
        selectedQuestionIds.clear(); // Clear the selected IDs after deletion
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

