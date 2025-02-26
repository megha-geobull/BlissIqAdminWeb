import 'package:blissiqadmin/Global/constants/CustomTextField.dart';
import 'package:blissiqadmin/Home/Quetion%20type%20widgets/controller/GetAllQuestionsApiController.dart';
import 'package:blissiqadmin/Home/Quetion%20type%20widgets/model/GetCompleteWordModel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class CompleteWordTable extends StatefulWidget {
  final String main_category_id;
  final String sub_category_id;
  final String topic_id;
  final String sub_topic_id;
  final List<CompleteWordData> questionList;

  CompleteWordTable(
      {required this.main_category_id,
        required this.sub_category_id,
        required this.topic_id,
        required this.sub_topic_id,
        required this.questionList});

  @override
  _CompleteWordTableState createState() => _CompleteWordTableState();
}

class _CompleteWordTableState extends State<CompleteWordTable> {

  TextEditingController _searchController = TextEditingController();
  List<CompleteWordData> _filteredQuestions = [];
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  final _verticalScrollController = ScrollController();
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
                        //_removeSelectedQuestions();
                        bool confirmed = await _dataSource._showConfirmationDialog(context);
                        if(confirmed){
                          _dataSource._deleteSelectedQuestions(_selectedQuestionIds);
                        }
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
                         DataColumn(label: Text("Question")),
                         DataColumn(label: Text("Option A")),
                         DataColumn(label: Text("Option B")),
                         DataColumn(label: Text("Option C")),
                         DataColumn(label: Text("Option D")),
                         DataColumn(label: Text("Answer")),
                         DataColumn(label: Text("Question Image")),
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
  final List<CompleteWordData> questions;
  final Function(String) onSelectionChanged; // Callback for selection
  final Set<String> selectedQuestionIds = {}; // Track selected question IDs
  bool isSelectAll = false; // Track "Select All" state
  BuildContext context;

  int? editingRowIndex; // Track which row is being edited
  List<TextEditingController> questionTypeControllers = [];
  List<TextEditingController> titleControllers = [];
  List<TextEditingController> answerControllers = [];
  List<TextEditingController> indexControllers = [];
  List<TextEditingController> pointsControllers = [];
  List<TextEditingController> questionControllers = [];
  List<TextEditingController> optionAControllers = [];
  List<TextEditingController> optionBControllers = [];
  List<TextEditingController> optionCControllers = [];
  List<TextEditingController> optionDControllers = [];
  List<TextEditingController> questionImageControllers = [];

