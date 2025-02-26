import 'package:blissiqadmin/Global/constants/ApiString.dart';
import 'package:blissiqadmin/Global/constants/AppColor.dart';
import 'package:blissiqadmin/Global/constants/CustomTextField.dart';
import 'package:blissiqadmin/Home/Quetion%20type%20widgets/controller/GetAllQuestionsApiController.dart';
import 'package:blissiqadmin/Home/Quetion%20type%20widgets/model/GetCompleteParagraphModel.dart';
import 'package:blissiqadmin/Home/Quetion%20type%20widgets/model/get_match_the_pairs.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:typed_data' as td;

import 'package:image_picker_web/image_picker_web.dart';


class MatchThePairsQuestionTable extends StatefulWidget {
  final String main_category_id;
  final String sub_category_id;
  final String topic_id;
  final String sub_topic_id;
  final List<MatchPairs> questionList;

  MatchThePairsQuestionTable(
      {required this.main_category_id,
        required this.sub_category_id,
        required this.topic_id,
        required this.sub_topic_id,
        required this.questionList});

  @override
  _MatchThePairsQuestionTableState createState() => _MatchThePairsQuestionTableState();
}

class _MatchThePairsQuestionTableState extends State<MatchThePairsQuestionTable> {

  TextEditingController _searchController = TextEditingController();
  List<MatchPairs> _filteredQuestions = [];
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
                        bool cofirmed = await _dataSource._showConfirmationDialog(context);
                        if(cofirmed){
                          _dataSource._deleteSelectedQuestions(_selectedQuestionIds);
                        }
                        _getdeleteApiController.getCompleteParaApi(
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

// DataTableSource for handling data in the DataTable
class QuestionDataSource extends DataTableSource {
  final List<MatchPairs> questions;
  final Function(String) onSelectionChanged; // Callback for selection
  final Set<String> selectedQuestionIds = {}; // Track selected question IDs
  bool isSelectAll = false;
  BuildContext context;
  // Track "Select All" state
  int? editingRowIndex; // Track which row is being edited
  List<TextEditingController> questionTypeControllers = [];
  List<TextEditingController> titleControllers = [];
  List<TextEditingController> indexControllers = [];
  List<TextEditingController> pointsControllers = [];

  List<TextEditingController> questionControllers = [];
  List<TextEditingController> answerControllers = [];
  List<td.Uint8List> questionImages = [];
  List<td.Uint8List> answerImages = [];
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
    // Initialize controllers for each question
    for (var question in questions) {
      questionTypeControllers.add(TextEditingController(text: question.questionType));
      titleControllers.add(TextEditingController(text: question.title));
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

        DataCell(_buildEditableField(index, indexControllers)),
        DataCell(_buildEditableField(index, questionTypeControllers)),
        DataCell(_buildEditableField(index, titleControllers)),
        DataCell(
          ElevatedButton(
            onPressed: () {
              _showEntriesDialog(context, question.entries ?? [], index,question);
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

  void _showEntriesDialog(BuildContext context, List<Entries> entries,
      int questionIndex, MatchPairs question) async {
    // Clear the lists
    questionControllers.clear();
    answerControllers.clear();
    questionImages.clear();
    answerImages.clear();

    // Initialize the lists with the correct number of elements
    for (var entry in entries) {
      if (question.questionFormat == 'Image') {
        questionControllers.add(TextEditingController(text: entry.questionImg));
      } else {
        questionControllers.add(TextEditingController(text: entry.question));
      }
      if (question.answerFormat == 'Image') {
        answerControllers.add(TextEditingController(text: entry.answerImg));
      } else {
        answerControllers.add(TextEditingController(text: entry.answer));
      }
      questionImages.add(td.Uint8List(0)); // Initialize with an empty Uint8List
      answerImages.add(td.Uint8List(0)); // Initialize with an empty Uint8List
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title:  Text('Entries (${question.questionFormat}/${question.answerFormat})'),
              content: SizedBox(
                width: 350, // Reduced width
                child: SingleChildScrollView(
                  child: Column(
                    children: List.generate(entries.length, (i) {
                      return Column(
                        children: [
                          Row(
                            children: [
                              if (editingRowIndex == questionIndex && question.questionFormat == 'Image')
                                SizedBox(
                                  width: 40, // Smaller button
                                  height: 40,
                                  child: IconButton(
                                    icon: Icon(Icons.image, color: Colors.blue),
                                    onPressed: () => _pickImg(i),
                                  ),
                                ),
                              const SizedBox(width: 10),
                              if (question.questionFormat == 'Image')
                                (questionImages[i] != null && questionImages[i].isNotEmpty)
                                    ? SizedBox(
                                  width: 80,
                                  height: 80,
                                  child: Image.memory(
                                    questionImages[i]!,
                                    fit: BoxFit.cover,
                                  ),
                                )
                                    : (questionControllers[i].text.isNotEmpty && questionControllers[i].text != "null")
                                    ? SizedBox(
                                  width: 80,
                                  height: 80,
                                  child: CachedNetworkImage(
                                    imageUrl: ApiString.ImgBaseUrl + 'media/' + questionControllers[i].text,
                                    progressIndicatorBuilder: (context, url, progress) =>
                                        CircularProgressIndicator(value: progress.progress),
                                    errorWidget: (context, url, error) => const Icon(Icons.error),
                                  ),
                                )
                                    : const Icon(Icons.broken_image, color: Colors.grey, size: 50)
                              else
                                Expanded(
                                  child: TextField(
                                    controller: questionControllers[i],
                                    decoration: InputDecoration(
                                        labelText: 'Letters / Words',
                                      suffixIcon: question.questionFormat! == 'Sound' ? Icon(Icons.volume_down) : null
                                    ),
                                    enabled: editingRowIndex == questionIndex,

                                  ),
                                ),
                              const SizedBox(width: 20),
                              if (editingRowIndex == questionIndex && question.answerFormat == 'Image')
                                SizedBox(
                                  width: 40, // Smaller button
                                  height: 40,
                                  child: IconButton(
                                    icon: Icon(Icons.image, color: Colors.blue),
                                    onPressed: () => _pickImg(i),
                                  ),
                                ),
                              const SizedBox(width: 10),
                              if (question.answerFormat == 'Image')
                                (answerImages[i] != null && answerImages[i].isNotEmpty)
                                    ? SizedBox(
                                  width: 80,
                                  height: 80,
                                  child: Image.memory(
                                    answerImages[i]!,
                                    fit: BoxFit.cover,
                                  ),
                                )
                                    : (answerControllers[i].text.isNotEmpty && answerControllers[i].text != "null")
                                    ? SizedBox(
                                  width: 80,
                                  height: 80,
                                  child: CachedNetworkImage(
                                    imageUrl: ApiString.ImgBaseUrl + 'media/' + answerControllers[i].text,
                                    progressIndicatorBuilder: (context, url, progress) =>
                                        CircularProgressIndicator(value: progress.progress),
                                    errorWidget: (context, url, error) => const Icon(Icons.error),
                                  ),
                                )
                                    : const Icon(Icons.broken_image, color: Colors.grey, size: 50)
                              else
                                Expanded(
                                  child: TextField(
                                    controller: answerControllers[i],
                                    decoration: InputDecoration(
                                        labelText: 'Letters / Words',
                                        suffixIcon: question.answerFormat! == 'Sound' ? Icon(Icons.volume_down) : null
                                    ),                                    enabled: editingRowIndex == questionIndex,
                                  ),
                                ),
                              if (editingRowIndex == questionIndex)
                                IconButton(
                                  onPressed: () async {
                                    print('button pressed : ${entries[i].id.toString()}');
                                    if (entries[i].id != null) {
                                      await Get.find<GetAllQuestionsApiController>().deleteMatchThePairsEntryAPI(
                                        pair_id: entries[i].id.toString(),
                                      );
                                      await Get.find<GetAllQuestionsApiController>().getImagePuzzleList(
                                        main_category_id: question.mainCategoryId.toString(),
                                        sub_category_id: question.subCategoryId.toString(),
                                        topic_id: question.topicId.toString(),
                                        sub_topic_id: question.subTopicId.toString(),
                                      );
                                    }
                                    setState(() {
                                      entries.removeAt(i);
                                      questionControllers.removeAt(i);
                                      answerControllers.removeAt(i);
                                      questionImages.removeAt(i);
                                      answerImages.removeAt(i);
                                    });
                                  },
                                  icon: Icon(Icons.delete_forever_sharp, color: AppColor.red),
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
                    onPressed: () async {
                      final answer = answerControllers
                          .map((e) => e.text)
                          .where((text) => !entries.any((entry) => entry.answer == text)) // Filter out existing letters
                          .toList();
                      final questionList = questionControllers
                          .map((e) => e.text)
                          .where((text) => !entries.any((entry) => entry.question == text)) // Filter out existing letters
                          .toList();
print(answer);
print(questionList);

                        await Get.find<GetAllQuestionsApiController>().updateMatchThePairEntry(
                          context: context,
                          id: question.id ?? '', qImages: questionImages, aImages: answerImages,  question: questionList.join('|'), answer: answer.join('|'),
                        );
                        await Get.find<GetAllQuestionsApiController>().getCardFlip(
                          main_category_id: question.mainCategoryId.toString(),
                          sub_category_id: question.subCategoryId.toString(),
                          topic_id: question.topicId.toString(),
                          sub_topic_id: question.subTopicId.toString(),
                        );


                      Get.back();
                    },
                    child: const Text('Save'),
                  ),
                if (editingRowIndex == questionIndex)
                  TextButton(
                    onPressed: () {
                      setState(() {
                        entries.add(Entries(id: null,answer: '',answerImg: '',question: '',questionImg: ''));
                        questionControllers.add(TextEditingController());
                        answerControllers.add(TextEditingController());
                        questionImages.add(td.Uint8List(0));
                        answerImages.add(td.Uint8List(0));
                      });
                    },
                    child: const Text('Add New Entry'),
                  ),
              ],
            );
          },
        );
      },
    );
  }


  Widget _buildEditableField(
      int index, List<TextEditingController> controllers) {
    if (index >= controllers.length) return const Text("");
    return editingRowIndex == index
        ? TextField(
      enabled: controllers == questionTypeControllers ? false : true,
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
    if (index >= questions.length || index >= titleControllers.length) return;

    final   updatedQuestion = MatchPairs(
      id: questions[index].id,
      questionType: questionTypeControllers[index].text,
      index: int.tryParse(indexControllers[index].text) ?? questions[index].index,
      title: titleControllers[index].text,
      // answer: answerControllers[index].text,
      // question:questionControllers[index].text,
      points: int.tryParse(pointsControllers[index].text) ?? questions[index].points,
      mainCategoryId: questions[index].mainCategoryId,
      subCategoryId: questions[index].subCategoryId,
      topicId: questions[index].topicId,
      subTopicId: questions[index].subTopicId,
      // paragraphContent: paragraphController[index].text,
      // optionA: optionAControllers[index].text,
      // optionF: optionFControllers[index].text,
      // optionB: optionBControllers[index].text,
      // optionC: optionCControllers[index].text,
      // optionD: optionDControllers[index].text,
      // optionE: optionEControllers[index].text,
    );

    try {
      questions[index] = updatedQuestion;
      // await updateQueApiController.updateCompleteTheParagraphTableQuestionApi(updatedQuestion)
      //     .whenComplete(() => updateQueApiController.getCompleteParaApi(
      //   main_category_id: updatedQuestion.mainCategoryId.toString(),
      //   sub_category_id: updatedQuestion.subCategoryId.toString(),
      //   topic_id: updatedQuestion.topicId.toString(),
      //   sub_topic_id:updatedQuestion.subTopicId.toString(),
      // ),);

      notifyListeners();
    } catch (e) {
      print('Error updating question: $e');
    }
  }


  /// call delete the story phrases api here
  /// Delete the story phrases API here
  _deleteSelectedQuestions(String ids) async {
    final deleteApiController = Get.find<GetAllQuestionsApiController>();

    if (selectedQuestionIds.isNotEmpty) {
      try {
        await deleteApiController.deleteCompleteTheParagraphAPI(

          question_ids: ids,
        );

        // Refresh the list of questions
        await deleteApiController.getAllRe_Arrange(
          main_category_id: questions[0].mainCategoryId.toString(),
          sub_category_id: questions[0].subCategoryId.toString(),
          topic_id: questions[0].topicId.toString(),
          sub_topic_id: questions[0].subTopicId.toString(),
        );

        questions.removeWhere((question) => selectedQuestionIds.contains(question.id));
        selectedQuestionIds.clear(); // Clear selected IDs
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
        _deleteSelectedQuestions(selectedQuestionIds.join('|'));
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
