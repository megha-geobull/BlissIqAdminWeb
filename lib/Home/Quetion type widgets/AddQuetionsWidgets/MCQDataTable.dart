
import 'package:flutter/material.dart';
import '../model/get_mcqs.dart';
import 'AddQuetionsWidgets.dart';


class MCQ_QuestionTableScreen extends StatefulWidget {
  final String main_category_id;
  final String sub_category_id;
  final String topic_id;
  final String sub_topic_id;
  final List<Mcqs> questionList;
  MCQ_QuestionTableScreen({required this.main_category_id,required this.sub_category_id,required this.topic_id,required this.sub_topic_id,required this.questionList});
  @override
  _QuestionTableScreenState createState() => _QuestionTableScreenState();
}

class _QuestionTableScreenState extends State<MCQ_QuestionTableScreen> {
  TextEditingController _searchController = TextEditingController();
  List<Mcqs> _questions = []; // Original data
  List<Mcqs> _filteredQuestions = []; // Filtered data for the table
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  final ScrollController layoutController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Initialize with API data
    _questions = widget.questionList;
    _filteredQuestions = _questions;
  }

  void _filterQuestions(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredQuestions = _questions;
      } else {
        _filteredQuestions = _questions
            .where((question) =>
        question.question != null &&
            question.question!.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
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
          NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification notification) {
                if (notification is ScrollStartNotification) {
                  is_TableScrolling = true;// Update the global state
                  print(is_TableScrolling);
                } else if (notification is ScrollEndNotification) {
                  is_TableScrolling = false; // Reset the global state
                  print(is_TableScrolling);
                }
                return false;  // Allow further event propagation
              }, child:
              SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                        child:PaginatedDataTable(
                        columns: const [
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
                        ],
                        source: QuestionDataSource(_filteredQuestions),
                        rowsPerPage: _rowsPerPage,
                        onRowsPerPageChanged: (value) {
                          setState(() {
                            _rowsPerPage = value!;
                          });
                        },
                     )))
        ],
      ),
    );
  }
}

// DataTableSource for handling data in the DataTable
class QuestionDataSource extends DataTableSource {
  final List<Mcqs> questions;

  QuestionDataSource(this.questions);

  @override
  DataRow? getRow(int index) {
    if (index >= questions.length) return null;
    final question = questions[index];
    return DataRow(cells: [
      DataCell(Text(question.questionType ?? "")),
      DataCell(Text(question.title ?? "")),
      DataCell(Text(question.question ?? "")),
      DataCell(Text(question.optionA ?? "")),
      DataCell(Text(question.optionB ?? "")),
      DataCell(Text(question.optionC ?? "")),
      DataCell(Text(question.optionD ?? "")),
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
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => questions.length;

  @override
  int get selectedRowCount => 0;
}