  List<PlatformFile>? _paths;
  var pathsFile;
  var pathsFileName;
  bool isFilePicked = false;
  pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: false,
      onFileLoading: (FilePickerStatus status) => print("status .... $status"),
      allowedExtensions: [
        'bmp',
        'dib',
        'gif',
        'jfif',
        'jpe',
        'jpg',
        'jpeg',
        'pbm',
        'pgm',
        'ppm',
        'pnm',
        'pfm',
        'png',
        'apng',
        'blp',
        'bufr',
        'cur',
        'pcx',
        'dcx',
        'dds',
        'ps',
        'eps',
        'fit',
        'fits',
        'fli',
        'flc',
        'ftc',
        'ftu',
        'gbr',
        'grib',
        'h5',
        'hdf',
        'jp2',
        'j2k',
        'jpc',
        'jpf',
        'jpx',
        'j2c',
        'icns',
        'ico',
        'im',
        'iim',
        'mpg',
        'mpeg',
        'tif',
        'tiff',
        'mpo',
        'msp',
        'palm',
        'pcd',
        'pdf',
        'pxr',
        'psd',
        'qoi',
        'bw',
        'rgb',
        'rgba',
        'sgi',
        'ras',
        'tga',
        'icb',
        'vda',
        'vst',
        'webp',
        'wmf',
        'emf',
        'xbm',
        'xpm'
      ],
    );

    if (result != null && result.files.isNotEmpty) {
      _paths = result.files;
      pathsFile = _paths!.first.bytes; // Store the bytes
      pathsFileName = _paths!.first.name; // Store the file name
      isFilePicked = true; // Mark file as picked
      notifyListeners();
    } else {
      print('No file selected');
    }
  }

  final GetAllQuestionsApiController updateQueApiController = Get.find();

  QuestionDataSource(this.questions, this.onSelectionChanged, this.context) {

    for (var question in questions) {
      questionTypeControllers.add(TextEditingController(text: question.questionType));
      titleControllers.add(TextEditingController(text: question.title));
      answerControllers.add(TextEditingController(text: question.answer));
      questionControllers.add(TextEditingController(text: question.question));
      optionAControllers.add(TextEditingController(text: question.optionA));
      optionBControllers.add(TextEditingController(text: question.optionB));
      optionCControllers.add(TextEditingController(text: question.optionC));
      optionDControllers.add(TextEditingController(text: question.optionD));
      indexControllers.add(TextEditingController(text: question.index.toString()));
      pointsControllers.add(TextEditingController(text: question.points.toString()));
      // questionImageControllers.add(TextEditingController(text: question.questionImage));
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
              onSelectionChanged(
                selectedQuestionIds.join('|'), // Pipe-separated IDs
              );
              notifyListeners(); // Update UI
            },
          ),
        ),

        DataCell(_buildEditableField(index, indexControllers)),
        DataCell(_buildEditableField(index, questionTypeControllers)),
        DataCell(_buildEditableField(index, titleControllers)),
        DataCell(_buildEditableField(index, questionControllers)),
        DataCell(_buildEditableField(index, optionAControllers)),
        DataCell(_buildEditableField(index, optionBControllers)),
        DataCell(_buildEditableField(index, optionCControllers)),
        DataCell(_buildEditableField(index, optionDControllers)),
        DataCell(_buildEditableField(index, answerControllers)),
        DataCell(_buildEditableField(index, questionImageControllers)),
        DataCell(_buildEditableField(index, pointsControllers)),
        DataCell(_buildEditButton(index)),

      ],
    );
  }
  Widget _buildEditableField(int index, List<TextEditingController> controllers) {
    if (index >= controllers.length) return const Text("");

    return editingRowIndex == index
        ? controllers == questionTypeControllers ? TextField(
      controller: controllers[index],
      enabled: false,
      decoration: const InputDecoration(border: OutlineInputBorder()),
    ) : TextField(
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

    final   updatedQuestion = CompleteWordData(
      id: questions[index].id,
      questionType: questionTypeControllers[index].text,
      index: int.tryParse(indexControllers[index].text) ?? questions[index].index,
      title: titleControllers[index].text,
      answer: answerControllers[index].text,
      question:questionControllers[index].text,
      // qImage:questionImageControllers[index].text,
      points: int.tryParse(pointsControllers[index].text) ?? questions[index].points,
      mainCategoryId: questions[index].mainCategoryId,
      subCategoryId: questions[index].subCategoryId,
      topicId: questions[index].topicId,
      subTopicId: questions[index].subTopicId,
      optionA: optionAControllers[index].text,
      optionB: optionBControllers[index].text,
      optionC: optionCControllers[index].text,
      optionD: optionDControllers[index].text,
    );

    try {
      questions[index] = updatedQuestion;
      await updateQueApiController.updateCompleteTheWordTableQuestionApi(updatedQuestion,pathsFile)
          .whenComplete(() => updateQueApiController.getCompleteWordApi(
        main_category_id: updatedQuestion.mainCategoryId.toString(),
        sub_category_id: updatedQuestion.subCategoryId.toString(),
        topic_id: updatedQuestion.topicId.toString(),
        sub_topic_id:updatedQuestion.subTopicId.toString(),
      ),);

      notifyListeners();
    } catch (e) {
      print('Error updating question: $e');
    }
  }

  /// call delete the story phrases api here
  /// multiple deletions
  _deleteSelectedQuestions(String ids) async {
    final deleteApiController = Get.find<GetAllQuestionsApiController>();

    if (selectedQuestionIds.isNotEmpty) {
      try {
        await deleteApiController.deleteCompleteTheWordAPI(question_id:ids);
        await deleteApiController.getCompleteWordApi(
          main_category_id: questions[0].mainCategoryId.toString(),
          sub_category_id: questions[0].subCategoryId.toString(),
          topic_id: questions[0].topicId.toString(),
          sub_topic_id: questions[0].subTopicId.toString(),
        );

        // Remove the deleted questions from the local list
        questions.removeWhere(
                (question) => selectedQuestionIds.contains(question.id));
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



