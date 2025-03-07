import 'package:blissiqadmin/Global/constants/CustomTextField.dart';
import 'package:blissiqadmin/Home/Quetion%20type%20widgets/controller/GetAllQuestionsApiController.dart';
import 'package:blissiqadmin/Home/Quetion%20type%20widgets/model/GetCompleteWordModel.dart';
import 'package:blissiqadmin/Home/Quetion%20type%20widgets/model/UserConversationModel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class ConversationTable extends StatefulWidget {
  final String main_category_id;
  final String sub_category_id;
  final String topic_id;
  final String sub_topic_id;
  final List<UserConversationalData> questionList;

  ConversationTable({
    required this.main_category_id,
    required this.sub_category_id,
    required this.topic_id,
    required this.sub_topic_id,
    required this.questionList,
  });

  @override
  _ConversationTableState createState() => _ConversationTableState();
}

class _ConversationTableState extends State<ConversationTable> {
  TextEditingController _searchController = TextEditingController();
  List<UserConversationalData> _filteredQuestions = [];
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  final _verticalScrollController = ScrollController();
  String _selectedQuestionIds = "";
  bool isSelectAll = false;
  List<String> selected_question_ids = [];
  late QuestionDataSource _dataSource;
  final GetAllQuestionsApiController _getdeleteApiController = Get.find();

  @override
  void initState() {
    super.initState();
    _filteredQuestions = widget.questionList;
    _dataSource = QuestionDataSource(
      _filteredQuestions,
          (selectedIds) {
        setState(() {
          _selectedQuestionIds = selectedIds;
        });
      },
      context,
    );
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
      _dataSource = QuestionDataSource(
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
                    ),
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
                      bool confirmed = await _dataSource._showConfirmationDialog(context);
                      if (confirmed) {
                        _dataSource._deleteSelectedQuestions(_selectedQuestionIds);
                      }
                    },
                  ),
              ],
            ),
            const SizedBox(height: 20),
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
                        DataColumn(label: Text("Index")),
                        DataColumn(label: Text("Question Type")),
                        DataColumn(label: Text("Title")),
                        DataColumn(label: Text("Bot Conversation")),
                        DataColumn(label: Text("User Conversation")),
                        DataColumn(label: Text("Options")),
                        DataColumn(label: Text("Answer")),
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
  final List<UserConversationalData> questions;
  final Function(String) onSelectionChanged;
  final Set<String> selectedQuestionIds = {};
  bool isSelectAll = false;
  BuildContext context;

  int? editingRowIndex;
  List<TextEditingController> questionTypeControllers = [];
  List<TextEditingController> titleControllers = [];
  List<TextEditingController> answerControllers = [];
  List<TextEditingController> indexControllers = [];
  List<TextEditingController> pointsControllers = [];
  List<TextEditingController> optionAControllers = [];
  List<TextEditingController> botConversationControllers = [];
  List<TextEditingController> userConversationControllers = [];

  final GetAllQuestionsApiController updateQueApiController = Get.find();

  QuestionDataSource(this.questions, this.onSelectionChanged, this.context) {
    for (var question in questions) {
      questionTypeControllers.add(TextEditingController(text: question.questionType));
      titleControllers.add(TextEditingController(text: question.title));
      answerControllers.add(TextEditingController(text: question.answer));
      optionAControllers.add(TextEditingController(text: question.options));
      indexControllers.add(TextEditingController(text: question.index.toString()));
      pointsControllers.add(TextEditingController(text: question.points.toString()));
      botConversationControllers.add(TextEditingController(text: question.botConversation ?? ""));
      userConversationControllers.add(TextEditingController(text: question.userConversation ?? ""));
    }
  }

  @override
  DataRow? getRow(int index) {
    if (index >= questions.length) return null;
    final question = questions[index];
    final isSelected = selectedQuestionIds.contains(question.id);

    return DataRow(
      selected: isSelected,
      onSelectChanged: (bool? value) {
        if (value == true) {
          selectedQuestionIds.add(question.id!);
        } else {
          selectedQuestionIds.remove(question.id);
        }
        isSelectAll = selectedQuestionIds.length == questions.length;
        onSelectionChanged(selectedQuestionIds.join('|'));
        notifyListeners();
      },
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
        DataCell(Text(question.index.toString())),
        DataCell(Text(question.questionType ?? "")),
        DataCell(Text(question.title ?? "")),
        DataCell(Text(question.botConversation ?? "")),
        DataCell(Text(question.userConversation ?? "")),
        DataCell(Text(question.options ?? "")),
        DataCell(Text(question.answer ?? "")),
        DataCell(Text(question.points.toString())),
        DataCell(_buildEditButton(index)),
      ],
    );
  }

  Widget _buildEditableField(int index, List<TextEditingController> controllers) {
    if (index >= controllers.length) return const Text("");

    return editingRowIndex == index
        ? TextField(
      controller: controllers[index],
      decoration: const InputDecoration(border: OutlineInputBorder()),
    )
        : Text(controllers[index].text);
  }

  Widget _buildEditButton(int index) {
    return editingRowIndex == index
        ? ElevatedButton(
      onPressed: () {
        _updateQuestion(index);
        editingRowIndex = null;
        notifyListeners();
      },
      child: const Text("Update"),
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
        style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
      ),
    );
  }

  void _updateQuestion(int index) async {
    if (index >= questions.length || index >= titleControllers.length) return;

    final updatedQuestion = UserConversationalData(
      id: questions[index].id,
      questionType: questionTypeControllers[index].text,
      index: int.tryParse(indexControllers[index].text) ?? questions[index].index,
      title: titleControllers[index].text,
      answer: answerControllers[index].text,
      points: int.tryParse(pointsControllers[index].text) ?? questions[index].points,
      mainCategoryId: questions[index].mainCategoryId,
      subCategoryId: questions[index].subCategoryId,
      topicId: questions[index].topicId,
      subTopicId: questions[index].subTopicId,
      botConversation: botConversationControllers[index].text,
      userConversation: userConversationControllers[index].text,
      userConversationType: questions[index].userConversationType,
      options: optionAControllers[index].text,
    );

    try {
      await updateQueApiController.updateConversationalApi(updatedQuestion, null)
          .whenComplete(() => updateQueApiController.getConversation(
        main_category_id: updatedQuestion.mainCategoryId.toString(),
        sub_category_id: updatedQuestion.subCategoryId.toString(),
        topic_id: updatedQuestion.topicId.toString(),
        sub_topic_id: updatedQuestion.subTopicId.toString(),
      ));

      questions[index] = updatedQuestion;
      notifyListeners();
    } catch (e) {
      print('Error updating question: $e');
    }
  }

  _deleteSelectedQuestions(String ids) async {
    final deleteApiController = Get.find<GetAllQuestionsApiController>();

    if (selectedQuestionIds.isNotEmpty) {
      try {
        await deleteApiController.deleteCompleteTheWordAPI(question_id: ids);
        await deleteApiController.getConversation(
          main_category_id: questions[0].mainCategoryId.toString(),
          sub_category_id: questions[0].subCategoryId.toString(),
          topic_id: questions[0].topicId.toString(),
          sub_topic_id: questions[0].subTopicId.toString(),
        );

        questions.removeWhere((question) => selectedQuestionIds.contains(question.id));
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
                Navigator.of(context).pop(false);
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    ) ?? false;
  }
}

