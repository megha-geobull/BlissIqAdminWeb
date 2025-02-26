import 'package:blissiqadmin/Global/constants/CustomTextField.dart';
import 'package:blissiqadmin/Home/Quetion%20type%20widgets/controller/GetAllQuestionsApiController.dart';
import 'package:blissiqadmin/Home/Quetion%20type%20widgets/model/LearningSlideModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class LearningSlideTable extends StatefulWidget {
  final String main_category_id;
  final String sub_category_id;
  final String topic_id;
  final String sub_topic_id;
  final List<LearningSlide> questionList;

  LearningSlideTable(
      {required this.main_category_id,
        required this.sub_category_id,
        required this.topic_id,
        required this.sub_topic_id,
        required this.questionList});

  @override
  _LearningSlideTableState createState() => _LearningSlideTableState();
}

class _LearningSlideTableState extends State<LearningSlideTable> {
  TextEditingController _searchController = TextEditingController();
  List<LearningSlide> _filteredQuestions = []; // Filtered data for the table
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
      );
    });
  }

  void _removeSelectedQuestions() {
    // Convert the selected IDs string to a Set for efficient lookup
    final selectedIdsSet = _selectedQuestionIds.split('|').toList();

    // if(mounted){
    //
    //   setState(() {
    //     // Remove matching items from the main list
    //
    //     // Remove matching items from the filtered list
    //     _filteredQuestions.removeWhere((mcq) => selectedIdsSet.contains(mcq.id));
    //
    //     // Clear selected IDs after deletion
    //     _selectedQuestionIds = '';
    //
    //     // Update the data source with the updated filtered list
    //     _dataSource = QuestionDataSource(
    //       _filteredQuestions,
    //           (selectedIds) {
    //         setState(() {
    //           _selectedQuestionIds = selectedIds;
    //         });
    //       },
    //     );
    //   });}
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
                      print("Selected Ids -$_selectedQuestionIds");
                      _getdeleteApiController.deleteLearningSlideAPI(learning_ids:_selectedQuestionIds);
                      Future.delayed(const Duration(seconds: 1), () {
                        _getdeleteApiController.getAllLearningSlideApi(
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
                        const DataColumn(label: Text("Title")),
                        const DataColumn(label: Text("Defintion")),
                        const DataColumn(label: Text("Video Link")),
                        const DataColumn(label: Text("PDF Link")),
                        const DataColumn(label: Text("PPT Link")),
                        const DataColumn(label: Text("Image Link")),
                        const DataColumn(label: Text("Index")),
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
  final List<LearningSlide> questions;
  final Function(String) onSelectionChanged; // Callback for selection
  final Set<String> selectedQuestionIds = {}; // Track selected question IDs
  bool isSelectAll = false; // Track "Select All" state
  int? editingRowIndex; // Track which row is being edited
  List<TextEditingController> editingControllers = []; // Controllers for editing text

  final GetAllQuestionsApiController updateQueApiController = Get.find();


  QuestionDataSource(this.questions, this.onSelectionChanged) {
    // Initialize controllers for each question
    for (var question in questions) {
      editingControllers.add(TextEditingController(text: question.title));
    }
  }

  @override
  DataRow? getRow(int index) {
    if (index >= questions.length) return null;
    var question = questions[index];
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
                selectedQuestionIds.join('|'), // Pipe-separated IDs
              );
              notifyListeners(); // Update UI
            },
          ),
        ),

        DataCell(
          editingRowIndex == index
              ? TextField(
            controller: editingControllers[index],
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
            onSubmitted: (value) {
              // Update the question with the new value
              question.title = editingControllers[index].text;
              // Optionally call the API here
              _updateQuestion(question);
              editingRowIndex = null; // Exit edit mode
              notifyListeners(); // Update UI
            },
          )
              : Text(question.title ?? ""),
        ),

        DataCell(
          editingRowIndex == index
              ? TextField(
            controller: TextEditingController(text: question.definition),
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
            onSubmitted: (value) {
              question.definition = value; // Update definition
              _updateQuestion(question); // Call API
              notifyListeners(); // Update UI
            },
          )
              : Text(question.definition ?? ""),
        ),

        DataCell(
          editingRowIndex == index
              ? TextField(
            controller: TextEditingController(text: question.videoFile),
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
            onSubmitted: (value) {
              question.videoFile = value; // Update definition
              _updateQuestion(question); // Call API
              notifyListeners(); // Update UI
            },
          )
              : Text(question.videoFile ?? ""),
        ),

        DataCell(
          editingRowIndex == index
              ? TextField(
            controller: TextEditingController(text: question.pdfFile),
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
            onSubmitted: (value) {
              question.pdfFile = value; // Update definition
              _updateQuestion(question); // Call API
              notifyListeners(); // Update UI
            },
          )
              : Text(question.pdfFile ?? ""),
        ),

        DataCell(
          editingRowIndex == index
              ? TextField(
            controller: TextEditingController(text: question.pptFile),
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
            onSubmitted: (value) {
              question.pptFile = value; // Update definition
              _updateQuestion(question); // Call API
              notifyListeners(); // Update UI
            },
          )
              : Text(question.pptFile ?? ""),
        ),

        DataCell(
          editingRowIndex == index
              ? TextField(
            controller: TextEditingController(text: question.imageFile),
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
            onSubmitted: (value) {
              question.imageFile = value; // Update definition
              _updateQuestion(question); // Call API
              notifyListeners(); // Update UI
            },
          )
              : Text(question.imageFile ?? ""),
        ),
        DataCell(
          editingRowIndex == index
              ? TextField(
            controller: TextEditingController(text: question.index.toString()),
            decoration: InputDecoration(
              border: OutlineInputBorder(),
            ),
            onSubmitted: (value) {
              question.index = int.tryParse(value) ?? 0;
              _updateQuestion(question); // Call API
              notifyListeners(); // Update UI
            },
          )
              : Text(question.index.toString() ?? ""),
        ),

        DataCell(
          editingRowIndex == index
              ? TextField(
            controller: TextEditingController(text: question.points.toString()),
            decoration: InputDecoration(
              border: OutlineInputBorder(),
            ),
            onSubmitted: (value) {
              question.points = int.tryParse(value) ?? 0;
              _updateQuestion(question); // Call API
              notifyListeners(); // Update UI
            },
          )
              : Text(question.points.toString() ?? ""),
        ),

        DataCell(
          editingRowIndex == index
              ? ElevatedButton(
            onPressed: () {
              // Call the API to update the question
              _updateQuestion(question);
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

  Future<void> _updateQuestion(LearningSlide question) async {
    await updateQueApiController.updateLearningTableQuestionApi(question);
    // await ApiService.updateQuestion(question);
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



