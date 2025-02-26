import 'package:blissiqadmin/Global/constants/ApiString.dart';
import 'package:blissiqadmin/Global/constants/CustomTextField.dart';
import 'package:blissiqadmin/Home/Quetion%20type%20widgets/controller/GetAllQuestionsApiController.dart';
import 'package:blissiqadmin/Home/Quetion%20type%20widgets/model/get_mcqs.dart';
import 'package:blissiqadmin/Home/Quetion%20type%20widgets/model/get_trueOrfalse_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TrueFalseDataTable extends StatefulWidget {
  final String main_category_id;
  final String sub_category_id;
  final String topic_id;
  final String sub_topic_id;
  final List<TrueOrFalse> questionList;

  TrueFalseDataTable(
      {required this.main_category_id,
      required this.sub_category_id,
      required this.topic_id,
      required this.sub_topic_id,
      required this.questionList});

  @override
  _TrueFalseDataTableState createState() => _TrueFalseDataTableState();
}

class _TrueFalseDataTableState extends State<TrueFalseDataTable> {
  TextEditingController _searchController = TextEditingController();
  List<TrueOrFalse> _filteredQuestions = [];
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  final _verticalScrollController = ScrollController();
  final _horizontalScrollController = ScrollController();
  String _selectedQuestionIds = "";
  bool isSelectAll = false;
  List<String> selected_question_ids = [];
  late TrueFalseDataSource _dataSource;
  final GetAllQuestionsApiController _getdeleteApiController = Get.find();

  @override
  void initState() {
    super.initState();
    // Initialize with API data
    _dataSource = TrueFalseDataSource(
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
                question.question != null &&
                question.question!.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
      // Update the data source with the filtered questions
      _dataSource = TrueFalseDataSource(
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
        _dataSource = TrueFalseDataSource(
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
                        const DataColumn(label: Text("Index")),
                        const DataColumn(label: Text("Question Type")),
                        const DataColumn(label: Text("Question")),
                        const DataColumn(label: Text("Answer")),
                        const DataColumn(label: Text("Points")),
                        const DataColumn(label: Text("Question Image")),
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

// DataTableSource for handling data in the DataTable
class TrueFalseDataSource extends DataTableSource {
  final List<TrueOrFalse> questions;
  final Function(String) onSelectionChanged; // Callback for selection
  final Set<String> selectedQuestionIds = {}; // Track selected question IDs
  bool isSelectAll = false; // Track "Select All" state
  BuildContext context;

  int? editingRowIndex; // Track which row is being edited
  List<TextEditingController> questionTypeControllers = [];
  List<TextEditingController> questionControllers = [];
  List<TextEditingController> answerControllers = [];
  List<TextEditingController> pointsControllers = [];
  List<TextEditingController> indexControllers = [];
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

  TrueFalseDataSource(this.questions, this.onSelectionChanged, this.context) {
    // Initialize controllers for each question
    for (var question in questions) {
      questionTypeControllers
          .add(TextEditingController(text: question.questionType));
      questionControllers.add(TextEditingController(text: question.question));
      answerControllers.add(TextEditingController(text: question.answer));
      pointsControllers
          .add(TextEditingController(text: question.points.toString()));
      indexControllers
          .add(TextEditingController(text: question.index.toString()));
      questionImageControllers
          .add(TextEditingController(text: question.qImage.toString()));
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
                  selectedQuestionIds.join('|')); // Pipe-separated IDs
              notifyListeners();
            },
          ),
        ),
        DataCell(_buildEditableField(index, indexControllers)),
        DataCell(_buildEditableField(index, questionTypeControllers)),
        DataCell(_buildEditableField(index, questionControllers)),
        DataCell(_buildEditableField(index, answerControllers)),
        DataCell(_buildEditableField(index, pointsControllers)),
        DataCell(_buildEditableField(index, questionImageControllers)),
        DataCell(_buildEditButton(index)),

      ],
    );
  }

  Widget _buildEditableField(int index, List<TextEditingController> controllers) {
    if (index >= controllers.length) return const Text("");

    if (controllers == questionImageControllers) {
      return editingRowIndex == index
          ? SizedBox(
        width: 50,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: isFilePicked ? Colors.green : Colors.blue, width: 1.5),
            borderRadius: BorderRadius.circular(8),
          ),
          child: IconButton(
            icon: Icon(Icons.image, color: isFilePicked ? Colors.green :Colors.blue),
            onPressed: () => pickFile(),
          ),
        ),
      )
          : controllers[index].text.isNotEmpty && controllers[index].text != "null"
          ? SizedBox(
        width: 50, // Ensure image preview doesn't take excessive space
        child: CachedNetworkImage(
          imageUrl: ApiString.ImgBaseUrl + controllers[index].text,
          progressIndicatorBuilder: (context, url, downloadProgress) =>
              CircularProgressIndicator(value: downloadProgress.progress),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
      )
          : const Icon(Icons.broken_image, color: Colors.grey);
    }

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
    if (index >= questions.length) return;

    final   updatedQuestion = TrueOrFalse(
      id: questions[index].id,
      questionType: questionTypeControllers[index].text,
      index: int.tryParse(indexControllers[index].text) ?? questions[index].index,
      answer: answerControllers[index].text,
      question:questionControllers[index].text,
      qImage:questionImageControllers[index].text,
      points: int.tryParse(pointsControllers[index].text) ?? questions[index].points,
      mainCategoryId: questions[index].mainCategoryId,
      subCategoryId: questions[index].subCategoryId,
      topicId: questions[index].topicId,
      subTopicId: questions[index].subTopicId,
    );

    try {
      questions[index] = updatedQuestion;
      await updateQueApiController.updateTrueFalseTableQuestionApi(updatedQuestion,pathsFile)
          .whenComplete(() => updateQueApiController.getTrueORFalse(
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
      if (confirmed) {
        _deleteSelectedQuestions(selectedQuestionIds.join('|'));
      }
      selectedQuestionIds.clear();
    }

    onSelectionChanged(selectedQuestionIds.join('|'));
    notifyListeners(); // Update UI
  }

  _deleteSelectedQuestions(String ids) async {
    final deleteApiController = Get.find<GetAllQuestionsApiController>();

    if (selectedQuestionIds.isNotEmpty) {
      try {

        await deleteApiController.deleteTrueOrFalseAPI(question_ids:ids);
        await deleteApiController.getTrueORFalse(
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

  _showConfirmationDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Confirm Deletion'),
              content: const Text(
                  'Do you really want to delete the selected true false question ?'),
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
        false;
  }

}
