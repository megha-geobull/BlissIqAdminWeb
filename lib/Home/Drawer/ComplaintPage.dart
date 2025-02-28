import 'package:blissiqadmin/Home/Drawer/MyDrawer.dart';
import 'package:blissiqadmin/auth/Controller/StudentController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:blissiqadmin/Global/constants/ApiString.dart';
import 'package:blissiqadmin/Global/constants/AppColor.dart';
import 'package:blissiqadmin/Global/constants/CommonSizedBox.dart';
import 'package:blissiqadmin/Home/Drawer/MyDrawer.dart';
import 'package:blissiqadmin/Home/Users/Mentor/MentorListBottomSheet.dart';
import 'package:blissiqadmin/Home/Users/Models/AllStudentModel.dart';
import 'package:blissiqadmin/auth/Controller/StudentController.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../Global/constants/CustomAlertDialogue.dart';


class ComplaintPage extends StatefulWidget {
  const ComplaintPage({super.key});

  @override
  State<ComplaintPage> createState() => _ComplaintPageState();
}

class _ComplaintPageState extends State<ComplaintPage> {
  final StudentController studentController = Get.put(StudentController());
  Set<String> selectedStudentIds = {};
  bool isSelectAll = false;
  List<Data> filteredStudentData = [];
  Map<String, bool> editingStates = {};
  final TextEditingController searchController = TextEditingController();
  Map<String, String?> assignedMentors = {};

