import 'package:blissiqadmin/Global/constants/ApiString.dart';
import 'package:blissiqadmin/Global/constants/CommonSizedBox.dart';
import 'package:blissiqadmin/Global/constants/CustomTextField.dart';
import 'package:blissiqadmin/Home/Quetion%20type%20widgets/controller/GetAllQuestionsApiController.dart';
import 'package:blissiqadmin/Home/Quetion%20type%20widgets/model/CardFlipModel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:typed_data' as td;
import 'package:image_picker_web/image_picker_web.dart';

class CardFlipQuestionTable extends StatefulWidget {
  final String main_category_id;
  final String sub_category_id;
  final String topic_id;
  final String sub_topic_id;
  final List<CardFlipData> questionList;

  CardFlipQuestionTable(
      {required this.main_category_id,
      required this.sub_category_id,
      required this.topic_id,
      required this.sub_topic_id,
      required this.questionList});

  @override
  _CardFlipQuestionTableState createState() => _CardFlipQuestionTableState();
}

class _CardFlipQuestionTableState extends State<CardFlipQuestionTable> {
  TextEditingController _searchController = TextEditingController();
  List<CardFlipData> _filteredQuestions = []; // Filtered data for the table
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
        context,
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
                        bool confirmed =
                            await _dataSource._showConfirmationDialog(context);
                        if (confirmed) {
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
                        DataColumn(label: Text("Index")),
                        DataColumn(label: Text("Question Type")),
                        DataColumn(label: Text("Title")),
                        DataColumn(label: Text("Entries")),
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
  final List<CardFlipData> questions;
  final Function(String) onSelectionChanged;
  final Set<String> selectedQuestionIds = {};
  bool isSelectAll = false;
  BuildContext context;

  int? editingRowIndex;
  List<TextEditingController> questionTypeControllers = [];
  List<TextEditingController> indexControllers = [];
  List<TextEditingController> titleControllers = [];
  List<TextEditingController> questionLanguageController = [];
  List<TextEditingController> pointsControllers = [];

  List<TextEditingController> questionControllers = [];
  List<TextEditingController> answerControllers = [];
  List<td.Uint8List> questionImages = [];
  final List<String> imageNames = [];
  bool isFilePicked = false;

  _pickImg(int index) async {
    final imageBytes = await ImagePickerWeb.getImageAsBytes();
    if (imageBytes != null) {
      questionImages[index] = imageBytes;
      isFilePicked = true;
      notifyListeners();
    }
  }

  final GetAllQuestionsApiController updateQueApiController = Get.find();

  QuestionDataSource(this.questions, this.onSelectionChanged, this.context) {
    for (var question in questions) {
      questionTypeControllers
          .add(TextEditingController(text: question.questionType));
      indexControllers
          .add(TextEditingController(text: question.index.toString()));
      titleControllers.add(TextEditingController(text: question.title));
      pointsControllers
          .add(TextEditingController(text: question.points.toString()));
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
        DataCell(_buildEditableField(index, indexControllers)),
        DataCell(_buildEditableField(index, questionTypeControllers)),
        DataCell(_buildEditableField(index, titleControllers)),
        DataCell(
          ElevatedButton(
            onPressed: () {
              _showEntriesDialog(context, question.entries ?? [], index);
            },
            child: editingRowIndex == index
                ? const Text("Edit")
                : const Text("View"),
          ),
        ),
        DataCell(_buildEditableField(index, pointsControllers)),
        DataCell(_buildEditButton(index)),
      ],
    );
  }

