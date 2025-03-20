import 'package:blissiqadmin/Global/constants/ApiString.dart';
import 'package:blissiqadmin/Global/constants/CustomTextField.dart';
import 'package:blissiqadmin/Home/Quetion%20type%20widgets/controller/GetAllQuestionsApiController.dart';
import 'package:blissiqadmin/Home/Quetion%20type%20widgets/model/get_story_phrases_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
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
  bool isSelectAll = false;
  List<String> selected_question_ids = [];
  late QuestionPhraseDataSource _dataSource;

  final GetAllQuestionsApiController _getdeleteApiController = Get.find();

  @override
  void initState() {
    super.initState();
    // Initialize with API data
    _dataSource = QuestionPhraseDataSource(
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
                question.passage != null &&
                question.passage!.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }

      // Update the data source with the filtered questions
      _dataSource = QuestionPhraseDataSource(
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
        _dataSource = QuestionPhraseDataSource(
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
            // Header Row
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
                        //_removeSelectedQuestions();
                        bool confirmed =
                            await _dataSource._showConfirmationDialog(context);
                        if (confirmed) {
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
                        DataColumn(label: Text("Title")),
                        DataColumn(label: Text("Phrase name")),
                        DataColumn(label: Text("Question Type")),
                        DataColumn(label: Text("Image name")),
                        DataColumn(label: Text("Question Format")),
                        DataColumn(label: Text("Image")),
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

class QuestionPhraseDataSource extends DataTableSource {
  final List<StoryPhrases> questions;
  final Function(String) onSelectionChanged; // Callback for selection
  final Set<String> selectedQuestionIds = {}; // Track selected question IDs
  bool isSelectAll = false; // Track "Select All" state
  BuildContext context;

  int? editingRowIndex; // Track which row is being edited
  List<TextEditingController> phraseNameControllers = [];
  List<TextEditingController> indexControllers = [];
  List<TextEditingController> pointsControllers = [];
  List<TextEditingController> titleControllers = [];
  List<TextEditingController> questionTypeControllers = [];
  List<TextEditingController> imageNameControllers = [];
  List<TextEditingController> queImageControllers = [];
  List<TextEditingController> questionFormatControllers = [];

  final GetAllQuestionsApiController updateQueApiController = Get.find();

  QuestionPhraseDataSource(this.questions, this.onSelectionChanged, this.context) {
    // Initialize controllers for each question
    for (var question in questions) {
      phraseNameControllers.add(TextEditingController(text: question.passage));
      indexControllers.add(TextEditingController(text: question.index.toString()));
      pointsControllers.add(TextEditingController(text: question.points.toString()));
      titleControllers.add(TextEditingController(text: question.title));
      questionTypeControllers.add(TextEditingController(text: question.questionType));
      imageNameControllers.add(TextEditingController(text: question.imageName));
      queImageControllers.add(TextEditingController(text: question.imageName));
      questionFormatControllers.add(TextEditingController(text: question.questionFormat));
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
              _updateQuestion(index);
              _updateQuestion(
                index,
              );
            },
          )
              : Text(question.index.toString() ?? ""),
        ),
        DataCell(
          editingRowIndex == index
              ? TextField(
            controller: titleControllers[index],
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
            onSubmitted: (value) {
              _updateQuestion(index);
            },
          )
              : Text(question.title ?? ""),
        ),

        DataCell(
          editingRowIndex == index
              ? TextField(
            controller: phraseNameControllers[index],
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
            onSubmitted: (value) {
              _updateQuestion(index);
            },
          )
              : Text(question.passage ?? ""),
        ),


        DataCell(
          editingRowIndex == index
              ? TextField(
            controller: questionTypeControllers[index],
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
            onSubmitted: (value) {
              _updateQuestion(index);
            },
          )
              : Text(question.questionType ?? ""),
        ),
        DataCell(
          editingRowIndex == index
              ? TextField(
            controller: imageNameControllers[index],
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
            onSubmitted: (value) {
              _updateQuestion(index);
            },
          )
              : Text(question.imageName ?? ""),
        ),
        DataCell(
          editingRowIndex == index
              ? TextField(
            controller: questionFormatControllers[index],
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
            onSubmitted: (value) {
              _updateQuestion(index);
            },
          )
              : Text(question.questionFormat ?? ""),
        ),
        DataCell(
          editingRowIndex == index
              ? TextField(
            controller: queImageControllers[index],
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
            onSubmitted: (value) {
              _updateQuestion(index);
            },
          )
              : Text(question.image ?? ""),
        ),
        DataCell(
          editingRowIndex == index
              ? TextField(
            controller: pointsControllers[index],
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
            onSubmitted: (value) {
              _updateQuestion(index);
            },
          )
              : Text(question.points.toString() ?? ""),
        ),
        DataCell(
          editingRowIndex == index
              ? ElevatedButton(
            onPressed: () {
              _updateQuestion(index);
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

  /// Call the update story phrases API here
  _updateQuestion(int index) async {
    final updatedQuestion = StoryPhrases(
      id: questions[index].id,
      passage: phraseNameControllers[index].text,
      index: int.tryParse(indexControllers[index].text) ?? questions[index].index,
      points: int.tryParse(pointsControllers[index].text) ?? questions[index].points,
      mainCategoryId: questions[index].mainCategoryId,
      subCategoryId: questions[index].subCategoryId,
      topicId: questions[index].topicId,
      subTopicId: questions[index].subTopicId,
      title: titleControllers[index].text,
      questionType: questionTypeControllers[index].text,
      imageName: imageNameControllers[index].text,
      questionFormat: questionFormatControllers[index].text,
    );

    questions[index] = updatedQuestion;
    await updateQueApiController.updateStoryPhrasesTableQuestionApi(updatedQuestion);
    notifyListeners();
  }

  /// Call delete story phrases API here (multiple deletions)
  _deleteSelectedQuestions() async {
    final deleteApiController = Get.find<GetAllQuestionsApiController>();

    if (selectedQuestionIds.isNotEmpty) {
      try {
        await deleteApiController.deleteStoryPhraseAPI(
          phrase_ids: selectedQuestionIds.join('|'),
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

  void toggleSelectAll(bool value) async {
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

  Future<bool> _showConfirmationDialog(BuildContext context) async {
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
    ) ??
        false; // Default to false if dialog is dismissed
  }

  void dispose() {
    for (var controller in phraseNameControllers) {
      controller.dispose();
    }
    for (var controller in indexControllers) {
      controller.dispose();
    }
    for (var controller in pointsControllers) {
      controller.dispose();
    }
    for (var controller in titleControllers) {
      controller.dispose();
    }
    for (var controller in questionTypeControllers) {
      controller.dispose();
    }
    for (var controller in imageNameControllers) {
      controller.dispose();
    }
    for (var controller in questionFormatControllers) {
      controller.dispose();
    }
  }
}