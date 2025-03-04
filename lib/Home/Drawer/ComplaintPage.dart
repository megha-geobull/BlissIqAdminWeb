import 'package:blissiqadmin/Global/constants/app_string.dart';
import 'package:blissiqadmin/Home/Drawer/MyDrawer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:blissiqadmin/Global/constants/CommonSizedBox.dart';
import 'package:blissiqadmin/Home/Users/Mentor/MentorListBottomSheet.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../../Global/constants/CustomAlertDialogue.dart';
import '../Controller/Complaint_Controller.dart';
import 'models/ComplaintModel.dart';


class ComplaintPage extends StatefulWidget {
  const ComplaintPage({super.key});

  @override
  State<ComplaintPage> createState() => _ComplaintPageState();
}

class _ComplaintPageState extends State<ComplaintPage> {
  final ComplaintController complaintController = Get.put(ComplaintController());
  Set<String> selectedStudentIds = {};
  bool isSelectAll = false;
  List<ComplaintData> filteredStudentData = [];
  Map<String, bool> editingStates = {};
  final TextEditingController searchController = TextEditingController();
  Map<String, String?> assignedMentors = {};

  @override
  void initState() {
    super.initState();
    //filteredStudentData = complaintController.allComplaintData;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      complaintController.getAllComplaints();
      searchController.clear();
      _filterStudents(''); // Clear search on init
    });
  }

  @override
  void didUpdateWidget(covariant ComplaintPage oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    //filteredStudentData = complaintController.allComplaintData;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      complaintController.allComplaintData();
      searchController.clear();
      _filterStudents('');
    });
    setState(() {

    });
  }


  void _filterStudents(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredStudentData = complaintController.allComplaintData;
      } else {
        filteredStudentData = complaintController.allComplaintData
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
          //complaintController.delete_Learners(student_id);
          //complaintController.getAllLearners();
          Navigator.pop(context);
          selectedStudentIds.clear();
          setState(() {});
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: Obx(() {
        return complaintController.isLoading.value
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
              // if (selectedStudentIds.isNotEmpty)
              //   ElevatedButton.icon(
              //     style: ElevatedButton.styleFrom(
              //       backgroundColor: Colors.red.shade100,
              //       padding: const EdgeInsets.symmetric(
              //           horizontal: 19, vertical: 15),
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(8),
              //       ),
              //     ),
              //     icon: const Icon(Icons.delete, color: Colors.red),
              //     label: const Text(
              //       "Delete",
              //       style: TextStyle(
              //         color: Colors.red,
              //         fontWeight: FontWeight.bold,
              //       ),
              //     ),
              //     onPressed: () async {
              //       print("Selected Ids - ${selectedStudentIds.join('|')}");
              //       Future.delayed(const Duration(seconds: 1), () async {
              //         onDelete("You want to delete this student?",
              //             selectedStudentIds.join('|'));
              //       });
              //     },
              //   ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
              child: complaintController.isLoading.value
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
            DataColumn(label: Text('Mentor')),
            //DataColumn(label: Text('School')),
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

  final List<ComplaintData> students;
  final BuildContext context;
  final _ComplaintPageState studentScreenState;
  String selectedStatus = 'Pending';
  List<String> statuses = ['Pending', 'Under Investigation', 'Solved'];
  final ComplaintController complaintController = Get.put(ComplaintController());
  List<DataRow> dataTableRows = [];

  void buildDataTableRows() {
    dataTableRows = students.map<DataRow>((dataRow) {
      return DataRow(
        // selected: studentScreenState.selectedStudentIds.contains(dataRow.id),
        // onSelectChanged: (isSelected) {
        //   if (isSelected == true) {
        //     studentScreenState.selectedStudentIds.add(dataRow.id ?? '');
        //   } else {
        //     studentScreenState.selectedStudentIds.remove(dataRow.id ?? '');
        //   }
        //   studentScreenState.setState(() {});
        // },
        cells: [

          DataCell(
            Text(dataRow.userName ?? 'No Name'),
          ),
          DataCell(
             Text(dataRow.email ?? 'No Email'),
          ),
          DataCell(
            Text(dataRow.mentorDetails?.fullName?.toString() ?? '-'),
          ),
          // DataCell(
          //   Text(dataRow.s?.toString() ?? '-'),
          // ),
          DataCell(
            GestureDetector(
              onTap: () {
                showComplaintDialog(context, dataRow.issue!);
              },
              child: SizedBox(
                width: Get.width > 200 ? 200 : 150,
                child: Text(
                  dataRow.issue!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
          DataCell(
            GestureDetector(
              onTap: () {
                showAttachmentDialog(context,dataRow.attachment!);
              },
              child: const Text(
                "View Attachment",
                style: TextStyle(fontSize: 16,color: Colors.blue,decorationColor: Colors.blue,decoration: TextDecoration.underline),
              ),
            ),
          ),

          DataCell(
            DropdownButton<String>(
              value: selectedStatus,
              onChanged: (String? newValue) {
                  selectedStatus = newValue!;
                  confirmUpdateStatus(dataRow.id ?? '',selectedStatus);
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
    String imagPath = "http://65.0.211.122:4444"+imageUrl;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Attachment"),
          content: Container(
            width: Get.width > 500 ? 500 : 200,
            child: Image.network(imagPath),
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

  void confirmUpdateStatus(String id,String complaint_status) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Confirm Status Update"),
        content: Text("Are you sure you want to update this complaint status?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              complaintController.UpdateStatusComplaints(complaint_id: id,complaint_status: complaint_status);
              Navigator.pop(context);
            },
            child: Text("Yes"),
          ),
        ],
      ),
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
