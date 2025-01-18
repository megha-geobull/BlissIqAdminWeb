import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/GetAllQuestionsApiController.dart';
import '../../model/get_mcqs.dart';
import '../../model/get_rearrange_model.dart';
import '../AddQuetionsWidgets.dart';

class Re_Arrange_QuestionTableScreen extends StatefulWidget {
  final String main_category_id;
  final String sub_category_id;
  final String topic_id;
  final String sub_topic_id;
  final List<ReArrange> questionList;

  Re_Arrange_QuestionTableScreen(
      {required this.main_category_id,
        required this.sub_category_id,
        required this.topic_id,
        required this.sub_topic_id,
        required this.questionList});

  @override
  _QuestionTableScreenState createState() => _QuestionTableScreenState();
}

class _QuestionTableScreenState extends State<Re_Arrange_QuestionTableScreen> {
  TextEditingController _searchController = TextEditingController();
  List<ReArrange> _filteredQuestions = []; // Filtered data for the table
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
        _filteredQuestions = widget.questionList.cast<ReArrange>();
      } else {
        _filteredQuestions = widget.questionList
            .where((question) =>
        question.question != null &&
            question.question!.toLowerCase().contains(query.toLowerCase())).cast<ReArrange>()
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
    final selectedIdsSet = _selectedQuestionIds.split('|').toSet();
    if(mounted){
      setState(() {
        // Remove matching items from the main list

        // Remove matching items from the filtered list
        _filteredQuestions.removeWhere((ReArrange) => selectedIdsSet.contains(ReArrange.id));

        // Clear selected IDs after deletion
        _selectedQuestionIds = '';

        // Update the data source with the updated filtered list
        _dataSource = QuestionDataSource(
          _filteredQuestions.cast<ReArrange>(),
              (selectedIds) {
            setState(() {
              _selectedQuestionIds = selectedIds;
            });
          },
        );
      });}
  }


  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 600,
        height: 670,
        child: Column(children: [
          Row(children: [
            SizedBox(
              width: 300,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _searchController,
                  onChanged: _filterQuestions,
                  decoration: const InputDecoration(
                    labelText: "Search by Question",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
              ),
            ),
            _selectedQuestionIds.isNotEmpty?
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade100, // Button color
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12), // Padding
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8), // Rounded corners
                ),
              ),
              icon: const Icon(Icons.delete, size: 20, color: Colors.black), // Icon
              label: const Text(
                "Delete",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: Colors.black),
              ),
              onPressed: () async {
                print("selected Ids - "+_selectedQuestionIds);
                _getdeleteApiController.delete_Mcq(question_ids: _selectedQuestionIds);
                Future.delayed(const Duration(seconds: 1), () {
                  _removeSelectedQuestions();
                  _getdeleteApiController.getAllRe_Arrange(main_category_id:widget.main_category_id,
                      sub_category_id: widget.sub_category_id,
                      topic_id: widget.topic_id,sub_topic_id: widget.sub_topic_id);
                });
              },
            ):SizedBox(),
          ],),
          Scrollbar(
              thumbVisibility: true,
              controller: _verticalScrollController,
              child: SingleChildScrollView(
                  controller: _verticalScrollController,
                  scrollDirection: Axis.vertical,
                  child: Scrollbar(
                      thumbVisibility: true,
                      scrollbarOrientation: ScrollbarOrientation.bottom,
                      controller: _horizontalScrollController,
                      child: PaginatedDataTable(
                        columns: [
                          DataColumn(
                            label: Row(
                              children: [
                                Checkbox(
                                  value: _dataSource.isSelectAll, // Use the data source's select-all state
                                  onChanged: (bool? value) {
                                    _dataSource.toggleSelectAll(value!);
                                    setState(() {}); // Update UI
                                  },
                                ),
                                Text("Select All"),
                              ],
                            ),
                          ),
                          DataColumn(label: Text("Question Type")),
                          DataColumn(label: Text("Title")),
                          DataColumn(label: Text("Re_Arrange Word")),
                          DataColumn(label: Text("Points")),
                          DataColumn(label: Text("Question Image")),
                        ],
                        source: _dataSource,
                        rowsPerPage: _rowsPerPage,
                        onRowsPerPageChanged: (value) {
                          setState(() {
                            _rowsPerPage = value!;
                          });
                        },
                      )
                  )))
        ]));
  }
}

// DataTableSource for handling data in the DataTable
class QuestionDataSource extends DataTableSource {
  final List<ReArrange> questions;
  final Function(String) onSelectionChanged; // Callback for selection
  final Set<String> selectedQuestionIds = {}; // Track selected question IDs
  bool isSelectAll = false; // Track "Select All" state

  QuestionDataSource(this.questions, this.onSelectionChanged);

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
                selectedQuestionIds.join('|'), // Pipe-separated IDs
              );
              notifyListeners(); // Update UI
            },
          ),
        ),
        DataCell(Text(question.questionType ?? "")),
        DataCell(Text(question.title ?? "")),
        DataCell(Text(question.answer ?? "")),
        DataCell(Text(question.points.toString())),
        DataCell(
          GestureDetector(
            onTap: () {
              // Implement image popup
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
      ],
    );
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

