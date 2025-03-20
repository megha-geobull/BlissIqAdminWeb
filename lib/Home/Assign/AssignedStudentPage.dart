import 'package:blissiqadmin/Global/constants/ApiString.dart';
import 'package:blissiqadmin/Global/constants/AppColor.dart';
import 'package:blissiqadmin/Global/constants/CommonSizedBox.dart';
import 'package:blissiqadmin/Global/constants/CustomAlertDialogue.dart';
import 'package:blissiqadmin/Home/Drawer/MyDrawer.dart';
import 'package:blissiqadmin/Home/Users/Models/AllStudentModel.dart';
import 'package:blissiqadmin/Home/Users/Models/GetMentorsAssignModel.dart';
import 'package:blissiqadmin/Home/Users/Models/GetSchoolsAssignModel.dart';
import 'package:blissiqadmin/auth/Controller/AuthController.dart';
import 'package:blissiqadmin/auth/Controller/CompanyController/CompanyController.dart';
import 'package:blissiqadmin/auth/Controller/SchoolController/SchoolController.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class AssignedStudentPage extends StatefulWidget {
  final String schoolID;
  const AssignedStudentPage({super.key, required this.schoolID});

  @override
  State<AssignedStudentPage> createState() => _AssignedStudentPageState();
}
class _AssignedStudentPageState extends State<AssignedStudentPage> {
  final AuthController  authController = Get.put(AuthController());
  Set<String> selectedStudentIds = {};
  bool isSelectAll = false;
  List<Data> filteredStudentData = [];
  Map<String, bool> editingStates = {}; // Track editing state for each row
  final TextEditingController searchController = TextEditingController();
  Map<String, String?> assignedMentors = {};

  @override
  void initState() {
    super.initState();
    filteredStudentData = authController.assignStudentsData;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      authController.getAssignedStudentsApi(widget.schoolID);
      searchController.clear();
      _filterStudents(''); // Clear search on init
    });
  }

  @override
  void didUpdateWidget(covariant AssignedStudentPage oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    filteredStudentData = authController.assignStudentsData;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      authController.getAssignedStudentsApi(widget.schoolID);
      searchController.clear();
      _filterStudents(''); // Clear search on init
    });
    setState(() {

    });
  }


  void _filterStudents(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredStudentData = authController.assignStudentsData;
      } else {
        filteredStudentData = authController.assignStudentsData
            .where((student) => student.userName!
            .toLowerCase()
            .contains(query.toLowerCase()))
            .toList();
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: Obx(() {
        return authController.isLoading.value
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
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
              child: authController.isLoading.value
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
    if (filteredStudentData.isEmpty) {
      return Center(
        child: Text(
          searchController.text.isEmpty
              ? "No students available"
              : "No students found",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),
        ),
      );
    }

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
            DataColumn(label: Text('Profile')),
            DataColumn(label: Text('Name')),
            DataColumn(label: Text('Email')),
            DataColumn(label: Text('Contact No')),
            DataColumn(label: Text('School')),
            DataColumn(label: Text('Language')),
            DataColumn(label: Text('Purpose')),
            DataColumn(label: Text('Mentor')),
            DataColumn(label: Text('Actions')),
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
      child: const Padding(
        padding: EdgeInsets.all(8.0),
        child: Row(
          children: [
            Text(
              'All Assigned Students',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.black),
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
  final _AssignedStudentPageState studentScreenState;

  List<DataRow> dataTableRows = [];

  void buildDataTableRows() {
    dataTableRows = students.map<DataRow>((dataRow) {
      final isEditing = studentScreenState.editingStates[dataRow.id] ?? false;
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
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.white,
              child: CachedNetworkImage(
                imageUrl: ApiString.ImgBaseUrl + (dataRow.profileImage ?? ''),
                placeholder: (context, url) => const CircularProgressIndicator(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
                fit: BoxFit.cover,
              ),
            ),
          ),
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
            isEditing
                ? TextFormField(
              initialValue: dataRow.language,
              onChanged: (value) {
                // dataRow.language = value;
              },
            )
                : Text(dataRow.language ?? 'No Language'),
          ),
          DataCell(
            isEditing
                ? TextFormField(
              initialValue: dataRow.purpose,
              onChanged: (value) {
                // dataRow.purpose = value;
              },
            )
                : Text(dataRow.purpose ?? 'No Purpose'),
          ),
          DataCell(
            ElevatedButton(
              onPressed: () {

              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                backgroundColor: Colors.green,
              ),
              child: const Text(
                'Assign Mentor',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ),
          DataCell(
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {

              },
            ),
          ),
        ],
      );
    }).toList();
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