  void _showEntriesDialog(BuildContext context, List<Entries> entries, int questionIndex) async {
    questionControllers.clear();
    answerControllers.clear();
    questionImages.clear();

    for (var entry in entries) {
      questionControllers.add(TextEditingController(text: entry.image));
      answerControllers.add(TextEditingController(text: entry.letter));

    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Entries'),
          content: SizedBox(
            width: 350, // Reduced width
            child: SingleChildScrollView(
              child: Column(
                children: List.generate(entries.length, (i) {
                  return Column(
                    children: [
                      Row(
                        children: [
                          editingRowIndex == questionIndex ?
                          SizedBox(
                            width: 40, // Smaller button
                            height: 40,
                            child: IconButton(
                              icon: Icon(Icons.image, color: Colors.blue),
                              onPressed: () => _pickImg(i),
                            ),
                          ) : SizedBox.shrink(),
                          const SizedBox(width: 10),

                          if (questionImages[i] != null)
                            SizedBox(
                              width: 80, // Smaller image
                              height: 80,
                              child: Image.memory(
                                questionImages[i]!,
                                fit: BoxFit.cover,
                              ),
                            )
                          else if (questionControllers[i].text.isNotEmpty &&
                              questionControllers[i].text != "null")
                            SizedBox(
                              width: 80,
                              height: 80,
                              child: CachedNetworkImage(
                                imageUrl: ApiString.ImgBaseUrl +
                                    'media/' +
                                    questionControllers[i].text,
                                progressIndicatorBuilder: (context, url, progress) =>
                                    CircularProgressIndicator(value: progress.progress),
                                errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                              ),
                            )
                          else
                            const Icon(Icons.broken_image, color: Colors.grey, size: 50),

                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: answerControllers[i],
                              decoration: const InputDecoration(labelText: 'Letters / Words'),
                              enabled: editingRowIndex == questionIndex,
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            if (editingRowIndex == questionIndex)
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  notifyListeners();
                },
                child: const Text('Save'),
              ),
          ],
        );
      },
    );
  }


  Widget _buildEditableField(
      int index, List<TextEditingController> controllers) {
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
            child: const Text("Edit",
                style: TextStyle(
                    color: Colors.blue, decoration: TextDecoration.underline)),
          );
  }

  void _updateQuestion(int index) async {
    if (index >= questions.length) return;

    final updatedQuestion = CardFlipData(
      id: questions[index].id,
      questionType: questionTypeControllers[index].text,
      index:
          int.tryParse(indexControllers[index].text) ?? questions[index].index,
      points: int.tryParse(pointsControllers[index].text) ??
          questions[index].points,
      mainCategoryId: questions[index].mainCategoryId,
      subCategoryId: questions[index].subCategoryId,
      topicId: questions[index].topicId,
      subTopicId: questions[index].subTopicId,
      title: titleControllers[index].text,
    );

    try {
      questions[index] = updatedQuestion;
      updateQueApiController.updateCardFlip(question: updatedQuestion,
          images: questionImages,
          letters: questionControllers.join('|'),
          context: context);

      notifyListeners();
    } catch (e) {
      print('Error updating question: $e');
    }
  }

  toggleSelectAll(bool value) async {
    isSelectAll = value;

    if (isSelectAll) {
      selectedQuestionIds
          .addAll(questions.map((question) => question.id!).toList());
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

  _showConfirmationDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Confirm Deletion'),
              content: const Text(
                  'Do you really want to delete the selected phrases?'),
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

  _deleteSelectedQuestions() async {
    final deleteApiController = Get.find<GetAllQuestionsApiController>();

    if (selectedQuestionIds.isNotEmpty) {
      try {
        await deleteApiController.deleteFillInTheBlanksAPI(
          main_category_id: questions[0].mainCategoryId.toString(),
          sub_category_id: questions[0].subCategoryId.toString(),
          topic_id: questions[0].topicId.toString(),
          sub_topic_id: questions[0].subTopicId.toString(),
          question_id: selectedQuestionIds.join('|'),
        );

        await deleteApiController.getStoryPhrases(
          main_category_id: questions[0].mainCategoryId.toString(),
          sub_category_id: questions[0].subCategoryId.toString(),
          topic_id: questions[0].topicId.toString(),
          sub_topic_id: questions[0].subTopicId.toString(),
        );

        questions.removeWhere(
            (question) => selectedQuestionIds.contains(question.id));
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
}