  @override
  void initState() {
    super.initState();
    filteredStudentData = studentController.allLearnerData;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      studentController.getAllLearners();
      searchController.clear();
      _filterStudents(''); // Clear search on init
    });
  }

  @override
  void didUpdateWidget(covariant ComplaintPage oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    filteredStudentData = studentController.allLearnerData;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      studentController.getAllLearners();
      searchController.clear();
      _filterStudents('');
    });
    setState(() {

    });
  }


  void _filterStudents(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredStudentData = studentController.allLearnerData;
      } else {
        filteredStudentData = studentController.allLearnerData
            .where((student) => student.userName!
            .toLowerCase()
            .contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  void onDelete(String title, String student_id) {
    showDialog(
      context: context,
      builder: (context) => CustomAlertDialog(
        title: 'Are you sure',
        content: title,
        yesText: 'Yes',
        noText: 'No',
        onYesPressed: () {
          studentController.delete_Learners(student_id);
          studentController.getAllLearners();
          Navigator.pop(context);
          selectedStudentIds.clear();
          setState(() {});
        },
      ),
    );
  }

  void _showMentorBottomSheet(BuildContext context, String? studentId) async {
    String? selectedMentor = await showModalBottomSheet<String>(
      context: context,
      builder: (context) {
        return MentorListBottomSheet(studentId);
      },
    );
    if (selectedMentor != null) {
      setState(() {
        assignedMentors[studentId!] = selectedMentor;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Assigned to $selectedMentor')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: Obx(() {
        return studentController.isLoading.value
            ? Center(
          child: LoadingAnimationWidget.hexagonDots(
            color: Colors.deepOrange,
            size: 70,
          ),
        )
            : LayoutBuilder(
          builder: (context, constraints) {
            bool isWideScreen = constraints.maxWidth > 800;
            return Row(
              children: [
                if (isWideScreen)
                  Container(
                    width: 250,
                    color: Colors.orange.shade100,
                    child: const MyDrawer(),
                  ),
                Expanded(
                  child: Scaffold(
                    appBar: isWideScreen
                        ? null
                        : AppBar(
                      title: const Text('Dashboard'),
                      backgroundColor: Colors.blue.shade100,
                    ),
                    body: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 16),
                      child: _buildStudentMainContent(),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      }),
    );
  }

  Widget _buildStudentMainContent() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          boxH15(),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: 'Search by name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onChanged: (value) {
                    _filterStudents(value);
                  },
                ),
              ),
              boxW15(),
              if (selectedStudentIds.isNotEmpty)
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade100,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 19, vertical: 15),
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
                    print("Selected Ids - ${selectedStudentIds.join('|')}");
                    Future.delayed(const Duration(seconds: 1), () async {
                      onDelete("You want to delete this student?",
                          selectedStudentIds.join('|'));
                    });
                  },
                ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
              child: studentController.isLoading.value
                  ? Center(
                child: LoadingAnimationWidget.hexagonDots(
                  color: Colors.deepOrange,
                  size: 70,
                ),
              )
                  : _buildStudentDataTable()),
        ],
      ),
    );
  }

  Widget _buildStudentDataTable() {
    return Card(
      elevation: 0.8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: SingleChildScrollView(
        child: PaginatedDataTable(
          header: const Row(
            children: [
              Text('Students'),
            ],
          ),
          columns: const [

            DataColumn(label: Text('Name')),
            DataColumn(label: Text('Email')),
            DataColumn(label: Text('Contact No')),
            DataColumn(label: Text('School')),
            DataColumn(label: Text('Claim')),
            DataColumn(label: Text('Attachment')),

            DataColumn(label: Text('Status')),

          ],
          source: StudentDataTableSource(
            filteredStudentData,
            context,
            this,
          ),
          rowsPerPage: 10,
          showFirstLastButtons: true,
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.orange.shade100,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            const Text(
              'All Registered Students',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.black),
            ),
            const Spacer(),
            Tooltip(
              message: 'Add a New Student',
              child: ElevatedButton.icon(
                onPressed: () {
                  // Navigate to add student screen
                },
                icon: const Icon(Icons.add, color: Colors.white, size: 20),
                label: const Text("Add Student",
                    style: TextStyle(color: Colors.white, fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StudentDataTableSource extends DataTableSource {
  StudentDataTableSource(this.students, this.context, this.studentScreenState) {
    buildDataTableRows();
  }

  final List<Data> students;
  final BuildContext context;
  final _ComplaintPageState studentScreenState;
  final String complaintMessage =
      "Despite reaching out for assistance regarding the issue,"
      " I experienced delays and unhelpful responses. "
      "I would appreciate it if you could look into this"
      " matter and provide a resolution.";
  String selectedStatus = 'Pending';
  List<String> statuses = ['Pending', 'Under Investigation', 'Solved'];

  List<DataRow> dataTableRows = [];

  void buildDataTableRows() {
    dataTableRows = students.map<DataRow>((dataRow) {
      final isEditing = studentScreenState.editingStates[dataRow.id] ?? false;
      return DataRow(
        selected: studentScreenState.selectedStudentIds.contains(dataRow.id),
        onSelectChanged: (isSelected) {
          if (isSelected == true) {
            studentScreenState.selectedStudentIds.add(dataRow.id ?? '');
          } else {
            studentScreenState.selectedStudentIds.remove(dataRow.id ?? '');
          }
          studentScreenState.setState(() {});
        },
        cells: [

          DataCell(
            isEditing
                ? TextFormField(
              initialValue: dataRow.userName,
              onChanged: (value) {
                // dataRow.userName = value;
              },
            )
                : Text(dataRow.userName ?? 'No Name'),
          ),
          DataCell(
            isEditing
                ? TextFormField(
              initialValue: dataRow.email,
              onChanged: (value) {
                // dataRow.email = value;
              },
            )
                : Text(dataRow.email ?? 'No Email'),
          ),
          DataCell(
            isEditing
                ? TextFormField(
              initialValue: dataRow.contactNo?.toString(),
              onChanged: (value) {
                // dataRow.contactNo = value;
              },
            )
                : Text(dataRow.contactNo?.toString() ?? '-'),
          ),
          DataCell(
            isEditing
                ? TextFormField(
              initialValue: dataRow.school,
              onChanged: (value) {
                // dataRow.school = value;
              },
            )
                : Text(dataRow.school ?? 'No School'),
          ),

          DataCell(
         // Text("Despite reaching out for assistance regarding [briefly mention issue], I "
         //     "experienced delays and unhelpful responses. "
         //     "I would appreciate it if you could look into this matter and provide a resolution."),
            GestureDetector(
              onTap: () {
                showComplaintDialog(context, complaintMessage);
              },
              child: SizedBox(
                width: Get.width > 500 ? 500 : 250,
                child: Text(
                  complaintMessage,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
          DataCell(
         // Text("Despite reaching out for assistance regarding [briefly mention issue], I "
         //     "experienced delays and unhelpful responses. "
         //     "I would appreciate it if you could look into this matter and provide a resolution."),
            GestureDetector(
              onTap: () {
                showAttachmentDialog(context, "assets/top_profile.png");
              },
              child: Text(
                "View Attachment",
                style: const TextStyle(fontSize: 16,color: Colors.blue,decorationColor: Colors.blue,decoration: TextDecoration.underline),
              ),
            ),
          ),

          DataCell(

            DropdownButton<String>(
              value: selectedStatus,
              onChanged: (String? newValue) {
                  selectedStatus = newValue!;
              },
              items: statuses.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        ],
      );
    }).toList();
  }

  void showComplaintDialog(BuildContext context, String complaintMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Complaint Message"),
          content: Container(
            width: Get.width > 500 ? 500 : 200,
            child: Text(complaintMessage),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }
  void showAttachmentDialog(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Attachment"),
          content: Container(
            width: Get.width > 500 ? 500 : 200,
            child: Image.asset(imageUrl),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }


  @override
  DataRow? getRow(int index) => dataTableRows[index];

  @override
  int get rowCount => dataTableRows.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => studentScreenState.selectedStudentIds.length;
}
